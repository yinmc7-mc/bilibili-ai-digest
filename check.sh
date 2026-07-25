#!/bin/bash

# 快捷监控脚本 - 一键查看系统状态

echo "🎯 B站AI摘要系统 - 快捷状态检查"
echo "========================================"
echo ""

# 检查定时任务
if crontab -l | grep -q bilibili; then
    echo "⏰ 定时任务: ✅ 已设置 (每天7:30)"
else
    echo "⏰ 定时任务: ❌ 未设置"
fi

# 检查最新数据
if [ -f ~/bilibili-digest/feed/feed-bilibili.json ]; then
    FEED_AGE=$(node -e "console.log(Date.now() - new Date(require('$(echo ~/bilibili-digest/feed/feed-bilibili.json)').generatedAt).getTime())" 2>/dev/null)
    FEED_MINUTES=$((FEED_AGE / 60000))
    echo "📊 数据更新: ✅ ${FEED_MINUTES}分钟前"
    
    # 显示活跃UP主
    ACTIVE_COUNT=$(node -e "console.log(require('$(echo ~/bilibili-digest/feed/feed-bilibili.json)').bilibili.length)" 2>/dev/null)
    echo "👥 活跃UP主: ${ACTIVE_COUNT}位"
    
    # 显示最新视频
    echo ""
    echo "📺 最新视频:"
    node -e "
    const feed = require('$(echo ~/bilibili-digest/feed/feed-bilibili.json)');
    feed.bilibili.slice(0, 3).forEach(creator => {
        creator.videos.slice(0, 2).forEach(video => {
            console.log('   • ' + creator.name + ': ' + video.title.substring(0, 40) + '...');
        });
    });
    " 2>/dev/null || echo "   (无法显示详情)"
else
    echo "📊 数据更新: ❌ 无数据文件"
fi

# 检查系统状态
echo ""
echo "🔧 系统状态:"
if [ -d ~/bilibili-digest/logs ]; then
    LOG_COUNT=$(ls ~/bilibili-digest/logs/*.log 2>/dev/null | wc -l)
    echo "   日志文件: ${LOG_COUNT}个"
fi

echo ""
echo "💡 管理命令: bash ~/bilibili-digest/scripts/manage.sh [status|logs|run|test]"
