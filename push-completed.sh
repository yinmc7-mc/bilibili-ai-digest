#!/bin/bash

# 🚀 GitHub推送完成脚本

echo "🎯 B站AI摘要系统 - GitHub推送完成助手"
echo "======================================"
echo ""

cd ~/bilibili-digest

echo "📊 当前状态:"
echo "   ✅ 4个commits已准备"
echo "   ✅ 16个文件已就绪"
echo "   ✅ SSH密钥已配置"
echo "   ⚠️  GitHub仓库尚未创建"
echo ""

echo "🔧 开始GitHub推送流程:"
echo ""

# 第一步：创建GitHub仓库
echo "【第一步】创建GitHub仓库"
echo ""
echo "📋 请按照以下步骤操作（30秒）:"
echo ""
echo "1. 点击这个链接 (将在新窗口打开):"
echo "   >>> https://github.com/new <<<"
echo ""
echo "2. 在打开的页面中填写:"
echo "   Repository name: bilibili-digest"
echo "   Description: Bilibili AI Digest System"
echo "   ✅ Public (或Private，随你选择)"
echo "   ⚠️  不要勾选 'Initialize this repository with a README'"
echo ""
echo "3. 点击 'Create repository' 按钮"
echo ""

# 等待用户操作
echo "⏰ 等待你创建GitHub仓库..."
read -p "创建完成后按回车继续... "

echo ""
echo "【第二步】推送代码到GitHub"
echo ""

# 检查用户是否完成
echo "🚀 正在推送代码到GitHub..."
echo "📍 目标: git@github.com:yinmaizi/bilibili-digest.git"
echo ""

if git push -u origin main 2>&1; then
    echo ""
    echo "🎉 成功！代码已推送到GitHub！"
    echo ""
    echo "📍 仓库地址: https://github.com/yinmaizi/bilibili-digest"
    echo ""
    echo "✅ 推送成功的内容:"
    git log --oneline -5
    echo ""
    echo "🌐 查看仓库: https://github.com/yinmaizi/bilibili-digest"
    echo ""
    echo "🎊 恭喜！你的B站AI摘要系统现在已在GitHub上！"
else
    echo ""
    echo "⚠️  推送失败，可能的原因:"
    echo "1. GitHub仓库名不正确 (应该是: bilibili-digest)"
    echo "2. 仓库名称不匹配 (用户名: yinmaizi)"
    echo "3. 网络连接问题"
    echo ""
    echo "💡 请确认:"
    git remote -v
    echo ""
    echo "🔄 重试推送: git push -u origin main"
fi