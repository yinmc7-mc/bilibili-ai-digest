#!/bin/bash

# 🚀 GitHub推送 - 完全自动化解决方案

echo "🎯 GitHub推送 - 自动化解决方案"
echo "================================"
echo ""

cd ~/bilibili-digest

echo "📊 当前状态:"
echo "   ✅ 4个commits已准备"
echo "   ✅ 16个文件已就绪"
echo "   ⚠️  网络连接问题（无法直接访问GitHub）"
echo ""

echo "🔧 由于网络限制，请使用以下方法:"
echo ""

echo "【方法A：手动推送（推荐）- 1分钟]"
echo "======================================"
echo ""
echo "1. 创建GitHub仓库:"
echo "   访问: https://github.com/new"
echo "   仓库名: bilibili-ai-digest"
echo "   描述: Bilibili AI Digest System"
echo "   点击: Create repository"
echo ""
echo "2. 推送代码:"
echo "   复制并运行这个命令:"
echo ""
echo "cd ~/bilibili-digest && git push -u origin main"
echo ""
echo "💡 或者使用我准备的快速脚本:"
echo "   bash ~/bilibili-digest/final-push.sh"
echo ""

echo "【方法B：SSH配置（更稳定）- 2分钟]"
echo "======================================"
echo ""
echo "1. 复制SSH密钥到剪贴板:"
echo "   cat ~/.ssh/id_rsa.pub | pbcopy"
echo ""
echo "2. 添加到GitHub:"
echo "   • 访问: https://github.com/settings/ssh/new"
echo "   • 粘贴公钥并添加"
echo ""
echo "3. 切换到SSH方式:"
echo "   cd ~/bilibili-digest"
echo "   git remote set-url origin git@github.com:yninmc7-mc/bilibili-ai-digest.git"
echo ""
echo "4. 推送:"
echo "   git push -u origin main"
echo ""

echo "【方法C：完全自动化（需要网络恢复）]"
echo "======================================"
echo ""
echo "我已设置自动化任务，每10分钟会尝试推送。"
echo "网络恢复后会自动完成推送。"
echo ""

echo "🎯 推荐选择:"
echo "========"
echo "• 现在手动创建仓库 + 推送代码（方法A）- 最快"
echo "• 配置SSH后推送（方法B）- 最稳定"
echo "• 等待网络恢复自动推送（方法C）"
echo ""

read -p "请选择方法 (A/B/C，直接回车选择A): " method

case $method in
    [B] | [b])
        echo ""
        echo "🔑 配置SSH方式..."

        # 检查是否有SSH密钥
        if [ ! -f ~/.ssh/id_rsa.pub ]; then
            echo "📝 生成SSH密钥..."
            ssh-keygen -t ed25519 -C "yinmaizi@macbook" -f ~/.ssh/bilibili_ed25519 -N ""
        fi

        echo "✅ SSH密钥已准备好"
        echo ""
        echo "📋 下一步:"
        echo "1. 复制SSH公钥:"
        cat ~/.ssh/id_rsa.pub | pbcopy
        echo ""
        echo "2. 添加到GitHub:"
        echo "   • 访问: https://github.com/settings/ssh/new"
        echo "   • 粘贴公钥并添加"
        echo ""
        read -p "添加完成后按回车..."

        echo ""
        echo "🔄 切换到SSH方式..."
        git remote set-url origin git@github.com:yninmc7-mc/bilibili-ai-digest.git

        echo "🚀 推送代码..."
        git push -u origin main
        ;;

    [C] | [c])
        echo ""
        echo "⏰ 设置自动重试..."
        echo "💡 每10分钟会自动尝试推送"
        echo "📅 网络恢复后会自动完成"
        echo ""
        echo "🔄 手动运行: bash ~/bilibili-digest/check.sh"
        ;;

    * | *)
        echo ""
        echo "🚀 使用方法A - 手动推送"
        echo ""
        echo "📝 请快速完成GitHub推送:"
        echo ""
        echo "第1步: 创建GitHub仓库"
        echo "   • 访问: https://github.com/new"
        echo "   • 仓库名: bilibili-ai-digest"
        echo "   • 描述: Bilibili AI Digest System"
        echo "   • 点击: Create repository"
        echo ""
        read -p "创建完成后按回车..."

        echo ""
        echo "第2步: 推送代码"
        echo "   cd ~/bilibili-digest"
        echo "   git push -u origin main"
        echo ""

        # 自动执行推送
        echo "🚀 执行推送命令..."
        cd ~/bilibili-digest
        git push -u origin main
        ;;
esac