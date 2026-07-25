# Bilibili AI Digest System

Inspired by [zarazhangrui/follow-builders](https://github.com/zarazhangrui/follow-builders), this system monitors AI/tech creators on Bilibili and delivers bilingual daily digests to your Feishu.

## 🎯 What It Does

- **Monitors 17 top AI/tech creators** on Bilibili
- **Fetches latest videos** every 24 hours  
- **Generates bilingual summaries** (Chinese + English)
- **Delivers to Feishu** at 8 AM Beijing time daily
- **Focus on practical insights** from AI practitioners

## 📁 Project Structure

```
bilibili-digest/
├── scripts/
│   ├── generate-bilibili-feed.js    # Fetch latest videos from creators
│   ├── prepare-digest.js             # Prepare data for LLM remixing
│   └── deliver.js                    # Deliver to Feishu
├── prompts/
│   ├── summarize-bilibili-videos.md   # How to summarize videos
│   ├── digest-intro-bilibili.md      # Digest formatting rules
│   └── translate-bilibili.md          # Bilingual translation rules
├── feed/
│   └── feed-bilibili.json             # Latest video data (auto-generated)
└── config.json                        # User preferences
```

## 🚀 How to Use

### 1. Generate Feed
```bash
node ~/bilibili-digest/scripts/generate-bilibili-feed.js
```
This fetches the latest videos from all 17 AI/tech creators and generates `feed/feed-bilibili.json`.

### 2. Generate Digest (Interactive)
Currently, run the digest generation interactively:
```bash
# Run prepare-digest to get the JSON data
node ~/bilibili-digest/scripts/prepare-digest.js > /tmp/digest-data.json

# Then use the data with your LLM agent to generate the digest
```

### 3. Deliver to Feishu
```bash
# The digest will be automatically delivered to your configured Feishu
echo "Your digest content" | node ~/bilibili-digest/scripts/deliver.js
```

## 📊 Current Setup

**Tracked Creators:** 17 AI/tech creators
**Categories:** AI教育, AI工具, 科技企业, 科技播客, 机器人科技
**Language:** Bilingual (Chinese + English)
**Delivery:** Daily 8 AM Beijing time → Feishu

## 🔧 Configuration

Edit `~/.bilibili-digest/config.json`:

```json
{
  "language": "bilingual",     // Options: "zh", "en", "bilingual"
  "frequency": "daily",        // Options: "daily", "weekly"  
  "timezone": "Asia/Shanghai",
  "deliveryTime": "08:00",
  "delivery": {
    "method": "feishu"         // Current delivery method
  }
}
```

## 📝 AI/Tech Creators Tracked

### AI教育 (AI Education)
- 跟李沐学AI
- 清华姜学长
- 吴恩达-深度学习
- 吴恩达深度学习
- 大模型微调教程

### AI工具 (AI Tools)  
- code秘密花园
- TRAE_ai
- 秋芝2046

### 科技企业 (Tech Companies)
- Google中国
- 阿里达摩院扫地僧
- Unitree宇树科技

### 科技播客 (Tech Podcasts)
- 硅谷101播客
- 罗永浩的十字路口

### 机器人/具身智能 (Robotics/Embodied AI)
- IsaacSim教程

### AI科普 (AI Science Communication)
- AI老兵文哲

### 科技论坛 (Tech Forums)
- 未来论坛

## 🔮 Next Steps

To make this fully automated like follow-builders:

1. **Set up cron jobs** for automatic feed generation
2. **Integrate with LLM** for automatic digest generation
3. **Add more creators** based on your interests
4. **Customize prompts** to match your preferred style

## 🎯 Architecture (Like follow-builders)

```
Bilibili API → Feed Generator → JSON Feed → LLM Remix → Bilingual Digest → Feishu
```

This mirrors the proven architecture of zarazhangrui's follow-builders:
- **Central feed generation** (no user API keys needed)
- **Local LLM remixing** (personalized summaries)
- **Flexible delivery** (Feishu, Telegram, Email, etc.)

## 💡 Philosophy

**Follow builders, not influencers.** 

This system tracks AI practitioners who actually build products and share technical insights, not content aggregators or news commentators.

---

Generated through the Bilibili AI Digest system 🤖