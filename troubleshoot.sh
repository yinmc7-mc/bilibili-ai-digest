#!/bin/bash

# 🎯 GitHub推送故障排除和解决脚本

echo "🎯 GitHub推送助手 - 故障排除"
echo "================================="
echo ""

cd ~/bilibili-digest

echo "📊 当前配置状态:"
echo "   目标用户名: yinmaizi (最初配置)"
echo "   你提供的: yninmc7-mc"
echo "   仓库名: bilibili-digest vs bilibili-ai-digest"
echo ""

echo "🔍 让我们找到正确的仓库信息..."
echo ""

echo "【方法1】检查你实际创建的仓库"
echo "==================================="
echo ""
echo "1. 访问你的GitHub个人页面:"
echo "   https://github.com/yninmc7-mc?tab=repositories"
echo ""
echo "2. 查看你创建的仓库名称"
echo "   应该是类似: bilibili-ai-digest 或 bilibili-digest"
echo ""
echo "3. 点击仓库名称，查看仓库页面"
echo "   复制正确的URL（绿色按钮旁边的克隆URL）"
echo ""

read -p "请粘贴完整的GitHub仓库URL (如 https://github.com/yninmc7-mc/XXXXX): " actual_url

if [ -n "$actual_url" ]; then
    echo ""
    echo "🔧 更新配置..."

    # 从URL中提取用户名和仓库名
    if [[ $actual_url =~ github\.com/([^/]+)/([^/]+)/? ]]; then
        REAL_USER="${BASH_REMATCH[1]}"
        REAL_REPO="${BASH_REMATCH[2]}"

        echo "✅ 解析成功:"
        echo "   用户名: $REAL_USER"
        echo "   仓库名: $REAL_REPO"

        # 更新远程配置
        git remote set-url origin https://github.com/$REAL_USER/$REAL_REPO.git

        echo ""
        echo "🚀 尝试推送..."
        if git push -u origin main 2>&1; then
            echo "🎉 成功！"
            echo "📍 https://github.com/$REAL_USER/$REAL_REPO"
        else
            echo "⚠️  URL格式不正确"
        fi
    else
        echo "❌ 无法解析URL，请确保是完整格式"
    fi
else
    echo "⏭️  跳过手动配置"
fi

echo ""
echo "【方法2】提供仓库信息"
echo "==================="
echo ""
echo "请手动告诉我:"
echo "1. 你的GitHub用户名（不是yinmaizi）"
echo "2. 你创建的仓库名称（不是bilibili-digest）"
echo "3. 或者直接提供完整的克隆URL"
echo ""

echo "💡 常见问题:"
echo "• 你可能使用了不同的GitHub账号"
echo "• 仓库名称可能包含不同的后缀"
echo "• 仓库名称可能是 bilibili-ai-digest 而非 bilibili-digest"
echo ""

# 等待用户输入
read -p "请提供GitHub用户名: " github_user
read -p "请提供仓库名称: " repo_name

if [ -n "$github_user" ] && [ -n "$repo_name" ]; then
    echo ""
    echo "🔧 配置仓库为: github.com/$github_user/$repo_name"

    git remote set-url origin https://github.com/$github_user/$repo_name.git

    echo "✅ 配置完成，尝试推送..."
    if git push -u origin main 2>&1; then
        echo "🎉 成功！"
        echo "📍 https://github.com/$github_user/$repo_name"
    else
        echo "⚠️  需要GitHub认证"
    fi
fi