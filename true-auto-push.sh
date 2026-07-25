#!/bin/bash

echo "🤖 GitHub智能自动推送系统"
echo "========================="
echo ""

cd ~/bilibili-digest

echo "📊 准备推送的内容："
echo "   ✅ 5个commits"
echo "   ✅ 27个文件"
echo "   ✅ 完整的B站AI摘要系统"
echo ""

echo "第1步：打开GitHub创建页面"
echo "========================"
echo ""
echo "正在打开GitHub创建页面..."
open "https://github.com/new"

echo "✅ 已在浏览器中打开创建页面"
echo ""
echo "📋 请在浏览器中创建仓库："
echo "   仓库名：bilibili-aidigest"
echo "   描述：Bilibili AI Digest System"
echo "   可见性：Public"
echo "   ⚠️ 不要勾选任何初始化选项"
echo ""

echo "第2步：智能监控并自动推送"
echo "========================"
echo ""
echo "🤖 系统将自动监控仓库创建状态..."
echo "⏳ 每30秒检查一次，最多10分钟"
echo "🚀 创建成功后立即推送代码"
echo ""

# 配置正确的远程仓库
git remote set-url origin git@github.com:yninmc7-mc/bilibili-aidigest.git

# 智能监控循环
MAX_ATTEMPTS=20  # 20次 × 30秒 = 10分钟
ATTEMPT=0
SUCCESS=false

while [ $ATTEMPT -lt $MAX_ATTEMPTS ] && [ "$SUCCESS" = false ]; do
    ATTEMPT=$((ATTEMPT + 1))
    
    echo "🔍 [$ATTEMPT/$MAX_ATTEMPTS] 检查仓库状态..."
    
    # 测试推送（静默执行）
    if git push -u origin main &>/dev/null; then
        SUCCESS=true
        echo "   ✅ 检测到仓库已创建！"
        echo ""
        break
    else
        if [ $ATTEMPT -lt $MAX_ATTEMPTS ]; then
            echo "   ⏳ 等待仓库创建... (30秒后重试)"
            sleep 30
        fi
    fi
done

if [ "$SUCCESS" = true ]; then
    # 推送已经在上面的测试中成功执行，这里只需要确认
    echo "🎉 推送成功！代码已上传到GitHub！"
    echo ""
    echo "📍 仓库地址: https://github.com/yninmc7-mc/bilibili-aidigest"
    echo ""
    echo "✅ 推送完成的内容:"
    git log --oneline -5
    echo ""
    echo "📊 文件统计:"
    echo "   总文件数: $(git ls-files | wc -l | tr -d ' ')"
    echo ""
    echo "🌐 在浏览器中查看仓库..."
    open "https://github.com/yninmc7-mc/bilibili-aidigest"
    echo ""
    echo "🎊 恭喜！你的B站AI摘要系统已在GitHub上线！"
    echo ""
    echo "📋 系统功能："
    echo "   ✅ 17个AI/科技UP主监控"
    echo "   ✅ 每日自动扫描新视频（7:30AM）"
    echo "   ✅ 双语摘要生成（中英文）"
    echo "   ✅ 飞书自动推送"
    echo "   ✅ 完整的自动化脚本和配置"
    echo ""
    echo "🚀 GitHub推送完成！"
    echo ""
    echo "📝 下一步："
    echo "1. 在GitHub上查看你的代码"
    echo "2. 测试系统功能：bash ~/bilibili-digest/scripts/scheduled-digest.sh"
    echo "3. 确认定时任务：crontab -l"
    exit 0
else
    echo ""
    echo "⏰ 监控超时（10分钟）"
    echo ""
    echo "💡 请确认："
    echo "1. 仓库名称是否为: bilibili-aidigest"
    echo "2. 仓库是否已成功创建"
    echo "   检查: https://github.com/yninmc7-mc/bilibili-aidigest"
    echo ""
    echo "🔄 手动推送命令:"
    echo "   cd ~/bilibili-digest && git push -u origin main"
    echo ""
    echo "🔄 重新运行监控:"
    echo "   bash ~/bilibili-digest/true-auto-push.sh"
    exit 1
fi
