#!/bin/bash

# 🚀 GitHub一键创建和推送脚本

echo "🎯 GitHub一键创建和推送"
echo "===================="
echo ""

# 自动打开GitHub创建页面（预填信息）
echo "🌐 正在打开GitHub创建页面..."

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: 使用open命令
    open "https://github.com/new?name=bilibili-digest&description=Bilibili+AI+Digest+System&public=true"
elif [[ "$OSTYPE" == "linux"* ]]; then
    # Linux: 尝试使用xdg-open
    if command -v xdg-open &> /dev/null; then
        xdg-open "https://github.com/new?name=bilibili-digest&description=Bilibili+AI+Digest+System&public=true"
    else
        echo "📋 请手动打开: https://github.com/new?name=bilibili-digest&description=Bilibili+AI+Digest+System&public=true"
    fi
else
    echo "📋 请手动打开: https://github.com/new?name=bilibili-digest&description=Bilibili+AI+Digest+System&public=true"
fi

echo ""
echo "✅ 已在浏览器中打开GitHub创建页面"
echo ""
echo "📋 请确认信息后点击 'Create repository'"
echo ""

# 等待用户创建仓库
read -p "创建完成后按回车继续..."

echo ""
echo "🚀 推送代码到GitHub..."
echo ""

cd ~/bilibili-digest

# 显示推送进度
echo "📍 推送到: git@github.com:yinmaizi/bilibili-digest.git"
echo "📊 推送内容: 4个commits, 16个文件"
echo ""

# 执行推送
if git push -u origin main 2>&1; then
    echo ""
    echo "🎉 成功！代码已推送到GitHub！"
    echo ""
    echo "📍 仓库地址: https://github.com/yinmaizi/bilibili-digest"
    echo ""
    echo "🌐 查看仓库: https://github.com/yinmaizi/bilibili-digest"
    echo ""
    echo "✅ 完成的内容:"
    git log --oneline -5
    echo ""

    # 询问是否在浏览器中打开仓库
    read -p "是否在浏览器中查看仓库？(y/n): " open_choice
    if [ "$open_choice" = "y" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            open "https://github.com/yinmaizi/bilibili-digest"
        elif [[ "$OSTYPE" == "linux"* ]]; then
            xdg-open "https://github.com/yinmaizi/bilibili-digest" 2>/dev/null || echo "📋 请手动打开: https://github.com/yinmaizi/bilibili-digest"
        fi
    fi

    echo ""
    echo "🎊 恭喜！你的B站AI摘要系统已在GitHub上！"
else
    echo ""
    echo "⚠️  推送失败，故障排除:"
    echo ""
    echo "1. 检查GitHub仓库是否已创建"
    echo "   访问: https://github.com/yinmaizi"
    echo ""
    echo "2. 确认仓库名: bilibili-digest"
    echo ""
    echo "3. 检查网络连接"
    echo ""
    echo "🔄 重试命令: cd ~/bilibili-digest && git push -u origin main"
fi