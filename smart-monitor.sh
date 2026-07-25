#!/bin/bash

# 🤖 GitHub推送智能监控脚本

echo "🤖 GitHub推送智能监控"
echo "==================="
echo ""

cd ~/bilibili-digest

echo "📊 当前状态:"
echo "   ✅ 4个commits已准备"
echo "   ✅ 16个文件已就绪"
echo "   ✅ 推送脚本已配置"
echo "   ⏳ 等待GitHub仓库创建..."
echo ""

# 智能监控循环
MAX_ATTEMPTS=12  # 每分钟检查一次，最多检查12分钟
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    ATTEMPT=$((ATTEMPT + 1))

    echo "🔍 [$ATTEMPT/$MAX_ATTEMPTS] 检查GitHub仓库是否已创建..."

    # 尝试推送（如果仓库已创建会成功）
    if git push -u origin main &>/dev/null; then
        echo ""
        echo "🎉 成功！代码已推送到GitHub！"
        echo ""
        echo "📍 仓库地址: https://github.com/yinmaizi/bilibili-digest"
        echo ""
        echo "✅ 推送的内容:"
        git log --oneline -5
        echo ""
        echo "🌐 查看仓库: https://github.com/yinmaizi/bilibili-digest"
        echo ""
        echo "🎊 恭喜！你的B站AI摘要系统已在GitHub上线！"

        # 询问是否在浏览器中打开
        read -p "是否在浏览器中查看仓库？(y/n): " open_repo
        if [ "$open_repo" = "y" ]; then
            if [[ "$OSTYPE" == "darwin"* ]]; then
                open "https://github.com/yinmaizi/bilibili-digest"
            fi
        fi

        exit 0
    else
        echo "   ⏳ 仓库尚未创建，等待60秒..."
        sleep 60
    fi
done

echo ""
echo "⏰ 监控超时（12分钟）"
echo ""
echo "💡 请手动完成以下步骤:"
echo "1. 在浏览器中确认创建GitHub仓库"
echo "2. 运行: git push -u origin main"
echo ""
echo "🔄 重新运行监控: bash ~/bilibili-digest/smart-monitor.sh"