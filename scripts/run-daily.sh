#!/bin/bash

# Bilibili AI Digest - Daily Automation Script

echo "🎯 Bilibili AI Digest - Daily Automation"
echo "========================================"

# Step 1: Generate fresh feed
echo "📡 Step 1: Generating Bilibili feed..."
node ~/bilibili-digest/scripts/generate-bilibili-feed.js

if [ $? -eq 0 ]; then
    echo "✅ Feed generated successfully"
else
    echo "❌ Feed generation failed"
    exit 1
fi

# Step 2: Prepare digest data
echo "📝 Step 2: Preparing digest data..."
node ~/bilibili-digest/scripts/prepare-digest.js > /tmp/bilibili-digest-data.json

if [ $? -eq 0 ]; then
    echo "✅ Digest data prepared"
else
    echo "❌ Digest data preparation failed"
    exit 1
fi

# Step 3: Show statistics
echo "📊 Step 3: Digest Statistics:"
node -e "
const data = require('/tmp/bilibili-digest-data.json');
console.log('   Active Creators:', data.stats.totalCreators);
console.log('   Total Videos:', data.stats.totalVideos);
console.log('   Feed Age:', new Date() - new Date(data.stats.feedGeneratedAt), 'ms');
"

echo ""
echo "🎉 Daily digest preparation complete!"
echo "📁 Data saved to: /tmp/bilibili-digest-data.json"
echo ""
echo "💡 Next: Use this data with your LLM to generate the actual digest"
echo "   Then deliver to Feishu using: node ~/bilibili-digest/scripts/deliver.js --file <digest.txt>"