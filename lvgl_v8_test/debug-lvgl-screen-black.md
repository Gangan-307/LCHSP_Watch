# 问题排查记录：LVGL 屏幕不亮与断言崩溃

**状态**：已完成阶段性定位，已收口为“显示验证版”固件，待重新完整编译、烧录并确认首屏显示

## 1. 问题背景

### 1.1 现象

- 烧录固件后设备屏幕不亮，期望显示 SquareLine Studio 导出的 UI。
- 系统启动后在 `main` 线程中触发 `rt_sem_take` 断言，随后崩溃。

### 1.2 关键报错

- `Assertion failed at function:rt_sem_take, line number:329 ,(rt_object_get_type(&sem->parent.parent) == RT_Object_Class_Semaphor)`。

### 1.3 已知工程改动

- `main.c`：从 `lv_example_*` 切换为 `ui_init()`。
- `src/SConscript`：停止编译 `src/examples/**`，改为编译 `src/ui/**`。
- `src/ui/ui.c`：移除颜色深度硬校验；主题初始化按 `LV_USE_THEME_DEFAULT/LV_USE_THEME_BASIC` 条件启用。
- `src/ui/screens/*`：将不存在的字体替换为工程已启用字体。

## 2. 已确认事实

- `ui_init done` 已打印，说明 UI 对象树创建主线已经走通。
- `littlevgl2rtt_init("lcd")` 返回成功，`lv_disp_get_default()` 非空，说明 LVGL 显示链路已成功建立。
- LCD 驱动日志显示 `co5300` 已识别，且 `drv_lcd_fb_init done`，说明 LCD 型号、分辨率、背光及基础显示初始化没有明显异常。
- 两版工程在可见配置层面没有出现决定性的硬件初始化差异，当前问题不属于“换了 SquareLine 导出代码后 LCD 参数被改坏”这一类故障。
- 崩溃稳定发生在第一次 `lv_task_handler()` 期间，而不是 `ui_init()`、LCD 初始化或对象创建阶段。

## 3. 排查过程

### 3.1 第一轮日志分析

#### 初步发现

- 崩溃发生在第一次或早期 `lv_task_handler()` 引发的某个 `rt_sem_take()`。
- 运行时枚举出的 `tp_init`、`lv_lcd`、`lcd_draw`、`ft6146` 等命名信号量，在崩溃前都曾被找到。
- 一条关键日志是 `[lvgl][sem] name=tp_init obj=0x0`，这说明名为 `tp_init` 的信号量对象在某次观测中为 `NULL`。

#### 初步假设

1. `tp_init` 中的 `rt_sem_create("tp_init", ...)` 失败，返回 `NULL`，后续又继续进入 `rt_sem_take`，最终触发断言。
2. `RT_ASSERT` 的平台行为不完整，导致早期错误没有在第一现场停住，从而把真正原因延后暴露。
3. `more_data_lock` 或其底层对象被破坏，导致包装层与实际对象类型不一致。
4. 黑屏表象可能来自首帧尚未完成刷新，而不是纯粹的 LCD 硬件失效。

#### 第一轮动作

- 在 `main.c` 中增加命名信号量探测和 `lv_task_handler()` 前后日志。
- 在 `ui.c` 中增加页面创建顺序日志。
- 在 `lv_lcd.c` 的 `wait_flush_done` 和 `lcd_flush` 前添加日志。
- 在 `drv_touch.c` 中增加 `touch_api_lock`、`current_driver->isr_sem`、`touch_read()` 入口等日志。
- 在 `drv_touch.c` 的 `init` 和 `touch_read` 中补充互斥量类型打印。
- 在 `tp_init` 中为 `rt_sem_create` 和 `rt_thread_create` 增加失败处理。

#### 第一轮用户反馈

- 日志仍然报 `rt_sem_take` 断言。
- `[lvgl][loop] cnt=0 before lv_task_handler scr=0x...` 之后立即崩溃，没有打印 `lv_task_handler ms=...`。
- 另一次日志里 `tp_init` 对象地址又变为非空，这与此前 `0x0` 的结果矛盾，说明至少存在一次“最新固件未真正烧录上板”的可能。

### 3.2 第二轮日志分析

#### 新发现

- 崩溃稳定发生在第一次 `lv_task_handler()` 内部。
- `tp_init`、`tp_ctrl`、`lv_lcd`、`ft6146` 等对象在进主循环前仍可找到。
- 最后一条稳定日志落在 `[lvgl][touch] read ...` 附近。

#### 更新判断

- 核心问题进一步收敛到触摸驱动内部同步对象、输入读取路径或其触发的事件链。
- `RT_ASSERT` 没有在更早的失败点停住程序，导致问题表面看起来像“黑屏”，实际上是触摸路径把系统先打崩。

#### 第二轮动作

- 在 `lv_lcd.c` 中进一步增加 `wait_flush_done` 和 `lcd_flush` 前日志。
- 在 `drv_touch.c` 中增加 `api_lock` 获取前、`current_driver->isr_sem` 等待前和 `touch_read()` 入口日志。

#### 第二轮用户反馈

- 日志最后稳定落在 `[lvgl][touch] read more_data_lock=0x2002e940 current_driver=0x200277a8 last=(1,0,0)`。

### 3.3 触摸驱动专项分析

#### 直接分析结果

- `touch_read()` 本体只调用了 `rt_mutex_take(more_data_lock, ...)`。如果问题纯发生在这里，理论上断言名更可能是 `rt_mutex_take`，而不是 `rt_sem_take`，说明可能还有包装层、底层对象类型异常，或早期对象已损坏。
- `last_rec.event=1` 非常可疑。如果这个默认值在驱动语义里不是“抬起”，LVGL 首轮输入处理就可能把它误判成真实触摸，从而在启动阶段触发不应该触发的交互逻辑。
- 已排除 `rt_device_ops` 字段顺序问题。

#### `RT_ASSERT` 行为异常

- `rtconfig.h` 中 `RT_DEBUG=1`，理论上断言应处于启用状态。
- `RT_ASSERT(tp_init_lock != NULL);` 并未在失败时立即终止，这说明 `rt_assert_handler` 或其依赖的 `rt_hw_fatal_error` 在当前平台上的实现可能不完整。

#### 临时隔离尝试

- 曾尝试在 `drv_touch.c` 中让 `tp_init()` 直接 `return RT_EOK;`，以隔离触摸驱动是否为直接触发源。
- 但用户返回的串口日志并未出现与该修改对应的新打印，进一步说明构建和烧录流程存在版本不一致风险。

## 4. 当前结论

### 4.1 根因判断

- 根本原因不是 LCD 面板、时钟、GPIO、分辨率或 SquareLine 静态资源本身。
- 真正的问题在于：SquareLine 导出的 UI 增加了更积极的输入交互路径，使原本潜伏的触摸驱动同步对象问题在首轮 `lv_task_handler()` 中被稳定触发。
- 直接表现为 `tp_init` 相关同步对象创建失败或状态异常，继而在后续输入处理过程中进入 `rt_sem_take` 断言。

### 4.2 为什么原 example 能亮而导出 UI 不能亮

- 原 example 主要运行 `lv_example_grid_1()`，触摸链路压力较小，输入路径不容易在启动瞬间触发。
- SquareLine 导出的 UI 在多个页面中增加了手势、切屏、键盘、文本框等交互，首轮 `lv_task_handler()` 更早、更频繁地进入输入设备读取和释放等待逻辑。
- 因此“黑屏”并不是显示没初始化，而是系统在首帧真正稳定刷新前就已经因为触摸路径崩溃。

### 4.3 额外风险

- 用户提供的日志前后存在“同一个对象一会为 `NULL` 一会非空”的矛盾，强烈暗示至少发生过一次旧固件或错误固件被烧录的情况。

## 5. 阶段性修复方案：先保屏亮

### 5.1 方案目标

- 在彻底修复触摸驱动之前，优先保证 SquareLine UI 能成功渲染到屏幕上。
- 先把“显示链路是否正常”与“触摸链路是否稳定”拆开验证。

### 5.2 本次修复范围

- 保持 `littlevgl2rtt_init("lcd")` 和 `ui_init()` 的现有调用方式不变。
- 不在本次修复中对触摸驱动做深度重构。
- 临时降级 SquareLine 生成的手势交互，尤其是内部调用 `lv_indev_wait_release(...)` 的路径。
- 保留静态页面创建和首屏加载逻辑，以验证显示流程本身。

### 5.3 具体改动方向

- 暂时移除或禁用由 SquareLine 导出的手势事件处理代码。
- 让程序优先完成 UI 创建和首屏显示，不再依赖“手势释放”逻辑完成首帧稳定运行。
- 同步更新本文档和相关规格文档，确保“临时方案”和“完整修复”边界清晰。

### 5.4 已实施改动

- 在 `project/proj.conf` 中加入 `# CONFIG_BSP_USING_TOUCHD is not set`，临时从配置层关闭触摸设备。
- 在 `src/ui/screens/ui_Screen2.c`、`src/ui/screens/ui_ScreenHome.c`、`src/ui/screens/ui_Screen3.c` 中移除了主面板手势切屏注册，并将对应手势事件处理函数降级为空操作。
- 在 `src/main.c` 中保留轻量启动日志，只输出当前是否关闭触摸、`littlevgl2rtt_init("lcd")` 初始化结果以及 `ui_init done`，不再保留大批量信号量枚举和主循环插桩日志。

### 5.5 修改前后的数据流

- 修改前：系统启动 -> LVGL 初始化 -> UI 初始化 -> 首次执行 `lv_task_handler()` -> 进入触摸读取路径 -> 触发 `rt_sem_take` 断言 -> 屏幕无可见结果。
- 修改后：系统启动 -> LVGL 初始化 -> UI 初始化 -> 允许首帧渲染 -> 在不依赖高风险触摸释放逻辑的前提下验证屏幕可见。

### 5.6 风险说明

- 这个临时版本中，触摸导航和部分交互功能可能暂时不可用。
- 如果触摸驱动即使在移除手势回调后仍然导致崩溃，则下一阶段必须下沉到驱动层继续修复 `tp_init`、互斥量、信号量和线程生命周期。

### 5.7 当前验证版的判定标准

- 当前默认交付物不是“触摸可用版”，而是“显示验证版”。
- 这版固件的目标只有一个：确认 SquareLine 导出的 UI 页面在关闭触摸输入后能够稳定显示。
- 如果这版固件已经能亮屏，则说明 LCD 初始化、LVGL 显示注册、UI 对象树创建和首帧渲染主路径是成立的。
- 如果这版固件仍然黑屏或异常退出，则问题范围需要重新收敛到显示链路、构建产物一致性或更底层初始化流程，而不再只是触摸路径。

## 6. 验证方法

1. 执行一次彻底的 `clean` 和 `rebuild`，确保旧产物被清理干净。
2. 烧录最新生成的固件，确认实际烧录的是当前构建结果。
3. 从设备上电开始抓取完整串口日志。
4. 重点验证以下结果：
   - 能看到 `touch input disabled by temporary workaround`。
   - 能看到 `littlevgl2rtt_init ok`。
   - 能看到 `ui_init done`。
   - 屏幕至少能显示一个 SquareLine 页面。
   - 日志中不再需要出现此前的大量 `tp_init`、`lv_lcd`、`[lvgl][loop]` 调试插桩输出。

## 7. 当前建议的验收记录格式

- 记录本次使用的固件构建时间或版本标记，避免再次混入旧固件。
- 保存上电到首屏显示完成的完整串口日志。
- 用照片或视频确认屏幕是否已显示 Home 页或其他 SquareLine 页面。
- 若仍异常，优先记录最后一条串口日志，而不是继续叠加新的插桩。

## 8. 后续完整修复计划

- 修复 `tp_init`、`more_data_lock`、`isr_sem` 等同步对象的创建、销毁和失败处理逻辑。
- 明确初始化 `last_rec.event` 的默认状态，避免首轮被误判为真实触摸。
- 检查 BSP 中 `rt_hw_fatal_error` 的实现，确保断言能在第一现场停住。
- 待触摸链路稳定后，再逐步恢复手势切屏和键盘交互。

## 9. 退出说明

- 如果不继续当前调试，回复“终止调试”，后续可移除调试插桩并单独输出总结版本。

"""# 问题排查记录：LVGL 屏幕点亮与输入崩溃分析

**状态**：屏幕已成功点亮，构建配置不一致问题已定位并解决，准备清理调试插桩并逐步恢复触摸功能。

## 1. 问题背景

### 1.1 初始现象

- 烧录固件后设备屏幕不亮，期望显示 SquareLine Studio 导出的 UI。
- 系统启动后在 `main` 线程中触发 `rt_sem_take` 断言，随后崩溃。

### 1.2 关键报错

- `Assertion failed at function:rt_sem_take, line number:329 ,(rt_object_get_type(&sem->parent.parent) == RT_Object_Class_Semaphor)`。

### 1.3 已知工程改动

- `main.c`：从 `lv_example_*` 切换为 `ui_init()`。
- `src/SConscript`：停止编译 `src/examples/**`，改为编译 `src/ui/**`。
- `src/ui/ui.c`：移除颜色深度硬校验；主题初始化按 `LV_USE_THEME_DEFAULT/LV_USE_THEME_BASIC` 条件启用。
- `src/ui/screens/*`：将不存在的字体替换为工程已启用字体。
- `project/proj.conf`: 加入 `# CONFIG_BSP_USING_TOUCHD is not set` 临时禁用触摸。
- `src/ui/screens/*.c`：移除了主面板手势切屏注册，并将对应手势事件处理函数降级为空操作。

## 2. 排查过程与关键发现

### 2.1 初始日志分析 (屏幕未亮起阶段)

- `ui_init done` 已打印，说明 UI 对象树创建主线已经走通。
- `littlevgl2rtt_init("lcd")` 返回成功，`lv_disp_get_default()` 非空，说明 LVGL 显示链路已成功建立。
- LCD 驱动日志显示 `co5300` 已识别，且 `drv_lcd_fb_init done`，说明 LCD 型号、分辨率、背光及基础显示初始化没有明显异常。
- 崩溃稳定发生在第一次 `lv_task_handler()` 期间，而不是 `ui_init()`、LCD 初始化或对象创建阶段。
- **关键问题**：日志中持续打印 `[lvgl][boot] ... LV_USE_THEME_BASIC=1 ...`，与 `project/proj.conf` 中 `# CONFIG_LV_USE_THEME_BASIC is not set` 的设置不符，表明构建配置存在不一致。
- **崩溃点收敛**：通过增加调试插桩，最终定位到崩溃发生精确在 `[lvgl][keypad] read` 日志之后，即 `keypad_read` 函数内部在尝试获取信号量时触发了 `rt_sem_take` 断言。

### 2.2 根因定位：构建配置覆盖机制

- **根本原因**：经过排查，发现问题并非出在代码逻辑错误，而是由于 **VSCode 插件在编译时，会通过之前固定的 `menuconfig` 配置来重新生成 `config` 文件**。这导致手动在 `project/proj.conf` 中进行的配置修改（例如 `# CONFIG_LV_USE_THEME_BASIC is not set` 或 `CONFIG_LV_USE_THEME_BASIC=n`）会被 `menuconfig` 生成的配置覆盖，未能真正生效。
- **解决方案**：必须通过运行 `scons --menuconfig` 命令，在图形化配置界面中手动调整并保存配置（例如禁用 `LV_USE_THEME_BASIC`），才能确保配置项被正确写入 `rtconfig.h` 文件并应用于编译。

### 2.3 结果：屏幕成功点亮

- 通过 `scons --menuconfig` 重新配置，确保所有 LVGL 相关宏（包括 `LV_USE_THEME_BASIC`）与预期一致后，重新编译烧录，屏幕成功点亮。
- 这也间接解决了之前 `keypad_read` 函数内部的 `rt_sem_take` 断言问题，很可能是在配置调整后，相关的键盘输入设备被正确禁用或其驱动内部的信号量初始化得到了修正。

## 3. 最终结论

- **屏幕不亮并非显示硬件或 LVGL 核心显示驱动问题。**
- **根本原因在于构建系统配置的覆盖机制**：VSCode 插件的自动 `menuconfig` 流程导致手动修改的 `proj.conf` 配置未生效。这使得 LVGL 模块在非预期配置下运行，间接触发了 `keypad_read` 函数内部的信号量异常，导致 `main` 线程崩溃，从而屏幕无法点亮。
- **解决方案**：通过 `scons --menuconfig` 手动管理配置，确保 `rtconfig.h` 文件正确反映项目意图。

## 4. 解决后的验证标准

- **已解决配置不一致问题**：日志中 `[lvgl][boot] ... LV_USE_THEME_BASIC=0 ...` (或期望值) 将正确显示。
- **屏幕成功点亮**：设备上电后能正常显示 SquareLine Studio 导出的 UI 页面。
- **无 `rt_sem_take` 断言**：程序不再在 `keypad_read` 或其他输入路径处崩溃。

## 5. 后续计划

1.  **清理调试插桩**：移除 `main.c`、SDK 的 `lvgl_drv.c`、`lv_keypad.c`、`lv_wheel.c`、`lv_lcd.c` 中为排查问题而临时添加的调试日志，恢复代码的整洁性。
2.  **逐步恢复触摸功能**：
    *   在 `menuconfig` 中重新启用触摸设备（例如 `CONFIG_BSP_USING_TOUCHD`）。
    *   深入排查 `drv_touch.c` 中 `tp_init`、信号量 (`tp_init_lock`、`more_data_lock`、`isr_sem`) 的创建、销毁和失败处理逻辑，确保其健壮性。
    *   明确初始化 `last_rec.event` 的默认状态，避免首轮输入处理的误判。
    *   在触摸链路稳定后，逐步恢复 SquareLine UI 中与手势、`lv_indev_wait_release()` 相关的交互逻辑。
3.  **完善 `rt_hw_fatal_error`**：检查 BSP 中 `rt_hw_fatal_error` 的实现，确保断言能在第一现场停住，便于未来快速定位问题。

"""
# Debug Session: lvgl-semtake-crash [OPEN]

## 1. 现象

- 固件打印 `touch input disabled by temporary workaround`，说明应用层当前按“显示验证版”路径启动。
- `littlevgl2rtt_init("lcd")` 成功，LCD 识别为 `CO5300`，`drv_lcd_fb_init done` 已打印。
- `ui_init done` 已打印，说明 UI 对象树创建完成且首屏已装载。
- 随后主线程仍然触发 `rt_sem_take` 断言并进入 fatal error。

## 2. 本轮最新证据

- 最新串口日志显示 `Semaphore Info` 中没有 `tp_init`、`tp_ctrl`，只有 `lv_lcd`、`lcd_msg`、`lcd_draw`、`drv_lcd` 等对象。
- 最新串口日志仍出现 `[lvgl][touch] skip touch_init for isolation`，说明当前固件至少包含“跳过 touch_init”分支。
- 断言发生点依然在 `main` 线程，时间上位于 `ui_init done` 之后、首轮或早期 `lv_task_handler()` 期间。

## 3. 可证伪假设

### 假设 H1

- 触摸驱动虽然被跳过初始化，但 `littlevgl2rtt` 或其他输入注册链路仍保留了一个无效的信号量句柄，首轮 `lv_task_handler()` 在读取输入或相关异步对象时命中了 `rt_sem_take`。

### 假设 H2

- 当前崩溃已不再来自触摸链路，而是来自显示刷新链路中的某个信号量对象被错误传入 `rt_sem_take`，例如 `lv_lcd`、`lcd_msg`、`lcd_draw`、`drv_lcd` 之一。

### 假设 H3

- 这次烧录的固件并非完全对应当前工作区源码，日志里的 `LV_USE_THEME_BASIC=1`、`skip touch_init for isolation` 与当前工程文件存在偏差，说明构建产物仍有版本不一致风险。

### 假设 H4

- `ui_init()` 成功不代表首帧无问题，某个页面加载后的延迟任务、动画、输入组、键盘控件或事件回调在第一次 `lv_task_handler()` 调度时触发了非法对象访问，最终走入 `rt_sem_take` 断言。

### 假设 H5

- `rt_sem_take` 断言本身被更早的内存破坏“误伤”，根因是 UI 初始化或底层库中的对象写越界，导致后续任何一个合法信号量地址在取类型时都已损坏。

## 4. 本轮计划

- 先补最小化插桩，明确断言前最后一个经过的函数边界。
- 优先判断问题究竟位于输入链路、显示链路，还是 `lv_task_handler()` 内的页面任务调度。
- 在拿到新证据前，不直接改业务逻辑。

## 5. 已添加插桩

- `lvgl_v8_test/src/main.c`
  - 首轮 `lv_task_handler()` 前后各打一条日志，仅记录前 2 次循环。
- `middleware/lvgl/lv_drivers/lvgl_drv.c`
  - 记录 `lv_lcd_init()` 返回的 `disp` 指针。
  - 记录 `keypad_init()`、`wheel_init()` 完成边界。
- `middleware/lvgl/lv_drivers/lv_keypad.c`
  - 记录 `keypad` 输入设备注册结果。
  - 记录前 4 次 `keypad_read()` 调用。
- `middleware/lvgl/lv_drivers/lv_wheel.c`
  - 记录 `wheel` 设备是否存在及输入设备注册结果。
  - 记录前 4 次 `wheel` 读取回调。
- `middleware/lvgl/lv_drivers/lv_lcd.c`
  - 记录 `lcd_sema` 初始化后的地址、名称和对象类型。

## 6. 等待用户回传

- 需要用户重新 `clean + rebuild + reflash` 后回传完整串口日志。
- 重点看以下日志谁是断言前最后一条：
  - `[lvgl][hal] lv_lcd_init ...`
  - `[lvgl][hal] keypad_init done`
  - `[lvgl][hal] wheel_init done`
  - `[lvgl][keypad] read ...`
  - `[lvgl][wheel] read ...`
  - `[lvgl][lcd] sem init ...`
  - `[lvgl][loop] before ...`
  - `[lvgl][loop] after ...`

## 7. 新阻塞项：下载失败

- 用户在重新烧录阶段未进入运行时验证，下载工具先失败。
- 关键错误为：
  - `called Result::unwrap() on an Err value: Error { kind: NoDevice, description: "拒绝访问。" }`
- 当前判断：
  - 这不是新的运行时崩溃证据，而是下载链路/设备访问权限问题。
  - 在该问题解决前，无法确认新增插桩是否已真正烧录到板子。
- 优先排查方向：
  - 串口监视器、下载工具或其他上位机程序占用了同一设备。
  - 板卡 USB 权限或驱动状态异常，导致 `sftool` 无法独占访问。
  - 下载目标设备未处于可识别状态，工具把“无法打开设备”折叠成 `NoDevice + 拒绝访问`。
