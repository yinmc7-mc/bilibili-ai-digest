#!/bash

echo "🔍 GitHub仓库查找助手"
echo "====================="
echo ""
echo "请按以下步骤操作："
echo ""
echo "第1步：访问你的GitHub账户"
echo "  在浏览器中打开: https://github.com/yninmc7-mc?tab=repositories"
echo ""
open "https://github.com/yninmc7-mc?tab=repositories"

echo ""
echo "第2步：查看你的所有仓库"
echo "  寻找包含 'bilibili' 或 'ai-digest' 的仓库名称"
echo ""
echo "第3步：找到正确的仓库后："
echo "  • 点击仓库名称进入仓库页面"
echo "  • 复制完整的URL（格式：https://github.com/yninmc7-mc/仓库名称）"
echo ""
echo "第4步：在这里粘贴仓库URL"
echo ""
echo "💡 提示：如果你看到仓库列表为空，说明需要先创建仓库"
echo "   访问: https://github.com/new"
echo "   仓库名: bilibili-ai-digest"
echo "   描述: Bilibili AI Digest System"
echo "   可见性: Public"
echo "   点击: Create repository"
echo ""

read -p "请粘贴完整的GitHub仓库URL (或按回车跳过): " repo_url

if [ -n "$repo_url" ]; then
    # 从URL中提取仓库名称
    if [[ $repo_url =~ github\.com/yninmc7-mc/([^/]+)/? ]]; then
        REPO_NAME="${BASH_REMATCH[1]}"
        
        echo ""
        echo "🔧 更新仓库配置..."
        cd ~/bilibili-digest
        git remote set-url origin git@github.com:yninmc7-mc/$REPO_NAME.git
        
        echo "✅ 仓库名称: $REPO_NAME"
        echo ""
        echo "🚀 推送代码..."
        
        if git push -u origin main 2>&1; then
            echo ""
            echo "🎉 成功！代码已推送到GitHub！"
            echo "📍 仓库地址: https://github.com/yninmc7-mc/$REPO_NAME"
            open "https://github.com/yninmc7-mc/$REPO_NAME"
        else
            echo "❌ 推送失败，请检查网络连接和权限"
        fi
    else
        echo "❌ 无法解析URL，请确保格式正确"
    fi
else
    echo ""
    echo "⏭️ 跳过手动配置"
    echo ""
    echo "💡 下一步："
    echo "1. 在GitHub上创建仓库"
    echo "2. 运行: cd ~/bilibili-digest && git push -u origin main"
fi
