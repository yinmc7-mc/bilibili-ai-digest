#!/bin/bash

echo "🎯 GitHub推送 - 简单直接方案"
echo "=========================="
echo ""

cd ~/bilibili-digest

echo "📊 准备推送的内容："
echo "   ✅ 5个commits"
echo "   ✅ 27个文件"
echo "   ✅ 完整的B站AI摘要系统"
echo ""

echo "第1步：创建GitHub仓库"
echo "===================="
echo ""
echo "请手动创建仓库："
echo "1. 访问: https://github.com/new"
echo "2. 填写："
echo "   - 仓库名：bilibili-aidigest"
echo "   - 描述：Bilibili AI Digest System"
echo "   - 可见性：Public"
echo "   - ⚠️ 不要勾选任何初始化选项"
echo "3. 点击：Create repository"
echo ""

open "https://github.com/new"

echo "已在浏览器中打开GitHub创建页面"
echo ""

read -p "创建完成后按回车继续..."

echo ""
echo "第2步：推送代码"
echo "==============="
echo ""

# 更新远程仓库
git remote set-url origin git@github.com:yninmc7-mc/bilibili-aidigest.git

echo "🚀 推送代码到: https://github.com/yninmc7-mc/bilibili-aidigest"
echo ""

# 执行推送
if git push -u origin main 2>&1; then
    echo ""
    echo "🎉 成功！代码已推送到GitHub！"
    echo ""
    echo "📍 仓库地址: https://github.com/yninmc7-mc/bilibili-aidigest"
    echo ""
    echo "✅ 推送完成的内容:"
    git log --oneline -5
    echo ""
    echo "🌐 在浏览器中查看仓库..."
    open "https://github.com/yninmc7-mc/bilibili-aidigest"
    echo ""
    echo "🎊 恭喜！你的B站AI摘要系统已在GitHub上线！"
    echo ""
    echo "📋 系统功能："
    echo "   ✅ 17个AI/科技UP主监控"
    echo "   ✅ 每日自动扫描新视频（7:30AM）"
    echo "   ✅ 双语摘要生成（中英文）"
    echo "   ✅ 飞书自动推送"
    echo "   ✅ 完整的自动化脚本和配置"
    echo ""
    echo "🚀 GitHub推送完成！"
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "请确认："
    echo "1. 仓库名称: bilibili-aidigest"
    echo "2. 仓库已成功创建"
    echo "3. SSH密钥配置正确"
    echo ""
    echo "🔗 检查仓库: https://github.com/yninmc7-mc/bilibili-aidigest"
    echo ""
    echo "🔄 重试: cd ~/bilibili-digest && git push -u origin main"
    exit 1
fi
