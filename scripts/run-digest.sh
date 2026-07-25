#!/bin/bash

# B站AI摘要系统 - 多模式运行脚本

echo "🎯 B站AI摘要系统 - 选择运行模式"
echo "================================="
echo ""

echo "请选择运行模式:"
echo "1. 极低频率模式（推荐）"
echo "   - 4个重要UP主"
echo "   - 30-60秒延迟"
echo "   - 适合每3天运行"
echo ""
echo "2. 安全模式"
echo "   - 16个UP主"
echo "   - 3-7秒延迟"
echo "   - 适合每天运行（可能被限流）"
echo ""
echo "3. 原始模式"
echo "   - 16个UP主"
echo "   - 无延迟"
echo "   - 高风险，不推荐"
echo ""

read -p "请输入模式选择 (1/2/3，直接回车选择模式1): " mode

case $mode in
    2|"2")
        echo ""
        echo "🛡️ 使用安全模式..."
        cd ~/bilibili-digest
        node scripts/generate-bilibili-feed-safe.js
        ;;
    3|"3")
        echo ""
        echo "⚠️ 使用原始模式（高风险）..."
        cd ~/bilibili-digest
        node scripts/generate-bilibili-feed.js
        ;;
    *|"1"|"")
        echo ""
        echo "🛡️ 使用极低频率模式（推荐）..."
        cd ~/bilibili-digest
        node scripts/generate-bilibili-feed-minimal.js
        ;;
esac

echo ""
echo "📝 继续生成摘要..."
cd ~/bilibili-digest

if node scripts/prepare-digest.js && node scripts/remix-digest.js && node scripts/deliver-digest.js; then
    echo ""
    echo "🎊 摘要生成完成！"
else
    echo ""
    echo "⚠️ 部分步骤失败，请检查日志"
fi
