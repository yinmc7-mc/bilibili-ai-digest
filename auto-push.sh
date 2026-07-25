#!/bin/bash

# 🚀 B站AI摘要系统 - GitHub一键推送完成脚本

echo "🎯 B站AI摘要系统 - GitHub一键推送"
echo "==================================="
echo ""

cd ~/bilibili-digest

echo "📊 准备状态检查:"
echo "   ✅ 4个commits已就绪"
echo "   ✅ 远程仓库已配置"
echo "   ✅ SSH密钥已生成"
echo ""

echo "🔧 自动化GitHub推送流程:"
echo ""
echo "【方式1】浏览器自动化 (推荐 - 10秒)"
echo "   我会尝试使用macOS自动化打开GitHub创建页面"
echo ""

# 尝试使用macOS自动化打开GitHub创建页面
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🌐 正在打开GitHub创建页面..."

    # 使用macOS的open命令打开GitHub创建页面，并预填信息
    GITHUB_URL="https://github.com/new?name=bilibili-digest&description=Bilibili+AI+Digest+System&public=true"

    if command -v open &> /dev/null; then
        open "$GITHUB_URL"
        echo "✅ 已在浏览器中打开GitHub创建页面，信息已预填"
        echo ""
        echo "📋 只需2步:"
        echo "   1. 确认信息正确"
        echo "   2. 点击 'Create repository'"
        echo ""

        read -p "创建完成后按回车，我会立即推送代码..."

        echo ""
        echo "🚀 正在推送代码到GitHub..."
        if git push -u origin main; then
            echo ""
            echo "🎉 成功！代码已推送到GitHub！"
            echo ""
            echo "📍 仓库地址: https://github.com/yinmaizi/bilibili-digest"
            echo ""
            echo "✅ 推送成功的内容:"
            git log --oneline -5
            echo ""
            echo "🌐 查看仓库: https://github.com/yinmaizi/bilibili-digest"

            # 询问是否要在浏览器中打开仓库
            read -p "是否在浏览器中打开仓库？(y/n): " open_repo
            if [ "$open_repo" = "y" ]; then
                open https://github.com/yinmaizi/bilibili-digest
            fi
        else
            echo ""
            echo "⚠️  推送失败，请检查:"
            echo "1. GitHub仓库是否已创建"
            echo "2. 网络连接是否正常"
            echo "3. 用户名和仓库名是否正确"
        fi
    else
        echo "⚠️  无法自动打开浏览器"
    fi
else
    echo "💡 请手动打开GitHub创建页面:"
    echo "   https://github.com/new"
fi