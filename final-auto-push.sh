#!/bash

echo "🤖 GitHub自动推送系统"
echo "====================="
echo ""

cd ~/bilibili-digest

echo "📊 准备推送的内容："
echo "   ✅ 5个commits"
echo "   ✅ 27个文件" 
echo "   ✅ 完整的B站AI摘要系统"
echo ""

echo "第1步：打开GitHub创建页面"
echo "=========================="
echo ""
echo "正在打开GitHub创建页面（信息已预填）..."
open "https://github.com/new?name=bilibili-ai-digest&description=Bilibili+AI+Digest+System&public=true"

echo "✅ 已在浏览器中打开创建页面"
echo ""
echo "📋 请在浏览器中："
echo "   1. 确认仓库名：bilibili-ai-digest"
echo "   2. 描述：Bilibili AI Digest System"
echo "   3. 可见性：Public"
echo "   4. ⚠️ 不要勾选任何初始化选项"
echo "   5. 点击绿色按钮：Create repository"
echo ""

echo "第2步：自动监控并推送"
echo "===================="
echo ""
echo "⏳ 系统将每30秒检查一次仓库是否创建成功..."
echo "⏡ 最多检查10次（5分钟）"
echo ""

# 配置远程仓库
git remote set-url origin git@github.com:yninmc7-mc/bilibili-ai-digest.git

# 监控循环
MAX_ATTEMPTS=10
ATTEMPT=0
SUCCESS=false

while [ $ATTEMPT -lt $MAX_ATTEMPTS ] && [ "$SUCCESS" = false ]; do
    ATTEMPT=$((ATTEMPT + 1))
    
    echo "🔍 [$ATTEMPT/$MAX_ATTEMPTS] 检查仓库状态..."
    
    # 尝试推送（如果仓库已创建会成功）
    if git push -u origin main &>/dev/null; then
        SUCCESS=true
        echo "   ✅ 仓库已创建！"
        break
    else
        if [ $ATTEMPT -lt $MAX_ATTEMPTS ]; then
            echo "   ⏳ 仓库尚未创建，等待30秒..."
            sleep 30
        fi
    fi
done

if [ "$SUCCESS" = true ]; then
    echo ""
    echo "🎉 成功！代码已推送到GitHub！"
    echo ""
    echo "📍 仓库地址: https://github.com/yninmc7-mc/bilibili-ai-digest"
    echo ""
    echo "✅ 推送完成的内容:"
    git log --oneline -5
    echo ""
    echo "📊 文件统计:"
    git ls-files | wc -l | echo "   总文件: $(cat)" 
    echo ""
    echo "🌐 在浏览器中查看仓库..."
    open "https://github.com/yninmc7-mc/bilibili-ai-digest"
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
else
    echo ""
    echo "⏰ 监控超时（5分钟）"
    echo ""
    echo "💡 请手动确认："
    echo "1. 仓库是否创建成功"
    echo "   访问: https://github.com/yninmc7-mc/bilibili-ai-digest"
    echo ""
    echo "2. 如果创建成功，手动推送："
    echo "   cd ~/bilibili-digest && git push -u origin main"
    echo ""
    echo "🔄 重新运行自动监控: bash ~/bilibili-digest/final-auto-push.sh"
fi
