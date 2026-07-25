#!/bin/bash

echo "🍪 获取新B站Cookie并测试限流问题"
echo "=================================="
echo ""
echo "📋 请按以下步骤获取新Cookie："
echo ""
echo "第1步：打开B站网站"
echo "   在浏览器中访问: https://www.bilibili.com"
echo ""
open "https://www.bilibili.com"

echo "第2步：打开开发者工具"
echo "   • Mac: 按 F12 或 Cmd+Option+I"
echo "   • Windows: 按 F12 或 Ctrl+Shift+I"
echo ""
echo "第3步：切换到Network标签"
echo "   • 点击开发者工具顶部的 'Network' 标签"
echo "   • 刷新页面 (按 F5 或 Cmd+R)"
echo ""
echo "第4步：找到Cookie"
echo "   • 点击任意一个请求（通常是第一个）"
echo "   • 在右侧面板找到 'Request Headers'"
echo "   • 找到 'Cookie' 字段"
echo "   • 复制整个Cookie值"
echo ""
echo "第5步：粘贴Cookie"
echo "   • 将Cookie粘贴到下面"
echo ""

read -p "请粘贴你的新Cookie: " NEW_COOKIE

if [ -n "$NEW_COOKIE" ]; then
    echo ""
    echo "✅ 已获取新Cookie"
    echo ""
    echo "🧪 准备测试新Cookie..."
    echo ""
    
    # 创建测试脚本
    cat > /tmp/test-new-cookie.js << 'TEST'
import { writeFileSync } from 'fs';

const COOKIE = process.env.BILI_COOKIE;
const uid = "474921808"; // 测试一个UP主

console.log('🧪 测试新Cookie是否解决限流问题...');
console.log('📍 测试UP主: code秘密花园');
console.log('');

async function testCookie() {
    try {
        const response = await fetch(`https://api.bilibili.com/x/space/arc/search?mid=${uid}&ps=10&jsonp=jsonp`, {
            headers: {
                'Cookie': COOKIE,
                'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
                'Referer': 'https://www.bilibili.com'
            }
        });

        const data = await response.json();
        
        if (data.code === 0) {
            console.log('🎉 成功！新Cookie工作正常！');
            console.log(`   ✅ API返回正常`);
            console.log(`   📺 获取到 ${data.data.list.vlist.length} 个视频`);
            console.log('');
            console.log('🛡️ 限流问题已解决！');
            return true;
        } else if (data.code === -799) {
            console.log('❌ 仍然被限流');
            console.log(`   错误码: ${data.code}`);
            console.log(`   错误信息: ${data.message}`);
            console.log('');
            console.log('💡 可能的原因:');
            console.log('   • IP地址可能也在黑名单中');
            console.log('   • 需要等待一段时间再试');
            console.log('   • 考虑使用极低频率模式');
            return false;
        } else {
            console.log('⚠️ API返回错误');
            console.log(`   错误码: ${data.code}`);
            console.log(`   错误信息: ${data.message}`);
            return false;
        }
    } catch (error) {
        console.log('❌ 请求失败:', error.message);
        return false;
    }
}

testCookie();
TEST

    # 设置环境变量并测试
    export BILI_COOKIE="$NEW_COOKIE"
    
    if node /tmp/test-new-cookie.js; then
        echo ""
        echo "🎊 测试成功！新Cookie可以正常使用！"
        echo ""
        echo "📝 更新系统配置..."
        
        # 更新配置文件
        echo "export BILI_COOKIE=\"$NEW_COOKIE\"" > ~/bilibili-digest/.bilibili-cookie
        
        echo "✅ Cookie已保存到: ~/bilibili-digest/.bilibili-cookie"
        echo ""
        echo "🚀 现在可以运行系统:"
        echo "   bash ~/bilibili-digest/scripts/run-digest.sh"
        echo ""
        echo "📅 设置定时任务:"
        echo "   bash ~/bilibili-digest/scripts/update-crontab.sh"
    else
        echo ""
        echo "⚠️ 新Cookie仍然遇到限流问题"
        echo ""
        echo "💡 建议的解决方案:"
        echo "   1. 使用极低频率模式 (推荐)"
        echo "   2. 手动运行，每周1-2次"
        echo "   3. 考虑扩展到其他平台"
    fi
else
    echo "❌ 未提供Cookie，测试取消"
fi
