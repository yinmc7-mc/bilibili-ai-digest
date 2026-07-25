#!/bin/bash

# GitHub推送助手脚本

echo "🚀 B站AI摘要系统 - GitHub推送助手"
echo "=================================="
echo ""

# 检查GitHub CLI是否可用
if command -v gh &> /dev/null; then
    echo "✅ 检测到GitHub CLI"

    # 尝试使用GitHub CLI
    echo "📝 正在使用GitHub CLI创建仓库..."
    if gh repo create bilibili-digest --public --description "Bilibili AI Digest System - Automated daily summaries from 17 AI/tech creators" --source=. --push 2>/dev/null; then
        echo "🎉 成功推送到GitHub！"
        echo ""
        echo "📍 仓库地址: https://github.com/$(gh auth status | grep 'Logged in as' | awk '{print $3}')/bilibili-digest"
        exit 0
    else
        echo "⚠️  GitHub CLI推送失败，尝试手动方法..."
    fi
else
    echo "ℹ️  未安装GitHub CLI，使用手动方法..."
fi

echo ""
echo "📋 手动推送步骤："
echo "1. 访问 https://github.com/new"
echo "2. 仓库名称: bilibili-digest"
echo "3. 描述: Bilibili AI Digest System - Automated daily summaries from 17 AI/tech creators"
echo "4. 选择 Public 或 Private"
echo "5. 不要初始化README"
echo "6. 点击 Create repository"
echo ""
echo "7. 创建后，复制下面的命令并执行："
echo ""
echo "   cd ~/bilibili-digest"
echo "   git remote add origin https://github.com/YOUR_USERNAME/bilibili-digest.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "   (将 YOUR_USERNAME 替换为你的GitHub用户名)"
echo ""

# 显示当前git状态
echo "📊 当前Git状态:"
git remote -v 2>/dev/null || echo "   尚未配置远程仓库"
git log --oneline -2

echo ""
echo "💡 详细指南请查看: cat ~/bilibili-digest/GITHUB_GUIDE.md"