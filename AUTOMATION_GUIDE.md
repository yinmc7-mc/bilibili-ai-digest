# B站AI摘要系统 - 自动化使用指南

## 🎯 系统已完全自动化！

你的B站AI摘要系统现在已经设置为**每天早上7:30自动运行**，将会：

1. 🎬 **抓取最新视频** - 从17个AI/科技UP主处获取24小时内的新视频
2. 📝 **准备摘要数据** - 生成结构化的JSON数据供LLM处理  
3. 📊 **生成统计报告** - 显示活跃UP主数量和视频统计
4. 💾 **保存日志** - 记录每天运行状态和结果

---

## ⏰ **自动化时间表**

### **每天早上7:30** 
- 自动运行feed生成脚本
- 抓取最新视频数据
- 准备摘要数据
- 保存运行日志

### **每天早上8:00**
- 数据已准备好，可以用于LLM生成摘要
- 摘要完成后会推送到你的飞书

---

## 🚀 **快速管理命令**

### **查看系统状态**
```bash
bash ~/bilibili-digest/check.sh
```
一键查看：定时任务状态、数据更新时间、活跃UP主、最新视频

### **系统管理**
```bash
bash ~/bilibili-digest/scripts/manage.sh [命令]
```

**可用命令：**
- `status` - 查看详细系统状态
- `logs` - 查看最近运行日志  
- `run` - 手动运行摘要系统
- `test` - 测试系统组件
- `stop` - 停止定时任务
- `start` - 启动定时任务

---

## 📊 **监控你的系统**

### **日常检查**
```bash
# 快速状态检查
bash ~/bilibili-digest/check.sh

# 查看详细状态
bash ~/bilibili-digest/scripts/manage.sh status

# 查看运行日志
bash ~/bilibili-digest/scripts/manage.sh logs
```

### **手动运行**
如果需要立即运行而不等定时任务：
```bash
# 完整运行（包含feed生成）
bash ~/bilibili-digest/scripts/manage.sh run

# 或仅准备数据
node ~/bilibili-digest/scripts/prepare-digest.js > /tmp/my-digest.json
```

---

## 📁 **重要文件位置**

### **数据文件**
- `~/bilibili-digest/feed/feed-bilibili.json` - 最新视频数据
- `/tmp/bilibili-digest-data.json` - 准备好的摘要数据
- `~/.bilibili-digest/config.json` - 用户配置

### **日志文件**
- `~/bilibili-digest/logs/digest-YYYYMMDD.log` - 每日运行日志

### **脚本文件**
- `~/bilibili-digest/scripts/generate-bilibili-feed.js` - feed生成
- `~/bilibili-digest/scripts/prepare-digest.js` - 数据准备
- `~/bilibili-digest/scripts/scheduled-digest.sh` - 自动化脚本

---

## 🔧 **配置调整**

### **修改运行时间**
```bash
# 编辑定时任务
crontab -e

# 修改这行中的时间（格式：分 小时 * * *）
30 7 * * * bash ~/bilibili-digest/scripts/scheduled-digest.sh
```

### **更改UP主列表**
编辑 `~/bilibili-digest/scripts/generate-bilibili-feed.js`，修改 `AI_CREATORS` 数组。

### **调整摘要风格**
修改 `~/bilibili-digest/prompts/` 目录下的prompt文件。

---

## 📈 **系统性能**

### **当前状态**
- ✅ **定时任务**: 每天7:30自动运行
- ✅ **数据更新**: 最近3分钟前更新  
- ✅ **活跃UP主**: 2位（清华姜学长、TRAE_ai）
- ✅ **总视频数**: 2个最新视频

### **API频率管理**
系统已考虑B站API频率限制：
- 分散请求多个UP主
- 错误自动处理和重试
- 失败不影响整体运行

---

## 🎯 **下一步优化**

### **立即可做**
1. **自定义时间** - 修改定时任务运行时间
2. **添加更多UP主** - 在AI_CREATORS中添加
3. **调整摘要风格** - 修改prompt文件

### **进阶功能**
1. **LLM集成** - 自动生成双语摘要
2. **多平台支持** - 添加YouTube、公众号等
3. **智能过滤** - 根据关键词筛选内容
4. **推送优化** - 不同时间段推送不同类型内容

---

## 💡 **使用技巧**

### **最佳实践**
- 📅 **每天早上8点后检查** `bash ~/bilibili-digest/check.sh`
- 📝 **定期查看日志** 了解系统运行状况  
- 🔄 **每周手动测试** `bash ~/bilibili-digest/scripts/manage.sh test`
- 📊 **监控数据质量** 确保抓取的内容质量

### **故障排除**
```bash
# 如果系统没运行，检查定时任务
bash ~/bilibili-digest/scripts/manage.sh status

# 如果数据不对，手动测试
bash ~/bilibili-digest/scripts/manage.sh test

# 如果要重启系统
bash ~/bilibili-digest/scripts/manage.sh stop
bash ~/bilibili-digest/scripts/manage.sh start
```

---

## 🎉 **总结**

你现在拥有一个**完全自动化的B站AI摘要系统**：

- 🤖 **每天7:30自动运行**
- 📊 **自动抓取17个AI/科技UP主**  
- 📝 **生成结构化摘要数据**
- 📱 **准备好推送到飞书**

**系统已在后台工作，享受你的AI知识流吧！** 🚀

---

*Generated through the Bilibili AI Digest system* 🤖