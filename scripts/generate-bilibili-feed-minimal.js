#!/usr/bin/env node

/**
 * Bilibili Video Feed Generator - Minimal Version
 * 
 * 极低频率版本，应对B站API限流
 * - 只监控4个最重要的AI/科技UP主
 * - 30-60秒随机延迟
 * - 适合每3天运行一次
 */

import { writeFileSync, mkdirSync } from 'fs';
import { join } from 'path';
import { homedir } from 'os';

// 只选择最重要的4个AI/科技UP主
const AI_CREATORS = [
  { uid: "474921808", name: "code秘密花园", category: "AI工具" },
  { uid: "1567748478", name: "跟李沐学AI", "category": "AI教育" },
  { uid: "472543316", name: "AI老兵文哲", category: "AI科普" },
  { uid: "521974986", name: "Unitree宇树科技", category: "机器人科技" }
];

const COOKIE = process.env.BILI_COOKIE || 'SESSDATA=4c8dae73%2C1800517572%2C0ac2d%2A72; bili_jct=4db08d7df2290cee7fa2a162c7bc2d08; DedeUserID=360632375; DedeUserID__ckMd5=eeb391b20ef14c6e; buvid3=3843A649-0A0C-BC62-0D34-FEA38B6DD52393722infoc';

// 极长延迟：30-60秒随机
function randomDelay() {
  const delay = Math.floor(Math.random() * 31) + 30; // 30-60秒
  return delay * 1000;
}

function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// 改进的请求函数：更长重试延迟
async function fetchWithRetry(url, options, retries = 5) {
  for (let i = 0; i < retries; i++) {
    try {
      const response = await fetch(url, options);
      
      if (response.ok) {
        const data = await response.json();
        
        // 检测限流错误
        if (data.code === -799 || data.code === -6 || data.code === -110 || data.code === -111) {
          console.warn(`  ⚠️ API限流 (${data.code})`);
          if (i < retries - 1) {
            const waitTime = Math.pow(3, i) * 10000; // 更长的指数退避
            console.log(`  🔄 等待${waitTime/1000}秒后重试...`);
            await delay(waitTime);
            continue;
          }
        }
        
        if (data.code !== 0 && data.code !== -799) {
          console.error(`  ❌ API错误: ${data.message}`);
          return null;
        }
        
        return data;
      }
      
      if (response.status === 412) {
        console.error('  ❌ Cookie可能失效');
        return null;
      }
      
      if (i < retries - 1) {
        await delay(5000);
        continue;
      }
      
    } catch (error) {
      console.error(`  ❌ 请求失败: ${error.message}`);
      if (i < retries - 1) {
        await delay(5000);
        continue;
      }
    }
  }
  return null;
}

async function fetchCreatorVideos(uid, name) {
  try {
    console.log(`📺 正在获取 ${name} 的视频...`);
    
    const response = await fetchWithRetry(
      `https://api.bilibili.com/x/space/arc/search?mid=${uid}&ps=10&jsonp=jsonp`,
      {
        headers: {
          'Cookie': COOKIE,
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Referer': 'https://www.bilibili.com',
          'Accept': 'application/json, text/plain, */*',
          'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
          'Connection': 'keep-alive'
        }
      }
    );
    
    if (!response) {
      console.log(`  ⚪ 获取失败，跳过`);
      return [];
    }
    
    if (response.code !== 0) {
      console.log(`  ⚪ API错误: ${response.message || '未知错误'}`);
      return [];
    }
    
    const videos = response.data.list.vlist || [];
    console.log(`  ✅ 成功获取 ${videos.length} 个视频`);
    
    return videos.map(video => ({
      bvid: video.bvid,
      title: video.title,
      description: video.description,
      publishedAt: new Date(video.created * 1000).toISOString(),
      url: `https://www.bilibili.com/video/${video.bvid}`,
      duration: video.length,
      viewCount: video.play,
      commentCount: video.comment,
      author: video.author,
      uid: video.mid
    }));
    
  } catch (error) {
    console.error(`  ❌ 获取失败: ${error.message}`);
    return [];
  }
}

async function generateFeed() {
  console.log('🎯 B站AI/科技视频feed生成 - 极低频率版本');
  console.log('🛡️ 风控保护: 最大延迟 + 最小UP主数量');
  console.log('');
  
  const feed = {
    generatedAt: new Date().toISOString(),
    lookbackHours: 72, // 扩展到72小时（3天）
    version: 'minimal',
    safety: {
      requestDelay: '30-60秒',
      creatorCount: 4,
      frequency: '每3天',
      retryAttempts: 5
    },
    bilibili: []
  };
  
  console.log(`📊 处理 ${AI_CREATORS.length} 个重要UP主\n`);
  
  for (let i = 0; i < AI_CREATORS.length; i++) {
    const creator = AI_CREATORS[i];
    
    const videos = await fetchCreatorVideos(creator.uid, creator.name);
    
    // 过滤最近72小时的视频（3天内）
    const recentVideos = videos.filter(video => {
      const videoAge = Date.now() - new Date(video.publishedAt).getTime();
      const hoursAgo = videoAge / (1000 * 60 * 60);
      return hoursAgo <= 72;
    });
    
    if (recentVideos.length > 0) {
      feed.bilibili.push({
        source: 'bilibili',
        name: creator.name,
        uid: creator.uid,
        category: creator.category,
        videos: recentVideos.map(video => ({
          bvid: video.bvid,
          title: video.title,
          description: video.description ? video.description.substring(0, 500) : '',
          publishedAt: video.publishedAt,
          url: video.url,
          viewCount: video.viewCount,
          duration: video.duration
        }))
      });
      
      console.log(`  📰 找到 ${recentVideos.length} 个最近视频（3天内）`);
    } else {
      console.log(`  ⚪ 没有最近视频（3天内）`);
    }
    
    // 极长的请求间隔（30-60秒）
    if (i < AI_CREATORS.length - 1) {
      const delayTime = randomDelay();
      console.log(`  ⏳ 等待${delayTime/1000}秒以避免限流...\n`);
      await delay(delayTime);
    }
  }
  
  // 保存feed
  const feedDir = join(homedir(), 'bilibili-digest/feed');
  mkdirSync(feedDir, { recursive: true });
  
  const feedFile = join(feedDir, 'feed-bilibili-minimal.json');
  writeFileSync(feedFile, JSON.stringify(feed, null, 2));
  
  const stats = {
    totalCreators: AI_CREATORS.length,
    activeCreators: feed.bilibili.length,
    totalVideos: feed.bilibili.reduce((sum, creator) => sum + creator.videos.length, 0),
    generatedAt: feed.generatedAt,
    safetyFeatures: feed.safety
  };
  
  console.log('\n📊 Feed生成完成:');
  console.log(`   总UP主数: ${stats.totalCreators}`);
  console.log(`   活跃UP主: ${stats.activeCreators}`);
  console.log(`   总视频数: ${stats.totalVideos}`);
  console.log(`   时间范围: 72小时（3天）`);
  console.log(`   Feed位置: ${feedFile}`);
  console.log('   🛡️ 极低频率模式: 已启用');
  
  return feed;
}

generateFeed().catch(error => {
  console.error('❌ Feed生成失败:', error);
  process.exit(1);
});
