# 浮生音乐 · 鸿蒙版（Fu Sheng Music for HarmonyOS）

> 基于 Flutter 开发的鸿蒙（OpenHarmony / HarmonyOS）音乐播放器，从 [浮生音乐](https://github.com/bmbxwbh/luo_xue_next) 适配而来。

---

## 📢 项目说明

本仓库是浮生音乐的**鸿蒙专属适配版**，基于主仓库源码，替换平台相关依赖为鸿蒙兼容版本。

### 与主仓库的区别

| 项目 | 主仓库 (Android) | 鸿蒙版 (本仓库) |
|------|-----------------|----------------|
| JS 运行时 | `flutter_js` (QuickJS) | `flutter_js_ohos` (QuickJS) |
| 音频播放 | `just_audio` | `just_audio_harmonyos` |
| 音频会话 | `audio_session` | `audio_session_harmonyos` |
| 权限管理 | `permission_handler` | `permission_handler_ohos` |
| 文件选择 | `file_picker` | `file_picker_ohos` |
| 本地存储 | `shared_preferences` | `shared_preferences_harmonyos` |
| URL 启动 | `url_launcher` | `url_launcher_harmonyos` |
| 路径管理 | `path_provider` | `path_provider_harmonyos` |
| 动态取色 | `dynamic_color` | ❌ 移除（鸿蒙无 Material You） |

### 功能差异

- ✅ 多平台音源搜索与播放（网易云、QQ、酷狗、酷我、咪咕）
- ✅ MusicFree 插件系统
- ⚠️ 洛雪脚本模式（需实际测试兼容性）
- ✅ 歌词同步显示
- ✅ 在线歌单浏览
- ✅ 深色/浅色主题（固定配色，无系统取色）
- ⚠️ 本地音乐（暂不支持自动扫描，可通过文件选择器导入）

## 🏗️ 开发环境要求

- Flutter SDK 3.x+
- DevEco Studio（鸿蒙 IDE）
- HarmonyOS SDK API 12+
- Node.js（用于鸿蒙构建工具链）

## 🚀 构建步骤

```bash
# 1. 安装依赖
flutter pub get

# 2. 生成鸿蒙工程文件（首次）
flutter create . --platforms ohos

# 3. 构建 HAP
flutter build hap

# 4. 安装到设备
flutter run -d <ohos-device-id>
```

## 📦 鸿蒙依赖来源

所有鸿蒙适配包来自社区：

| 包名 | 来源 |
|------|------|
| `flutter_js_ohos` | [pub.dev](https://pub.dev/packages/flutter_js_ohos) |
| `just_audio_harmonyos` | [pub.dev](https://pub.dev/packages/just_audio_harmonyos) |
| `permission_handler_ohos` | [pub.dev](https://pub.dev/packages/permission_handler_ohos) |
| `file_picker_ohos` | [pub.dev](https://pub.dev/packages/file_picker_ohos) |
| `audio_session_harmonyos` | [pub.dev](https://pub.dev/packages/audio_session_harmonyos) |
| `shared_preferences_harmonyos` | [pub.dev](https://pub.dev/packages/shared_preferences_harmonyos) |
| `url_launcher_harmonyos` | [pub.dev](https://pub.dev/packages/url_launcher_harmonyos) |
| `path_provider_harmonyos` | [pub.dev](https://pub.dev/packages/path_provider_harmonyos) |

## ⚠️ 已知限制

1. 鸿蒙适配包多为 v0.0.1，处于早期阶段，可能存在不稳定因素
2. `flutter_js_ohos` 基于 flutter_js 0.6.x 分支，缺少 0.7.x+ 的内存泄漏修复
3. 不支持系统动态取色（Material You / Monet）
4. 本地音乐扫描暂不支持，需手动通过文件选择器导入

## 📄 许可证

MIT License

## 🔗 相关链接

- 主仓库：https://github.com/bmbxwbh/luo_xue_next
