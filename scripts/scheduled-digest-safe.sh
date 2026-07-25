#!/bin/bash

# B站AI摘要 - 安全版本定时任务
# 包含风控保护和错误处理

echo "🎯 B站AI摘要系统 - 安全版本启动"
echo "================================="
echo ""

# 设置工作目录
cd ~/bilibili-digest

# 创建日志目录
mkdir -p logs

# 生成带时间戳的日志文件
LOG_FILE="logs/digest-$(date +%Y%m%d-%H%M%S).log"

echo "📝 日志文件: $LOG_FILE"
echo "🛡️ 安全保护: 已启用"
echo ""

# 运行安全的feed生成
echo "📺 步骤1: 生成B站feed..."
if node scripts/generate-bilibili-feed-safe.js >> "$LOG_FILE" 2>&1; then
    echo "   ✅ Feed生成成功"
else
    echo "   ❌ Feed生成失败，请检查日志"
    exit 1
fi

echo ""
echo "📝 步骤2: 准备摘要数据..."
if node scripts/prepare-digest.js >> "$LOG_FILE" 2>&1; then
    echo "   ✅ 数据准备成功"
else
    echo "   ❌ 数据准备失败"
    exit 1
fi

echo ""
echo "🤖 步骤3: 生成AI摘要..."
if node scripts/remix-digest.js >> "$LOG_FILE" 2>&1; then
    echo "   ✅ 摘要生成成功"
else
    echo "   ❌ 摘要生成失败"
    exit 1
fi

echo ""
echo "📤 步骤4: 推送到飞书..."
if node scripts/deliver-digest.js >> "$LOG_FILE" 2>&1; then
    echo "   ✅ 飞书推送成功"
else
    echo "   ⚠️ 飞书推送失败（摘要已生成）"
fi

echo ""
echo "🎊 B站AI摘要完成！"
echo "📁 日志位置: ~/bilibili-digest/$LOG_FILE"
echo ""

# 显示简要统计
if [ -f "feed/feed-bilibili.json" ]; then
    echo "📊 今日统计:"
    node -e "
    const fs = require('fs');
    const feed = JSON.parse(fs.readFileSync('feed/feed-bilibili.json', 'utf8'));
    console.log(\`   活跃UP主: \${feed.bilibili.length}\`);
    console.log(\`   总视频数: \${feed.bilibili.reduce((sum, c) => sum + c.videos.length, 0)}\`);
    console.log(\`   生成时间: \${new Date(feed.generatedAt).toLocaleString('zh-CN')}\`);
    "
fi

echo ""
echo "🛡️ 安全措施统计:"
echo "   ✅ 请求延迟: 3-7秒随机"
echo "   ✅ 分批处理: 4批处理"
echo "   ✅ 重试机制: 3次重试"
echo "   ✅ User-Agent轮换: 启用"
echo "   ✅ 批次间隔: 15-30秒"
echo ""

# 清理旧日志（保留最近7天）
find logs -name "digest-*.log" -mtime +7 -delete 2>/dev/null

echo "🚀 下次运行时间: 明天 7:00-8:00 之间随机时间"
