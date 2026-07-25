#!/usr/bin/env node

/**
 * Bilibili Video Feed Generator - Safe Version
 * 
 * 改进的风控保护：
 * - 请求延迟和随机化
 * - 错误处理和重试
 * - Cookie失效检测
 * - 分批处理降低请求密度
 */

import { writeFileSync, mkdirSync, readFileSync } from 'fs';
import { join } from 'path';
import { homedir } from 'os';

// Configuration
const AI_CREATORS = [
  { uid: "474921808", name: "code秘密花园", category: "AI工具" },
  { uid: "50247550", name: "清华姜学长", category: "AI教育" },
  { uid: "64169458", name: "Google中国", category: "科技企业" },
  { uid: "385670211", name: "秋芝2046", category: "AI工具" },
  { uid: "3546726858229991", name: "TRAE_ai", category: "AI工具" },
  { uid: "3546860354538082", name: "硅谷101播客", category: "科技播客" },
  { uid: "483104470", name: "阿里达摩院扫地僧", category: "科技企业" },
  { uid: "3546830056983337", name: "吴恩达-深度学习", category: "AI教育" },
  { uid: "538596213", name: "罗永浩的十字路口", category: "科技播客" },
  { uid: "521974986", name: "Unitree宇树科技", category: "机器人科技" },
  { uid: "1567748478", name: "跟李沐学AI", category: "AI教育" },
  { uid: "3493134979827825", name: "吴恩达深度学习", category: "AI教育" },
  { uid: "650922239", name: "未来论坛", category: "科技论坛" },
  { uid: "476111084", name: "IsaacSim教程", category: "具身智能" },
  { uid: "472543316", name: "AI老兵文哲", category: "AI科普" },
  { uid: "3493136967928639", name: "大模型微调教程", category: "AI教育" }
];

// 请求配置
const COOKIE = process.env.BILI_COOKIE || 'SESSDATA=4c8dae73%2C1800517572%2C0ac2d%2A72; bili_jct=4db08d7df2290cee7fa2a162c7bc2d08; DedeUserID=360632375; DedeUserID__ckMd5=eeb391b20ef14c6e; buvid3=3843A649-0A0C-BC62-0D34-FEA38B6DD52393722infoc';
const USER_AGENTS = [
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Safari/605.1.15'
];

// 工具函数：随机延迟
function randomDelay(min, max) {
  const delay = Math.floor(Math.random() * (max - min + 1)) + min;
  return delay * 1000;
}

// 工具函数：随机User-Agent
function getRandomUserAgent() {
  return USER_AGENTS[Math.floor(Math.random() * USER_AGENTS.length)];
}

// 工具函数：延迟函数
function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// 改进的请求函数：包含重试机制
async function fetchWithRetry(url, options, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      const response = await fetch(url, options);
      
      if (response.ok) {
        const data = await response.json();
        
        // 检查B站API错误码
        if (data.code === -6 || data.code === -110 || data.code === -111) {
          console.warn(`  ⚠️ API限流错误 (${data.code}): ${data.message || '频繁请求'}`);
          if (i < retries - 1) {
            const waitTime = Math.pow(2, i) * 5000; // 指数退避
            console.log(`  🔄 等待${waitTime/1000}秒后重试 (${i+1}/${retries})...`);
            await delay(waitTime);
            continue;
          }
        }
        
        if (data.code !== 0 && data.code !== -6 && data.code !== -110 && data.code !== -111) {
          console.error(`  ❌ API错误 (${data.code}): ${data.message}`);
          return null;
        }
        
        return data;
      }
      
      // HTTP错误处理
      if (response.status === 412) {
        console.error('  ❌ Cookie失效或被封禁');
        return null;
      }
      
      console.warn(`  ⚠️ HTTP错误 (${response.status})`);
      if (i < retries - 1) {
        await delay(3000);
        continue;
      }
      
    } catch (error) {
      console.error(`  ❌ 请求失败: ${error.message}`);
      if (i < retries - 1) {
        await delay(3000);
        continue;
      }
    }
  }
  return null;
}

// 获取UP主视频（带延迟和错误处理）
async function fetchCreatorVideos(uid, name) {
  try {
    console.log(`📺 正在获取 ${name} 的视频...`);
    
    const response = await fetchWithRetry(
      `https://api.bilibili.com/x/space/arc/search?mid=${uid}&ps=10&jsonp=jsonp`,
      {
        headers: {
          'Cookie': COOKIE,
          'User-Agent': getRandomUserAgent(),
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
      console.log(`  ⚪ API返回错误: ${response.message || '未知错误'}`);
      return [];
    }
    
    // 提取视频信息
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

// 分批处理UP主
function batchCreators(creators, batchSize = 5) {
  const batches = [];
  for (let i = 0; i < creators.length; i += batchSize) {
    batches.push(creators.slice(i, i + batchSize));
  }
  return batches;
}

// 主函数：生成feed（带安全措施）
async function generateFeed() {
  console.log('🎯 开始生成B站AI/科技视频feed...');
  console.log('🛡️ 已启用风控保护措施');
  
  const feed = {
    generatedAt: new Date().toISOString(),
    lookbackHours: 24,
    safety: {
      requestDelay: '3-7秒随机延迟',
      userAgentRotation: '启用',
      retryMechanism: '启用',
      batchProcessing: '启用'
    },
    bilibili: []
  };
  
  // 分批处理UP主（每批5个）
  const batches = batchCreators(AI_CREATORS, 5);
  console.log(`\n📊 将分 ${batches.length} 批处理 ${AI_CREATORS.length} 个UP主\n`);
  
  for (let batchIndex = 0; batchIndex < batches.length; batchIndex++) {
    const batch = batches[batchIndex];
    console.log(`\n🔄 处理第 ${batchIndex + 1}/${batches.length} 批 (${batch.length}个UP主):`);
    
    for (let i = 0; i < batch.length; i++) {
      const creator = batch[i];
      
      // 获取UP主视频
      const videos = await fetchCreatorVideos(creator.uid, creator.name);
      
      // 过滤最近24小时的视频
      const recentVideos = videos.filter(video => {
        const videoAge = Date.now() - new Date(video.publishedAt).getTime();
        const hoursAgo = videoAge / (1000 * 60 * 60);
        return hoursAgo <= 24;
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
        
        console.log(`  📰 找到 ${recentVideos.length} 个最近视频`);
      } else {
        console.log(`  ⚪ 没有最近视频`);
      }
      
      // 批内请求间隔（3-7秒随机）
      if (i < batch.length - 1) {
        const delayTime = randomDelay(3, 7);
        console.log(`  ⏳ 等待${delayTime/1000}秒...`);
        await delay(delayTime);
      }
    }
    
    // 批次间间隔（15-30秒随机）
    if (batchIndex < batches.length - 1) {
      const batchDelay = randomDelay(15, 30);
      console.log(`\n⏰ 批次间等待${batchDelay/1000}秒...`);
      await delay(batchDelay);
    }
  }
  
  // 保存feed到文件
  const feedDir = join(homedir(), 'bilibili-digest/feed');
  mkdirSync(feedDir, { recursive: true });
  
  const feedFile = join(feedDir, 'feed-bilibili.json');
  writeFileSync(feedFile, JSON.stringify(feed, null, 2));
  
  // 生成统计信息
  const stats = {
    totalCreators: AI_CREATORS.length,
    activeCreators: feed.bilibili.length,
    totalVideos: feed.bilibili.reduce((sum, creator) => sum + creator.videos.length, 0),
    batchesProcessed: batches.length,
    generatedAt: feed.generatedAt,
    safetyFeatures: feed.safety
  };
  
  console.log('\n📊 Feed生成完成:');
  console.log(`   总UP主数: ${stats.totalCreators}`);
  console.log(`   活跃UP主: ${stats.activeCreators}`);
  console.log(`   总视频数: ${stats.totalVideos}`);
  console.log(`   处理批次: ${stats.batchesProcessed}`);
  console.log(`   Feed保存位置: ${feedFile}`);
  console.log('   🛡️ 风控保护: 已启用');
  
  return feed;
}

// 运行feed生成
generateFeed().catch(error => {
  console.error('❌ Feed生成失败:', error);
  process.exit(1);
});
