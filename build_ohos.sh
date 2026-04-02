#!/bin/bash
# 浮生音乐·鸿蒙版 构建脚本
set -e

echo "🌟 浮生音乐 · 鸿蒙版构建"
echo "========================"

# 检查 hvigor
if ! command -v hvigor &> /dev/null; then
    echo "📦 安装 hvigor-cli..."
    npm install -g @ohos/hvigor-cli
fi

# 检查 ohpm
if ! command -v ohpm &> /dev/null; then
    echo "📦 安装 ohpm-cli..."
    npm install -g @ohos/ohpm-cli
fi

# 安装依赖
echo "📦 安装依赖..."
ohpm install

# 构建未签名包
echo "🏗️  构建未签名 HAP..."
hvigor clean
hvigor assembleRelease -Psigned=false

UNSIGNED_HAP="entry/build/default/outputs/default/entry-default-unsigned.hap"
echo "✅ 未签名包: $UNSIGNED_HAP"

# 签名（需要证书文件）
if [ -f "signing/release.p12" ] && [ -f "signing/release.cer" ] && [ -f "signing/release.p7b" ]; then
    echo "🔐 签名中..."
    java -jar hapsigntoolv2.jar sign \
        -mode localjks \
        -privatekey "${KEY_ALIAS:-debug}" \
        -inputFile "$UNSIGNED_HAP" \
        -outputFile "entry/build/default/outputs/default/entry-signed.hap" \
        -signAlg SHA256withECDSA \
        -keystore signing/release.p12 \
        -keystorepasswd "${STORE_PWD:-123456}" \
        -keyaliaspasswd "${KEY_PWD:-123456}" \
        -profile signing/release.p7b \
        -certpath signing/release.cer \
        -profileSigned 1
    echo "✅ 签名包: entry/build/default/outputs/default/entry-signed.hap"
else
    echo "⚠️  签名证书不存在 (signing/目录)，跳过签名"
    echo "   未签名包: $UNSIGNED_HAP"
fi

echo ""
echo "🎉 构建完成！"
