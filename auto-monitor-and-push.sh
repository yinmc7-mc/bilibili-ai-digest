#!/bin/bash

echo "🤖 自动监控并推送GitHub仓库"
echo "================================"
echo ""
echo "📋 请在浏览器中完成以下步骤："
echo ""
echo "1. 已自动打开GitHub创建页面"
echo "2. 仓库名：bilibili-ai-digest"
echo "3. 描述：Bilibili AI Digest System"
echo "4. 选择：Public"
echo "5. ⚠️ 不要勾选任何初始化选项"
echo "6. 点击：Create repository"
echo ""

# 打开GitHub创建页面
open "https://github.com/new?name=bilibili-ai-digest&description=Bilibili+AI+Digest+System&public=true"

echo "⏳ 等待你创建仓库... (我会每10秒检查一次)"
echo ""

cd ~/bilibili-digest

# 监控循环 - 每10秒检查一次，最多检查3分钟
MAX_ATTEMPTS=18
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    ATTEMPT=$((ATTEMPT + 1))
    
    echo "🔍 [$ATTEMPT/$MAX_ATTEMPTS] 检查仓库是否已创建..."
    
    # 尝试推送（如果仓库已创建会成功）
    if git push -u origin main &>/dev/null; then
        echo ""
        echo "🎉 成功！代码已推送到GitHub！"
        echo ""
        echo "📍 仓库地址: https://github.com/yninmc7-mc/bilibili-ai-digest"
        echo ""
        echo "✅ 推送完成的内容:"
        git log --oneline -5
        echo ""
        echo "🌐 在浏览器中打开仓库..."
        open "https://github.com/yninmc7-mc/bilibili-ai-digest"
        echo ""
        echo "🎊 恭喜！你的B站AI摘要系统已在GitHub上线！"
        echo ""
        echo "📋 系统功能："
        echo "   ✅ 17个AI/科技UP主监控"
        echo "   ✅ 每日自动扫描新视频"
        echo "   ✅ 双语摘要生成"
        echo "   ✅ 飞书自动推送"
        echo "   ✅ 定时任务调度（7:30AM）"
        echo ""
        echo "🚀 GitHub推送完成！"
        exit 0
    else
        echo "   ⏳ 仓库尚未创建，等待10秒..."
        sleep 10
    fi
done

echo ""
echo "⏰ 监控超时（3分钟）"
echo ""
echo "💡 请确认："
echo "1. 仓库名是否为: bilibili-ai-digest"
echo "2. GitHub用户名是否为: yninmc7-mc"
echo "3. 仓库是否已成功创建"
echo ""
echo "🔄 手动推送命令: cd ~/bilibili-digest && git push -u origin main"
echo ""
echo "🔄 重新运行监控: bash ~/bilibili-digest/auto-monitor-and-push.sh"
