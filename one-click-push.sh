#!/bin/bash

echo "🎯 一键完成GitHub推送流程"
echo "=================================="
echo ""

# 第1步：打开GitHub创建页面（预填信息）
echo "🌐 打开GitHub仓库创建页面..."
open "https://github.com/new?name=bilibili-ai-digest&description=Bilibili+AI+Digest+System&public=true"

echo "✅ 已在浏览器中打开GitHub创建页面"
echo ""
echo "📋 请确认以下信息："
echo "   仓库名：bilibili-ai-digest"
echo "   描述：Bilibili AI Digest System"
echo "   可见性：Public"
echo "   ⚠️ 不要勾选任何初始化选项"
echo ""

# 等待用户创建仓库
read -p "创建完成后按回车继续..."

echo ""
echo "🚀 正在推送代码到GitHub..."
echo ""

cd ~/bilibili-digest

# 显示当前状态
echo "📊 推送信息："
echo "   目标仓库: git@github.com:yninmc7-mc/bilibili-ai-digest.git"
echo "   分支: main"
echo "   Commits: 5个"
echo "   文件: 26个"
echo ""

# 执行推送
if git push -u origin main 2>&1; then
    echo ""
    echo "🎉 成功！代码已推送到GitHub！"
    echo ""
    echo "📍 仓库地址: https://github.com/yninmc7-mc/bilibili-ai-digest"
    echo ""
    echo "🌐 查看仓库: https://github.com/yninmc7-mc/bilibili-ai-digest"
    echo ""
    echo "✅ 推送完成的内容:"
    git log --oneline -5
    echo ""
    
    # 询问是否在浏览器中打开仓库
    read -p "是否在浏览器中查看仓库？(y/n): " open_choice
    if [ "$open_choice" = "y" ]; then
        open "https://github.com/yninmc7-mc/bilibili-ai-digest"
    fi
    
    echo ""
    echo "🎊 恭喜！你的B站AI摘要系统已在GitHub上线！"
    echo ""
    echo "📋 系统包含的功能："
    echo "   ✅ 17个AI/科技UP主监控"
    echo "   ✅ 每日自动扫描新视频"
    echo "   ✅ 双语摘要生成"
    echo "   ✅ 飞书自动推送"
    echo "   ✅ 定时任务调度（7:30AM）"
    
else
    echo ""
    echo "❌ 推送失败，故障排除："
    echo ""
    echo "1. 确认GitHub仓库已创建"
    echo "   访问: https://github.com/yninmc7-mc?tab=repositories"
    echo ""
    echo "2. 确认仓库名为: bilibili-ai-digest"
    echo ""
    echo "3. 检查SSH密钥配置"
    echo "   运行: ssh -T git@github.com"
    echo ""
    echo "🔄 重试命令: cd ~/bilibili-digest && git push -u origin main"
    exit 1
fi
