#!/usr/bin/env node

/**
 * Bilibili Video Feed Generator
 *
 * Fetches latest videos from AI/tech creators and generates a centralized feed
 * Similar to zarazhangrui's follow-builders architecture
 */

import { writeFileSync, mkdirSync } from 'fs';
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

const COOKIE = 'SESSDATA=4c8dae73%2C1800517572%2C0ac2d%2A72; bili_jct=4db08d7df2290cee7fa2a162c7bc2d08; DedeUserID=360632375; DedeUserID__ckMd5=eeb391b20ef14c6e; buvid3=3843A649-0A0C-BC62-0D34-FEA38B6DD52393722infoc';
const USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36';

// Fetch videos from a specific creator
async function fetchCreatorVideos(uid) {
  try {
    const response = await fetch(`https://api.bilibili.com/x/space/arc/search?mid=${uid}&ps=10&jsonp=jsonp`, {
      headers: {
        'Cookie': COOKIE,
        'User-Agent': USER_AGENT,
        'Referer': 'https://www.bilibili.com'
      }
    });

    if (!response.ok) {
      console.error(`Failed to fetch videos for UID ${uid}:`, response.status);
      return [];
    }

    const data = await response.json();

    if (data.code !== 0) {
      console.error(`API error for UID ${uid}:`, data.message);
      return [];
    }

    // Extract video information
    const videos = data.data.list.vlist || [];

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
    console.error(`Error fetching videos for UID ${uid}:`, error.message);
    return [];
  }
}

// Main function to generate feed
async function generateFeed() {
  console.log('🎯 Starting Bilibili AI/Tech Feed Generation...');

  const feed = {
    generatedAt: new Date().toISOString(),
    lookbackHours: 24,
    bilibili: []
  };

  for (const creator of AI_CREATORS) {
    console.log(`📺 Fetching videos from ${creator.name}...`);

    const videos = await fetchCreatorVideos(creator.uid);

    // Filter videos from last 24 hours
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

      console.log(`  ✅ Found ${recentVideos.length} recent videos`);
    } else {
      console.log(`  ⚪ No recent videos`);
    }
  }

  // Save feed to file
  const feedDir = join(homedir(), 'bilibili-digest/feed');
  mkdirSync(feedDir, { recursive: true });

  const feedFile = join(feedDir, 'feed-bilibili.json');
  writeFileSync(feedFile, JSON.stringify(feed, null, 2));

  // Generate statistics
  const stats = {
    totalCreators: AI_CREATORS.length,
    activeCreators: feed.bilibili.length,
    totalVideos: feed.bilibili.reduce((sum, creator) => sum + creator.videos.length, 0),
    generatedAt: feed.generatedAt
  };

  console.log('\n📊 Feed Generation Complete:');
  console.log(`   Total Creators: ${stats.totalCreators}`);
  console.log(`   Active Creators: ${stats.activeCreators}`);
  console.log(`   Total Videos: ${stats.totalVideos}`);
  console.log(`   Feed saved to: ${feedFile}`);

  return feed;
}

// Run the feed generation
generateFeed().catch(error => {
  console.error('❌ Feed generation failed:', error);
  process.exit(1);
});