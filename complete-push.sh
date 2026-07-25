#!/bin/bash

# 🚀 B站AI摘要系统 - GitHub推送完成脚本

echo "🎯 B站AI摘要系统 - GitHub推送解决方案"
echo "======================================"
echo ""

cd ~/bilibili-digest

echo "✅ 准备工作已完成:"
echo "   • 3个commits已打包"
echo "   • 16个文件已就绪"
echo "   • 远程仓库已配置"
echo "   • 目标: https://github.com/yinmaizi/bilibili-digest.git"
echo ""

echo "🔧 请选择推送方法:"
echo ""
echo "【方法1】HTTPS推送 (推荐 - 30秒)"
echo "   1. 确保在 https://github.com/new 创建了 bilibili-digest 仓库"
echo "   2. 执行: git push -u origin main"
echo ""
echo "【方法2】SSH推送 (最稳定 - 2分钟设置)"
echo "   1. 生成SSH密钥: ssh-keygen -t ed25519 -C \"your_email@example.com\""
echo "   2. 添加到GitHub: https://github.com/settings/ssh/new"
echo "   3. 切换到SSH: git remote set-url origin git@github.com:yinmaizi/bilibili-digest.git"
echo "   4. 推送: git push -u origin main"
echo ""
echo "【方法3】等网络恢复后重试"
echo "   稍后运行: bash ~/bilibili-digest/quick-push.sh"
echo ""

# 提供一键执行选项
read -p "🎯 选择方法 (1/2/3，直接回车使用方法1): " method

case $method in
    2)
        echo ""
        echo "🔑 生成SSH密钥..."
        ssh-keygen -t ed25519 -C "yinmaizi@macbook" -f ~/.ssh/bilibili_ed25519 -N ""

        echo ""
        echo "📋 复制以下公钥到GitHub:"
        cat ~/.ssh/bilibili_ed25519.pub
        echo ""
        echo "💡 添加后访问: https://github.com/settings/ssh/new"
        read -p "按回车继续..."

        echo "🔄 切换到SSH方式..."
        git remote set-url origin git@github.com:yinmaizi/bilibili-digest.git

        echo "🚀 尝试SSH推送..."
        git push -u origin main
        ;;
    3)
        echo "⏰ 设置稍后重试..."
        echo "💡 使用: bash ~/bilibili-digest/quick-push.sh"
        ;;
    *)
        echo "🚀 使用HTTPS方式推送..."
        echo "💡 如遇认证问题，GitHub会提示输入用户名和密码"
        git push -u origin main
        ;;
esac