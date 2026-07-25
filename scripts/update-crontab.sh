#!/bin/bash

# B站AI摘要系统 - 定时任务配置脚本

echo "🕒 B站AI摘要系统 - 定时任务配置"
echo "==============================="
echo ""

echo "请选择运行频率:"
echo "1. 每3天（推荐）- 降低限流风险"
echo "2. 每周一、三、五"
echo "3. 每天（高风险）"
echo "4. 自定义"
echo ""

read -p "请选择频率 (1/2/3/4): " frequency

case $frequency in
    1|"1")
        # 每3天运行一次（使用极低频率模式）
        echo ""
        echo "📅 配置每3天运行..."
        (crontab -l 2>/dev/null | grep -v bilibili; echo "0 7 */3 * * bash ~/bilibili-digest/scripts/scheduled-digest-minimal.sh >> ~/bilibili-digest/logs/cron.log 2>&1") | crontab -
        echo "✅ 已配置：每3天早上7点运行"
        ;;
    2|"2")
        # 周一、三、五运行
        echo ""
        echo "📅 配置周一、三、五运行..."
        (crontab -l 2>/dev/null | grep -v bilibili; echo "0 7 * * 1,3,5 bash ~/bilibili-digest/scripts/scheduled-digest-safe.sh >> ~/bilibili-digest/logs/cron.log 2>&1") | crontab -
        echo "✅ 已配置：周一、三、五早上7点运行"
        ;;
    3|"3")
        # 每天运行
        echo ""
        echo "📅 配置每天运行（高风险）..."
        (crontab -l 2>/dev/null | grep -v bilibili; echo "30 7 * * * bash ~/bilibili-digest/scripts/scheduled-digest-safe.sh >> ~/bilibili-digest/logs/cron.log 2>&1") | crontab -
        echo "✅ 已配置：每天早上7:30运行"
        echo "⚠️ 警告：高频运行可能导致B站限流"
        ;;
    4|"4")
        # 自定义
        echo ""
        read -p "请输入cron表达式: " custom_cron
        echo ""
        read -p "请输入脚本路径 (默认: ~/bilibili-digest/scripts/scheduled-digest-safe.sh): " script_path
        script_path=${script_path:-~/bilibili-digest/scripts/scheduled-digest-safe.sh}
        
        (crontab -l 2>/dev/null | grep -v bilibili; echo "$custom_cron $script_path >> ~/bilibili-digest/logs/cron.log 2>&1") | crontab -
        echo "✅ 已配置自定义定时任务"
        ;;
    *)
        echo ""
        echo "❌ 无效选择"
        exit 1
        ;;
esac

echo ""
echo "📊 当前定时任务配置:"
echo "===================="
crontab -l | grep bilibili || echo "   (无bilibili相关任务)"

echo ""
echo "📝 查看所有定时任务: crontab -l"
echo "🗑️ 删除定时任务: crontab -e (删除相应行)"
