# HSP Watch

基于 SiFli SF32LB52 黄山派开发板的智能手表固件。项目面向 390 x 450
椭圆形触摸屏，使用 SiFli SDK v2.5、RT-Thread 和 LVGL v8.3.11，包含手表
UI、板载硬件服务、TF 卡应用、经典蓝牙音频控制和 Android BLE 配套协议。

当前对外固件版本：`0.3.0`

> 仓库主分支已经包含 `0.3.0` 之后的 TF 文件管理、录音、TF 音乐和内部存储
> 改动，但协议上报版本仍为 `0.3.0`。发布新固件前应同步修改
> `HSP_WATCH_FIRMWARE_VERSION` 和本文更新记录。

## 项目概览

| 项目 | 当前配置 |
| --- | --- |
| 芯片/开发板 | SiFli SF32LB52 / `sf32lb52-lchspi-ulp_hcpu` |
| 屏幕 | 390 x 450 CO5300 椭圆形触摸屏 |
| SDK | SiFli SDK v2.5 |
| 系统 | RT-Thread |
| GUI | LVGL v8.3.11 + `littlevgl2rtt` |
| 构建系统 | SiFli SDK SCons |
| 存储 | 内部 NOR FAT 文件系统 + SPI TF 卡 FAT 文件系统 |
| 蓝牙 | BLE GATT、Battery Service、A2DP/AVRCP、PAN、HID |
| 音频 | 本地 MP3/WAV 播放、麦克风 WAV 录音、蓝牙音乐控制 |

## 实机效果

<table>
  <tr>
    <td align="center"><img src="image/number/home_time.jpg" alt="图片数字表盘" width="280"></td>
    <td align="center"><img src="image/number/bee_app.jpg" alt="动态蜂窝应用菜单" width="280"></td>
    <td align="center"><img src="image/number/music.jpg" alt="音乐控制页面" width="280"></td>
  </tr>
  <tr>
    <td align="center">图片数字表盘</td>
    <td align="center">动态蜂窝应用菜单</td>
    <td align="center">音乐控制页面</td>
  </tr>
</table>

## 功能状态

| 模块 | 状态 | 说明 |
| --- | --- | --- |
| 表盘、控制中心、通知 | 已实现 | RTC、电量、活动环、手势导航和通知详情 |
| 蜂窝应用菜单 | 已实现 | 23 个图标、惯性拖动、缩放和自动吸附 |
| 系统设置与电源管理 | 已实现 | 亮度、息屏、抬腕、音量、震动、关机和重启 |
| 闹钟、日历、计算器 | 已实现 | 包含持久化、农历/节日和连续运算 |
| 喝水提醒、番茄钟 | 已实现 | 后台计时、震动提醒和配置持久化 |
| RGB 灯、指南针、活动数据 | 已实现 | 对接板载 SK6812、MMC56X3 和 LSM6DSL |
| TF 文件管理 | 已实现基础版 | 目录浏览、排序、文件大小和文本预览，只读 |
| TF 录音 | 已实现基础版 | 16 kHz 单声道 PCM WAV，支持列表和回放 |
| 音乐 | 已实现双模式 | TF 卡 MP3/WAV 播放和手机 AVRCP 控制 |
| 手机通知、天气、位置 | 依赖配套 App | 通过自定义 BLE GATT 协议同步 |
| 遥控拍照 | 依赖手机 HID | 支持立即、3 秒和 5 秒倒计时快门 |
| 音乐封面、照片预览 | 联调中 | BLE 接收与文件保存已实现，真机解码显示仍需验证 |
| PAN/NTP | 部分实现 | 底层连接和 NTP 已接入，设置页 PAN 偏好尚未完整驱动服务 |
| PAN OTA | 独立示例 | 位于 `pan_ota/`，尚未合并为主固件升级流程 |

## 快速开始

### 1. 环境准备

- Windows 10/11。
- SiFli SDK v2.5 和配套 ARM GCC/SCons 工具链。
- VSCode + SiFli SDK 插件，或已执行 SDK `set_env.bat` 的命令行。
- 黄山派 SF32LB52 ULP 开发板及可用串口/下载器。

命令行构建前，确认 `SIFLI_SDK` 已指向 SDK v2.5 根目录：

```bat
cd D:\path\to\SiFli-SDK-V2.5
set_env.bat
```

### 2. 编译主固件

```bash
cd project
scons --board=sf32lb52-lchspi-ulp_hcpu -j8
```

构建成功后，主要产物位于：

```text
project/build_sf32lb52-lchspi-ulp_hcpu/main.bin
project/build_sf32lb52-lchspi-ulp_hcpu/main.elf
project/build_sf32lb52-lchspi-ulp_hcpu/download.bat
project/build_sf32lb52-lchspi-ulp_hcpu/uart_download.bat
```

`main.bin` 只是 HCPU 应用镜像。首次烧录或分区发生变化时，应使用 SDK 生成的完整
下载脚本，确保 bootloader、LCPU、flash table 和应用镜像匹配。

### 3. 烧录

进入构建目录后，根据本机连接方式使用 SiFli 下载脚本：

```bat
cd project\build_sf32lb52-lchspi-ulp_hcpu
uart_download.bat
```

也可以使用 VSCode SiFli 插件的 Download/Flash 操作。串口号、下载模式和驱动安装
以本地 SDK 快速入门文档为准。

### 4. 准备 TF 卡

1. 建议使用 PC 格式化为 FAT/FAT32 的 TF 卡，当前不建议使用 exFAT。
2. 在卡根目录创建 `music` 文件夹，并放入 `.mp3` 或 `.wav` 文件。
3. `record` 文件夹无需手工创建，首次录音时会自动创建。
4. 从蜂窝页进入音乐应用，选择“TF卡”并开始播放。
5. 当前“骑行秒表”图标临时作为 TF 文件管理器入口。

标准 PC FAT 分区会优先直接挂载；如果挂载失败，代码会兼容 `spi_tf` 参考项目的
固定偏移双卷布局。

## 主要交互

### 主页手势

| 操作 | 目标页面 |
| --- | --- |
| 左滑 | 动态蜂窝应用菜单 |
| 右滑 | 音乐页面 |
| 上滑 | 通知列表 |
| 下滑 | 控制中心 |

### 实体按键

| 场景 | KEY1 | KEY2 |
| --- | --- | --- |
| 普通页面短按 | 返回上一级 | 暂无操作 |
| 普通页面长按 | 1.5 秒息屏 | 2 秒打开关机/重启菜单并震动 |
| 音乐页面短按 | 增加音量 | 降低音量 |
| 屏幕关闭时 | 仅唤醒屏幕 | 仅唤醒屏幕 |
| 休眠关机后 | 无开机功能 | 持续按住约 3 秒开机 |

屏幕关闭后的第一次触摸或按键只负责唤醒，不会同时触发原页面操作。

## 核心功能

### 表盘与蜂窝菜单

- 使用透明 PNG 数字资源组合显示 RTC 时间，并根据透明可见区域动态居中。
- 显示日期、电量、充电状态、蓝牙状态、步数、卡路里、距离和三色活动环。
- 存在未读消息时显示红点。
- 23 个应用图标按六边形螺旋排列，支持任意方向拖动、惯性预测、最近图标吸附、
  点击前自动居中和椭圆屏边缘缩放。
- 世界时钟图标当前作为返回主页的快捷入口。

### 控制中心与设置

- 蓝牙、RGB 灯、静音、抬腕亮屏和查找手机快捷开关。
- 屏幕亮度和音乐音量滑块。
- 设置页提供息屏时间、震动、勿扰、低电量模式、电池信息和系统信息。
- 设置保存到 `/watch_settings.bin`，重启后自动恢复。
- 支持关机、重启和二次确认；关机进入 PMU Hibernate。

### TF 文件管理

- 通过 SPI MSD + DFS ElmFat 挂载 TF 卡，正常路径为 `/tf`。
- 文件夹优先、名称排序，单次最多显示 80 个条目。
- 支持进入子目录、返回上级、刷新、显示文件大小。
- 文本文件预览前 2048 字节；检测到明显二进制内容时只显示提示。
- 当前为只读浏览器，不支持新建、复制、移动、重命名或删除。

### 录音

- 从蜂窝菜单“录音”进入，点击主按钮开始或停止录音。
- 使用板载麦克风录制 16 kHz、单声道、16-bit PCM WAV。
- 文件保存到 TF 卡 `/record`，命名格式为
  `REC_YYYYMMDD_HHMMSS.wav`，重名时自动追加序号。
- 停止录音时回写 WAV 头并 `fsync`，空录音或失败文件会被清理。
- 页面按时间倒序列出最近 12 条录音，显示时长并支持播放/停止。
- 当前不支持在手表端删除或重命名录音。

### 音乐

音乐页提供“TF卡”和“蓝牙”两种互斥模式：

- TF 模式扫描 `/music` 目录下的 `.mp3` 和 `.wav`，按文件名排序，最多 64 首。
- 支持上一首、播放/暂停、下一首、自动下一首、进度、总时长和本地音量。
- 当前只扫描 `music` 根目录，不递归扫描子文件夹。
- 蓝牙模式同步 A2DP/AVRCP 连接、播放状态、曲名、歌手、专辑、进度和绝对音量。
- 支持上一首、播放/暂停、下一首和音量控制。
- 配套 App 可分包传输歌词及最大 8 KiB、128 x 128 的 JPEG 封面，包含 generation、
  CRC32、超时和重试校验；封面保存到内部存储 `/cover.jpg`。
- 原生 AVRCP Cover Art 保留为配套 App 不可用时的回退路径。

### 通知与手机数据

- 支持短信、微信、QQ/TIM 通知，手表端最多缓存 5 条。
- 显示来源、时间、标题、正文预览和详情，支持单条删除和全部清除。
- 删除操作会反向同步到配套 App 的缓存。
- 新消息到达时震动、亮屏并展示；无操作后返回主页并保留未读状态。
- 手机同步城市、经纬度、天气代码、温湿度、歌词、封面和最近照片。

### 闹钟、喝水与番茄钟

- 最多 5 个闹钟，支持一次、每天、工作日和自定义星期重复。
- 到点后亮屏并周期震动，可关闭或稍后 5 分钟。
- 喝水提醒支持时间范围、30 分钟至 6 小时间隔、每日目标和稍后提醒。
- 番茄钟支持专注/短休息/长休息、自定义时长和今日统计。
- 配置分别持久化到 `/alarm_config.bin`、`/water_config.bin` 和
  `/tomato_config.bin`。

### 日历、计算器与木鱼

- 日历覆盖 2000 至 2099 年，包含农历干支、农历日期、ISO 周数和节日。
- 计算器支持四则运算、百分比、小数、连续运算、实时预计算和退格。
- 木鱼支持点击缩放、短震和“功德 +1”上浮动画。

### 遥控拍照与指南针

- 通过蓝牙 HID 控制手机系统相机，支持立即、3 秒和 5 秒倒计时。
- 配套 App 可将最近照片压缩后分包回传，最大 16 KiB、最长边 160 px，保存到
  `/camera.jpg`。
- 预览页设计了缩放、平移和适配显示；JPEG 真机解码仍在联调。
- 指南针以 20 Hz 读取 MMC56X3，显示航向、八方位、磁场强度、校准进度和干扰状态。

### 电池、活动与电源

- GPADC 电压采样结合充放电曲线、滤波和变化限制计算电量。
- 识别外部电源和充电状态，提供低电提醒、5% 自动关机倒计时和充电震动反馈。
- LSM6DSL 硬件计步器每秒更新，处理 16 位回绕、异常跳变和跨日清零。
- 按每 1000 步约 40 kcal、每步约 0.7 m 估算活动数据。
- 电量、充电、步数、卡路里和距离同时发布给 BLE 服务和主页 UI。

## 存储布局

### 内部 NOR

主固件将分区表中的 4 MiB `FS_REGION` 注册为 MTD 设备 `musicfs`，挂载到 `/`。
首次启动时如果没有有效 FAT 文件系统，会格式化该内部区域后重新挂载。该操作不会
格式化 TF 卡。

内部文件系统当前保存：

```text
/watch_settings.bin
/alarm_config.bin
/water_config.bin
/tomato_config.bin
/cover.jpg
/camera.jpg
```

内部 NOR 擦除扇区为 4096 字节，因此 `project/proj.conf` 必须保持：

```text
CONFIG_RT_DFS_ELM_MAX_SECTOR_SIZE=4096
```

该最大值同时兼容 TF 卡常见的 512 字节逻辑扇区。

### TF 卡

```text
/tf/                    标准 FAT 卡挂载点
/tf/music/              MP3/WAV 音乐
/tf/record/             手表录音
/tf/misc/               仅旧版 spi_tf 双卷布局可能存在
```

当内部根文件系统不可用时，TF 卡会回退挂载到 `/`，此时音乐和录音路径分别为
`/music`、`/record`。

## BLE 配套协议

手表作为 BLE Peripheral/GATT Server，手机作为 Central/GATT Client。自定义服务包含：

| 特征 | 方向 | 用途 |
| --- | --- | --- |
| `CONTROL` | 手机 -> 手表 | 查找手表及停止振动 |
| `STATE` | 手表 -> 手机 | 查找手机、通知管理、拍照和照片预览请求 |
| `SYNC` | 手机 -> 手表 | 时间、位置、天气、通知、歌词、封面和照片同步 |
| `DEVICE_STATUS` | 手表 -> 手机 | 电量、充电、固件版本、步数、卡路里和距离 |

- Android 端请求 MTU 247，协商后 `SYNC` 单包有效载荷最大 244 字节。
- MTU 协商失败时回退到默认 20 字节有效载荷。
- 封面和照片采用 begin/data + generation + offset + CRC32 的分包模型。
- 自定义服务当前使用 `NOAUTH` 权限，不应视为已实现业务层认证或加密。

Android 配套 App 在本地开发环境中位于 `hsp/`，该目录不随本仓库发布。公开项目见
[LCHSP_Watch_App](https://github.com/Gangan-307/LCHSP_Watch_App)。

## 软件架构

```mermaid
flowchart TD
    HW[SF32LB52 板级硬件] --> SDK[SiFli HAL / RT-Thread / BT Stack]
    SDK --> DRV[src/drivers<br/>ADC 显示 RGB 震动]
    SDK --> BT[src/bluetooth<br/>BLE AVRCP PAN HID]
    DRV --> SVC[src/services<br/>存储 电池 提醒 录音 音乐 同步]
    BT --> SVC
    SVC --> UI[src/ui<br/>主页 蜂窝菜单 应用页面]
    RES[image + strings] --> UI
    APP[src/app/main.c] --> DRV
    APP --> SVC
    APP --> UI
    PHONE[Android 配套 App] <--> BT
```

主线程负责固定顺序初始化和 `lv_timer_handler()` 循环；音频、蓝牙、TF 音乐、录音
播放、传感器和提醒任务由 RT-Thread 线程、timer、mailbox 或消息队列驱动。多个服务
通过 snapshot + mutex 向 UI 暴露状态。

## 工程结构

```text
src/app/                 固件入口和服务初始化
src/bluetooth/           BLE 自定义协议、Battery Service、音乐、PAN/HID
src/drivers/             ADC、显示电源、RGB 灯和震动驱动
src/services/            存储、TF、音频、提醒、同步、电池、活动和电源服务
src/ui/alarm/            闹钟
src/ui/app_grid/         动态蜂窝应用菜单
src/ui/calculator/       计算器
src/ui/calendar/         公历、农历和节日
src/ui/camera/           遥控拍照和照片预览
src/ui/compass/          三轴地磁指南针
src/ui/details/          天气和位置详情
src/ui/music/            TF/蓝牙双模式音乐页
src/ui/record/           TF 录音页
src/ui/tf_file_manager/  TF 文件管理器
src/ui/settings/         系统设置、电池管理和系统信息
src/ui/system/           关机和重启界面
src/ui/tomato/           番茄钟
src/ui/water/            喝水提醒
src/ui/generated/        SquareLine 代码及现有手工扩展
src/resource/strings/    中英文资源 JSON
image/                   LVGL 图片和实机照片资源
project/                 主固件 SCons 工程
simulator/               Windows/MSVC LVGL 模拟器工程
mp3_sd_player/           SDK TF 音乐移植参考工程
pan_ota/                 SDK PAN OTA 独立参考工程
docs/                    架构、调试和问题分析文档
```

`src/SConscript` 是主固件源码清单的权威入口。`src/CMakeLists.txt` 和
`src/filelist.txt` 尚未覆盖全部新增模块，不应替代 SCons 判断实际编译内容。

`src/ui/generated/` 中已经混入较多手工扩展，不能直接用 SquareLine 整体覆盖。

## 独立示例工程

### `mp3_sd_player/`

SiFli 本地音乐示例的移植参考，用于验证 SPI MSD、ElmFat、Audio Manager 和
`audio_mp3ctrl`。主固件已提取并重写所需逻辑，日常开发不需要编译该目录。

### `pan_ota/`

SiFli PAN OTA 示例，包含手机蓝牙网络共享、设备注册、版本查询和 DFU PAN 下载流程。
它有独立的 `project/`、配置和 README，不是主固件的一部分。主固件虽然启用了普通
DFU 构建，但没有启用 `CONFIG_USING_DFU_PAN`，也没有调用 `AddDFU_PAN()`。

## 常见问题

### `Cannot create /tf: -2` 或 TF 挂载失败

- 确认内部文件系统先成功挂载到 `/`，启动日志应包含 `storage:`。
- 确认 TF 卡已格式化为 FAT/FAT32，并能被 PC 正常读取。
- 确认 `sd0` SPI MSD 设备已经创建。
- 当前代码会先尝试整卡 FAT，再尝试 `spi_tf` 的固定偏移布局。

### `storage: mount failed, errno=0`

检查生成配置中的 `RT_DFS_ELM_MAX_SECTOR_SIZE` 是否为 `4096`。内部 NOR 的扇区大于
FatFs 最大扇区配置时，挂载会在进入 `f_mount()` 前失败，错误码可能仍为 0。

### `struct dirent`、`DIR` 或 `opendir` 重定义

RT-Thread DFS 和 newlib 都可能提供 `dirent` 定义。项目文件应使用 SDK 的
`dfs_file.h`/`dfs_posix.h`，不要再同时包含标准库 `<dirent.h>`。

### 日志显示封面已保存，但界面仍无封面

`music: phone cover saved` 表示 BLE、CRC 和文件写入已经成功。若随后只看到
`displaying without JPG zoom`，问题位于 LVGL/JPEG 解码和可用内存，不是手机传输或
TF 卡。当前这条显示链路仍在真机联调。

### NTP 一直提示 DNS 解析失败

确认手机已开启蓝牙网络共享、PAN profile 已连接，并且手机本身可以联网。设置页的
PAN 偏好目前不会完整建立连接，可通过 FinSH 执行 `pan_cmd conn_pan` 进行调试。

## 当前限制

- 蜂窝菜单中的活动、电子书、笔记、相册和 SOS 仍只有图标或点击反馈。
- “骑行秒表”当前临时打开 TF 文件管理器，尚未实现骑行计时。
- 保险箱当前只进入动态 GIF 展示页，没有密码、加密或数据保管能力。
- TF 文件管理器为只读；录音页没有删除、重命名和分享功能。
- TF 音乐只扫描 `/music` 第一层，最多 64 首，不读取专辑封面或 ID3 元数据。
- 音乐封面和手机照片已经可以传输并保存，但 LVGL JPEG 真机显示仍存在内存/解码问题。
- 蓝牙设置中的 PAN 开关只保存页面内偏好，底层 PAN/NTP 尚未完整受该开关控制。
- 连接新手机、移除单个配对、清除全部配对、通话和部分蓝牙诊断入口仍为预留。
- 位置页是坐标信息和静态示意图，不包含地图瓦片、路线规划或导航。
- 活动累计和 RGB 参数仍主要保存在 RAM，重启后不会完整恢复。
- 番茄钟运行中的倒计时不会跨设备重启恢复，提示音尚未接入实际资源。
- 指南针是水平面二维航向计算，倾斜佩戴会产生误差，每台设备需要真机校准。
- 模拟器不能替代 TF、音频、蓝牙、传感器和电源管理的真机测试。
- 项目当前未声明开源许可证。

## 开发注意事项

- 主固件只使用 LVGL v8 API，不要混用 LVGL v9 接口。
- 手工修改文件使用 LF 行尾，避免 Windows CRLF 让整个配置文件产生无效 diff。
- 修改 `project/proj.conf` 后应检查生成的 `.config` 和 `rtconfig.h`，必要时执行全量构建。
- 新增模块时更新 `src/SConscript` 的目录列表；如需模拟器/IDE 支持，再同步辅助清单。
- BLE 协议改动必须同步 Android App，并考虑旧版本 MTU 和包格式兼容。
- 内部存储格式化只允许作用于 `FS_REGION`，不能对 TF 卡或其它 flash 分区自动格式化。
- `src/ui/generated/` 不能无审查重新生成；先确认哪些文件含手工业务逻辑。

进一步的架构分析见 [代码架构分析与优化方向](docs/代码架构分析与优化方向.md)。
LVGL 启动和并发问题可参考：

- [LVGL 屏幕不亮问题分析与修复](docs/LVGL屏幕不亮问题分析与修复.md)
- [LVGL semaphore 崩溃调试记录](docs/debug-lvgl-semtake-crash.md)

## 更新记录

| 固件版本 | 日期 | 主要修改 |
| --- | --- | --- |
| 开发中 | 2026-09-02 | 增加 TF 文件管理、TF WAV 录音、TF/蓝牙双模式音乐、内部 NOR 文件系统初始化，并加入独立 PAN OTA 示例。 |
| `0.3.0` | 2026-08-21 | 新增闹钟、计算器、喝水提醒、番茄钟、日历、遥控拍照、图片预览、指南针和系统设置。 |
| `0.2.0` | 2026-08-14 | 完善蜂窝菜单、图片表盘、导航、实体按键、电源、通知、音乐、活动、充电和震动反馈。 |
| `0.1.0` | 2026-08-07 | 建立手表固件基础功能，接入 BLE 状态同步和基础 LVGL 页面。 |

## 许可证

仓库当前没有根级许可证文件。部分 SiFli 示例源文件保留其原有 Apache-2.0 文件头，
这不等同于整个项目已经按 Apache-2.0 发布。在补充正式 `LICENSE` 前，请勿假定仓库
整体具备明确的再分发授权。
