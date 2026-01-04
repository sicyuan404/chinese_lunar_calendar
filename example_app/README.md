# 中国农历日历 Flutter 应用

这是一个使用 `chinese_lunar_calendar` 包构建的 Flutter 示例应用,展示了如何使用该包来显示中国农历信息。

## 功能特性

- 显示当前日期的农历信息
- 日历网格视图,支持月份切换
- 显示农历年、月、日
- 显示生肖、干支年、干支月、干支日
- 显示节气、月相、时辰等信息

## 运行应用

### 前置要求

- Flutter SDK 3.24.0 或更高版本
- Dart SDK 3.8.1 或更高版本

### 安装依赖

```bash
cd example_app
flutter pub get
```

### 运行应用

```bash
flutter run
```

## GitHub Actions 自动构建

项目配置了 GitHub Actions 工作流,可以自动构建各平台的安装包:

### 支持的平台

- **Android**: APK 和 App Bundle (AAB)
- **iOS**: iOS 应用(无签名)
- **Windows**: Windows 可执行文件
- **Linux**: Linux 可执行文件
- **macOS**: macOS 应用

### 触发构建

工作流会在以下情况下自动触发:

1. 推送到 `main` 分支
2. 创建 Pull Request 到 `main` 分支
3. 推送标签(格式为 `v*`,如 `v1.0.0`)
4. 手动触发(通过 GitHub Actions 界面)

### 获取构建产物

构建完成后,可以在 GitHub Actions 页面下载各平台的安装包:

1. 进入 GitHub 仓库的 "Actions" 标签
2. 选择对应的工作流运行
3. 在 "Artifacts" 部分下载所需平台的构建产物

### 发布版本

当推送标签(如 `v1.0.0`)时,工作流会自动创建 GitHub Release 并上传所有平台的构建产物。

## 本地构建

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release --no-codesign
```

### Windows

```bash
flutter build windows --release
```

### Linux

```bash
flutter build linux --release
```

### macOS

```bash
flutter build macos --release
```

## 项目结构

```
example_app/
├── lib/
│   └── main.dart          # 应用主入口
├── android/               # Android 平台配置
├── ios/                   # iOS 平台配置
├── windows/               # Windows 平台配置
├── linux/                 # Linux 平台配置
├── macos/                 # macOS 平台配置
└── pubspec.yaml           # 项目依赖配置
```

## 依赖

- `flutter`: Flutter SDK
- `chinese_lunar_calendar`: 中国农历日历计算包
- `cupertino_icons`: iOS 风格图标

## 许可证

MIT License