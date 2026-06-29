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
