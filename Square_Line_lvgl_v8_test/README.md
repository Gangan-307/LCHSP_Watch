# HSP Watch

基于 SiFli SF32LB52 黄山派的智能手表固件项目，面向 390 x 450 椭圆屏，使用 RT-Thread 与 LVGL v8 构建本地交互界面和 BLE 连接能力。

## 已实现功能

- 表盘主页、控制中心、设置、灯光和蓝牙设置等界面
- 电池电量与充电状态显示、屏幕亮度、音量和静音控制
- RGB 灯开关、颜色、亮度、自动关闭与基础灯效
- 抬腕唤醒、振动反馈、关机与按键唤醒相关控制
- 蓝牙开关与连接状态显示
- 手表与 Android 手机的 BLE 双向查找基础功能
- BLE Battery Service 电量上报

## 工程结构

```text
src/       固件应用、驱动、服务、蓝牙与 LVGL 界面源码
project/   SiFli SDK 的 SCons 构建工程与板级配置
hsp/       Android 手表伴侣应用（BLE 查找功能）
design/    网页版 UI 设计与交互原型
```

## 构建固件

推荐使用 VSCode + SiFli SDK 插件打开 `project/` 下的 HCPU 构建配置并编译下载。

命令行构建前，需要先在 SiFli SDK 根目录执行 `set_env.bat`，使环境变量 `SIFLI_SDK` 指向 SDK；随后进入 `project/` 目录，使用 SDK 提供的 SCons 构建流程编译 `build_sf32lb52-lchspi-ulp_hcpu` 配置。

```bash
cd project
scons --board=sf32lb52-lchspi-ulp_hcpu
```

实际命令会随 SDK 安装方式和 IDE 配置有所不同，以本地 SiFli SDK 的构建说明为准。

## Android 伴侣应用

Android 端项目位于 [`hsp/`](hsp/)，包含 BLE 扫描、直连、前台服务、手表/手机互找与协议说明。详细使用方式见 [hsp/README.md](hsp/README.md)。

## 后续方向

通知同步、天气时间同步、蓝牙音频、PAN 联网、音乐与更完整的设备状态同步仍处于接口预留或持续开发阶段，当前不应视为完整产品功能。

## 说明

- 芯片与开发板能力不等于全部功能已接入，请以本仓库实现为准。
- 项目当前未声明开源许可证。
