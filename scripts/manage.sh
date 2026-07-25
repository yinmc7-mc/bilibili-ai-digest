#!/bin/bash

# Bilibili AI Digest - System Management Script

case "$1" in
    "status")
        echo "📊 系统状态检查"
        echo "=================="
        echo "🤖 定时任务状态："
        crontab -l | grep bilibili || echo "⚠️  未找到定时任务"
        echo ""
        echo "📁 最新数据文件："
        if [ -f ~/bilibili-digest/feed/feed-bilibili.json ]; then
            echo "✅ Feed文件存在 ($(stat -f '%Sm' -t '%Y-%m-%d %H:%M:%S' ~/bilibili-digest/feed/feed-bilibili.json))"
            node -e "
            const feed = require('$(echo ~/bilibili-digest/feed/feed-bilibili.json)');
            console.log('   活跃UP主:', feed.bilibili.length);
            console.log('   总视频数:', feed.bilibili.reduce((sum, c) => sum + c.videos.length, 0));
            " 2>/dev/null || echo "⚠️  无法解析feed数据"
        else
            echo "❌ Feed文件不存在"
        fi
        ;;
    
    "logs")
        echo "📝 最近日志："
        echo "==============="
        if [ -d ~/bilibili-digest/logs ]; then
            tail -20 ~/bilibili-digest/logs/digest-*.log 2>/dev/null || echo "暂无日志文件"
        else
            echo "❌ 日志目录不存在"
        fi
        ;;
    
    "run")
        echo "🚀 手动运行摘要系统..."
        bash ~/bilibili-digest/scripts/scheduled-digest.sh
        ;;
    
    "test")
        echo "🧪 测试系统各组件..."
        echo "📡 测试feed生成..."
        node ~/bilibili-digest/scripts/generate-bilibili-feed.js
        echo ""
        echo "📝 测试数据准备..."
        node ~/bilibili-digest/scripts/prepare-digest.js > /tmp/test-digest.json
        echo "✅ 测试完成，数据保存在 /tmp/test-digest.json"
        ;;
    
    "stop")
        echo "🛑 停止定时任务..."
        crontab -l | grep -v bilibili | crontab -
        echo "✅ 定时任务已移除"
        ;;
    
    "start")
        echo "▶️  启动定时任务..."
        (crontab -l | grep -v bilibili; echo "30 7 * * * bash ~/bilibili-digest/scripts/scheduled-digest.sh") | crontab -
        echo "✅ 定时任务已设置 (每天7:30)"
        ;;
    
    *)
        echo "🎯 Bilibili AI Digest - 系统管理"
        echo ""
        echo "用法: bash ~/bilibili-digest/scripts/manage.sh [命令]"
        echo ""
        echo "命令:"
        echo "  status  - 查看系统状态"
        echo "  logs    - 查看最近日志"
        echo "  run     - 手动运行摘要系统"
        echo "  test    - 测试系统组件"
        echo "  stop    - 停止定时任务"
        echo "  start   - 启动定时任务"
        ;;
esac
