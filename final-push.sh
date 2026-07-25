#!/bin/bash

# 🚀 一键GitHub推送完成脚本

echo "🎯 B站AI摘要系统 - GitHub推送助手"
echo "=================================="
echo ""

cd ~/bilibili-digest

echo "📊 当前准备状态:"
echo "   ✅ 4个commits已打包"
echo "   ✅ 远程仓库已配置: https://github.com/yinmaizi/bilibili-digest.git"
echo "   ✅ 所有文件已准备就绪"
echo ""

echo "🔧 请选择你的情况:"
echo ""
echo "【情况1】我还没有在GitHub创建bilibili-digest仓库"
echo "   → 我会提供创建链接和推送命令"
echo ""
echo "【情况2】我已经在GitHub创建了bilibili-digest仓库"
echo "   → 我会直接执行推送命令"
echo ""

read -p "请输入你的情况 (1或2): " situation

case $situation in
    1)
        echo ""
        echo "📝 请按照以下步骤创建GitHub仓库:"
        echo ""
        echo "1. 点击这个链接打开GitHub创建页面:"
        echo "   https://github.com/new"
        echo ""
        echo "2. 填写以下信息:"
        echo "   Repository name: bilibili-digest"
        echo "   Description: Bilibili AI Digest System"
        echo "   Public: ✅ (或Private，随你选择)"
        echo ""
        echo "3. ⚠️  重要: 不要勾选 'Initialize with README'"
        echo ""
        echo "4. 点击 'Create repository'"
        echo ""
        echo "5. 创建完成后，按回车，我会立即推送代码！"
        echo ""
        read -p "按回车继续..."

        echo ""
        echo "🚀 正在推送代码到 GitHub..."
        echo "📍 目标: https://github.com/yinmaizi/bilibili-digest.git"
        echo ""

        if git push -u origin main; then
            echo ""
            echo "🎉 成功！代码已推送到GitHub！"
            echo "📍 仓库地址: https://github.com/yinmaizi/bilibili-digest"
            echo ""
            echo "✅ 完成推送的内容:"
            git log --oneline -4
        else
            echo ""
            echo "⚠️  推送遇到问题，请检查:"
            echo "1. GitHub仓库是否已创建"
            echo "2. 网络连接是否正常"
            echo "3. GitHub凭据是否正确"
        fi
        ;;

    2)
        echo ""
        echo "🚀 正在推送代码到 GitHub..."
        echo "📍 目标: https://github.com/yinmaizi/bilibili-digest.git"
        echo ""

        if git push -u origin main; then
            echo ""
            echo "🎉 成功！代码已推送到GitHub！"
            echo "📍 仓库地址: https://github.com/yinmaizi/bilibili-digest"
            echo ""
            echo "✅ 推送的内容:"
            git log --oneline -4
            echo ""
            echo "🌐 查看仓库: https://github.com/yinmaizi/bilibili-digest"
        else
            echo ""
            echo "⚠️  推送失败，可能的原因:"
            echo "1. 仓库名称或用户名不匹配"
            echo "2. 网络连接问题"
            echo "3. GitHub权限问题"
            echo ""
            echo "💡 请确认: git remote -v"
            git remote -v
        fi
        ;;

    *)
        echo "❌ 无效选择，请重新运行脚本"
        exit 1
        ;;
esac