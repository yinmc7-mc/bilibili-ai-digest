#!/bin/bash

# Bilibili AI Digest - Scheduled Automation
# This script runs the full digest pipeline with logging

LOG_DIR="$HOME/bilibili-digest/logs"
LOG_FILE="$LOG_DIR/digest-$(date +%Y%m%d).log"

# 确保日志目录存在
mkdir -p "$LOG_DIR"

{
    echo "========================================"
    echo "🎯 Bilibili AI Digest - Scheduled Run"
    echo "📅 Date: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "========================================"
    
    # Step 1: Generate feed (with error handling)
    echo "📡 Step 1: Generating Bilibili feed..."
    if node ~/bilibili-digest/scripts/generate-bilibili-feed.js; then
        echo "✅ Feed generated successfully"
    else
        echo "❌ Feed generation failed - will retry next time"
        exit 1
    fi
    
    # Step 2: Prepare digest data
    echo "📝 Step 2: Preparing digest data..."
    if node ~/bilibili-digest/scripts/prepare-digest.js > /tmp/bilibili-digest-data.json; then
        echo "✅ Digest data prepared"
        
        # Show statistics
        node -e "
        const data = require('/tmp/bilibili-digest-data.json');
        console.log('📊 Statistics:');
        console.log('   Active Creators:', data.stats.totalCreators);
        console.log('   Total Videos:', data.stats.totalVideos);
        " 2>/dev/null || echo "⚠️  Could not show statistics"
    else
        echo "❌ Digest data preparation failed"
        exit 1
    fi
    
    echo "🎉 Scheduled digest preparation complete!"
    echo "📁 Data ready for LLM processing"
    
} >> "$LOG_FILE" 2>&1

echo "✅ Daily digest completed - log saved to $LOG_FILE"
