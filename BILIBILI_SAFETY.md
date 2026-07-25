# B站API风控保护说明

## 🔍 当前风险分析

### ⚠️ 潜在风险
1. **请求频率**: 17个UP主同时请求可能触发限流
2. **固定模式**: 每天7:30固定时间运行，模式可预测
3. **Cookie风险**: Cookie可能过期或被检测
4. **API限制**: B站API有频率限制和风控机制

## 🛡️ 安全保护措施

### 已实现的安全功能
- ✅ **请求延迟**: 3-7秒随机延迟
- ✅ **分批处理**: 分4批，每批5个UP主
- ✅ **重试机制**: 失败自动重试3次
- ✅ **错误处理**: 检测API限流错误
- ✅ **User-Agent轮换**: 随机User-Agent
- ✅ **批次间隔**: 批次间15-30秒随机延迟

### 使用安全版本

```bash
# 使用安全版本脚本
node ~/bilibili-digest/scripts/generate-bilibili-feed-safe.js

# 更新定时任务使用安全版本
crontab -e
# 将原来的脚本替换为安全版本
```

## 📊 安全级别对比

| 功能 | 原版本 | 安全版本 |
|------|--------|----------|
| 请求延迟 | 无 | 3-7秒随机 |
| 分批处理 | 无 | 4批处理 |
| 重试机制 | 无 | 3次重试 |
| User-Agent | 固定 | 随机轮换 |
| 错误检测 | 基础 | 高级检测 |
| 批次间隔 | 无 | 15-30秒 |

## ⚙️ 定时任务配置建议

### 当前配置 (风险中等)
```
30 7 * * * bash ~/bilibili-digest/scripts/scheduled-digest.sh
```

### 建议配置 (风险低)
```bash
# 方法1: 随机化时间 (推荐)
# 在7:00-8:00之间随机时间运行
0 7 * * * sleep $((RANDOM % 3600)); bash ~/bilibili-digest/scripts/scheduled-digest-safe.sh

# 方法2: 分散运行
# 分成多个时间段运行
0,15,30,45 7-8 * * * bash ~/bilibili-digest/scripts/scheduled-digest-safe.sh
```

## 🔧 Cookie管理

### Cookie更新方法
1. 登录B站网站
2. 打开浏览器开发者工具
3. 复制Cookie中的关键值
4. 更新脚本中的COOKIE变量

### 环境变量方式 (推荐)
```bash
# 设置环境变量
export BILI_COOKIE="your_cookie_here"

# 在脚本中使用
const COOKIE = process.env.BILI_COOKIE || 'default_cookie';
```

## 📈 监控和维护

### 检查运行状态
```bash
# 查看最近的feed
cat ~/bilibili-digest/feed/feed-bilibili.json

# 检查日志
tail -f ~/bilibili-digest/logs/digest.log
```

### 故障排除
- 如果频繁出现限流错误，增加延迟时间
- 如果Cookie失效，更新Cookie值
- 如果API返回错误，检查网络连接

## 🎯 最佳实践

1. **逐步增加**: 开始时减少UP主数量，逐步增加
2. **监控日志**: 定期检查日志，发现异常及时调整
3. **备选方案**: 准备多个Cookie，轮换使用
4. **时间分散**: 避免固定时间运行
5. **错误容忍**: 部分UP主失败不应影响整体运行

## ⚡ 紧急应对

如果遇到风控问题：
1. 立即停止定时任务
2. 增加请求延迟到10-15秒
3. 减少每天运行频率
4. 更换Cookie或IP地址
5. 联系B站客服说明情况

---

**注意**: 即使有所有保护措施，仍然存在一定风险。请根据实际情况调整参数。
