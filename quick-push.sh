#!/bin/bash

# GitHub快速推送脚本

echo "🚀 B站AI摘要系统 - GitHub推送"
echo "=============================="
echo ""

# 方法1：使用GitHub CLI（如果网络正常）
if command -v gh &> /dev/null; then
    echo "🔧 尝试使用GitHub CLI..."
    if gh repo create bilibili-digest --public --description "Bilibili AI Digest System - Automated daily summaries from 17 AI/tech creators" --source=. --push 2>/dev/null; then
        echo "🎉 成功推送到GitHub！"
        gh repo view --web yinmaizi/bilibili-digest
        exit 0
    else
        echo "⚠️  GitHub CLI暂时不可用"
    fi
fi

# 方法2：手动推送（需要用户名）
echo ""
echo "📝 请提供你的GitHub用户名:"
read -p "GitHub用户名: " github_username

if [ -n "$github_username" ]; then
    echo ""
    echo "✅ 用户名: $github_username"
    echo ""
    echo "📋 推送步骤："
    echo "1. 访问: https://github.com/new"
    echo "2. 仓库名: bilibili-digest"
    echo "3. 描述: Bilibili AI Digest System"
    echo "4. 点击: Create repository"
    echo ""
    echo "5. 创建后执行:"
    echo ""
    echo "   cd ~/bilibili-digest"
    echo "   git remote add origin https://github.com/$github_username/bilibili-digest.git"
    echo "   git push -u origin main"
    echo ""

    # 自动设置远程仓库
    cd ~/bilibili-digest
    git remote add origin https://github.com/$github_username/bilibili-digest.git 2>/dev/null
    echo "✅ Git远程仓库已配置为: https://github.com/$github_username/bilibili-digest.git"
    echo ""
    echo "💡 现在只需在GitHub创建仓库，然后运行: git push -u origin main"
else
    echo "❌ 用户名不能为空"
fi