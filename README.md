# HarmonyOS 基础 Demo

一个可继续扩展的鸿蒙原生应用入门工程。采用 **ArkTS + ArkUI + Stage 模型**，基线为 **HarmonyOS 5.0.0 / API 12**。这是 HarmonyOS 原生源码，不是 Android APK 工程。

## 已实现

- 首页：介绍卡片、计数器、重置操作。
- 待办：新增、完成/取消完成、删除、空态、输入检查、数量统计。
- 导航：`Navigation + NavPathStack` 跳转开发指南，支持返回。
- 组件：`InfoCard` 可复用卡片，`TodoItem` 独立数据模型。
- 配置：应用入口、资源、图标、Hvigor 构建配置。

待办和计数器只在内存中保存。重启应用后恢复初始状态。无需服务器、账号或网络权限。

## 打开与运行

1. 安装华为官方 DevEco Studio，以及 HarmonyOS 5.0.0(API 12) SDK 和相应模拟器镜像。
2. 选择 **Open**，打开本仓库根目录（与 `build-profile.json5` 同级），完成工程同步。
3. 如果你的 IDE 仅安装了更新 SDK，在 **File > Project Structure > Project** 中选择已安装的 HarmonyOS SDK，使 compile SDK 不低于 compatible SDK；同时按 IDE 提示迁移 Hvigor `modelVersion`。本仓库的 API 12 基线并不代表当前最新 SDK。
4. Previewer 可用于查看 `Index.ets` 首页。完整待办和导航行为请在模拟器或真机验证。
5. 真机运行时，在 **Project Structure > Signing Configs** 中使用你自己的华为账号配置自动签名，按需填写应用包名，然后选择设备并运行 `entry`。

`signingConfigs` 默认留空。设备签名配置和本机 SDK 路径应仅保留本地。应用发布前应将 `com.example.harmonyosdemo` 改为自己的包名。

本工程使用 DevEco 内置 Hvigor；没有附带独立 `hvigorw` 启动器，也不需要手工安装 npm 包。需要命令行构建时，使用 DevEco 安装目录中的 Hvigor 启动器，或通过 IDE 生成与你本机匹配的启动脚本。

## 目录

```text
AppScope/                         应用级配置与共享资源
entry/src/main/
  ets/entryability/EntryAbility.ets  Stage 入口
  ets/pages/Index.ets               首页和待办页
  ets/pages/GuidePage.ets           导航子页
  ets/components/InfoCard.ets       复用组件
  ets/model/TodoItem.ets            待办模型
  resources/                       模块资源与页面注册
  module.json5                     模块与 Ability 配置
hvigor/                            构建模型配置
scripts/validate_project.py        无 SDK 的配置与资源检查
docs/ACCEPTANCE.md                 手工验收步骤与验证边界
```

## 验证

```bash
python3 scripts/validate_project.py
```

该命令检查配置、入口、页面和资源引用；**不等价于 ArkTS 编译或设备测试**。交付环境没有 DevEco Studio / HarmonyOS SDK，因此尚未生成 HAP，也未执行模拟器或真机验收。设备验收步骤见 [ACCEPTANCE.md](docs/ACCEPTANCE.md)。

## 获取源码

仓库：[JunoBarnswell/harmonyos-demo](https://github.com/JunoBarnswell/harmonyos-demo)。

```bash
git clone https://github.com/JunoBarnswell/harmonyos-demo.git
cd harmonyos-demo
```

随后在 DevEco Studio 中打开该目录，按上方步骤同步和运行。

## 扩展方向

1. 引入 Preferences 或关系型数据库，持久化待办。
2. 添加 service / repository 层，对接 ASP.NET Core Web API。
3. 加入登录、错误处理和按业务模块划分的页面。

## 官方参考

- [ArkTS](https://developer.huawei.com/consumer/cn/arkts/)
- [Navigation 组件导航（API 12）](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-navigation-navigation-V5)
- [工程级 build-profile 配置](https://developer.huawei.com/consumer/cn/doc/HarmonyOS-Guides/ide-hmos-hvigor-build-profile-app)

本工程业务代码为本次新建，未复制第三方示例源码。
