#!/bin/bash
# 浮生音乐·鸿蒙版 构建脚本
set -e

echo "🌟 浮生音乐 · 鸿蒙版构建"
echo "========================"

# 检查 Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter 未安装"
    echo "   请使用华为 Flutter ohos 分支："
    echo "   git clone -b stable https://gitee.com/openharmony-sig/flutter.git"
    exit 1
fi

# 检查是否启用 ohos
if ! flutter config | grep -q "enable-ohos: true"; then
    echo "⚙️  正在启用 ohos 支持..."
    flutter config --enable-ohos
fi

# 清理
echo "🧹 清理..."
flutter clean

# 安装依赖
echo "📦 安装依赖..."
flutter pub get

# 分析代码
echo "🔍 代码分析..."
flutter analyze --no-fatal-infos || true

# 构建
BUILD_MODE="${1:-debug}"
echo "🏗️  构建 HAP ($BUILD_MODE)..."

case "$BUILD_MODE" in
    release)
        flutter build hap --release
        ;;
    profile)
        flutter build hap --profile
        ;;
    *)
        flutter build hap --debug
        ;;
esac

echo ""
echo "✅ 构建完成！"
echo "📂 输出目录: build/outputs/"
find build/ -name "*.hap" -o -name "*.app" 2>/dev/null
