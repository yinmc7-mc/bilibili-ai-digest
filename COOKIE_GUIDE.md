# 🍪 B站Cookie获取和更换指南

## 🎯 目标：获取新Cookie解决API限流问题

### 📋 详细步骤：

#### 第1步：清除现有Cookie
1. 打开浏览器设置
2. 找到B站相关的Cookie
3. 删除所有bilibili.com的Cookie

#### 第2步：重新登录B站
1. 访问：https://www.bilibili.com
2. 重新登录你的账号
3. 确保登录成功

#### 第3步：获取新Cookie
**方法A：使用开发者工具（推荐）**
1. 在B站页面按F12打开开发者工具
2. 切换到"Network"标签
3. 刷新页面（F5）
4. 点击第一个请求
5. 在右侧"Headers"中找到"Cookie"
6. 复制整个Cookie值

**方法B：使用浏览器插件**
- 安装"EditThisCookie"插件
- 直接查看和复制Cookie

#### 第4步：更新系统Cookie

```bash
# 方法1：环境变量（推荐）
export BILI_COOKIE="你的新Cookie"

# 方法2：保存到文件
echo "export BILI_COOKIE=\"你的新Cookie\"" > ~/bilibili-digest/.bilibili-cookie

# 方法3：直接修改脚本
# 编辑 scripts/generate-bilibili-feed-minimal.js
# 更新 COOKIE 变量的值
```

#### 第5步：测试新Cookie

```bash
# 使用新Cookie测试
export BILI_COOKIE="你的新Cookie"
node ~/bilibili-digest/scripts/generate-bilibili-feed-minimal.js
```

## 🔍 测试结果判断：

### ✅ 成功标志：
- 能正常获取视频数据
- 没有出现-799错误码
- 显示"成功获取X个视频"

### ❌ 失败标志：
- 仍然出现-799错误
- "请求过于频繁"错误
- Cookie失效错误

## 🛡️ 如果仍然被限流：

### 方案A：降低频率
```bash
# 使用极低频率模式
bash ~/bilibili-digest/scripts/run-digest.sh
# 选择模式1（极低频率）
```

### 方案B：手动运行
```bash
# 停用定时任务
crontab -e
# 删除bilibili相关行

# 每周手动运行1-2次
bash ~/bilibili-digest/scripts/run-digest.sh
```

### 方案C：扩展数据源
- 添加YouTube监控
- 添加微信公众号
- 使用其他科技内容源

## 📊 Cookie有效期：

- **通常有效期**: 几周到几个月
- **失效标志**: 412错误、Cookie失效提示
- **建议**: 每2-3个月更换一次

## 🚨 注意事项：

1. **不要分享Cookie**：包含你的登录信息
2. **定期更换**：避免被B站检测到异常模式
3. **备份保存**：保存到安全的地方
4. **观察效果**：更换后测试是否解决限流

## 💡 最佳实践：

1. **多个Cookie轮换**: 准备2-3个Cookie轮换使用
2. **降低请求频率**: 减少到每3天一次
3. **分散运行时间**: 避免固定时间运行
4. **监控日志**: 定期检查运行日志

---

🎯 **立即行动**：按照上述步骤获取新Cookie，然后测试！
