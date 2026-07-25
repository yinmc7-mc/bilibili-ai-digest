#!/bin/bash

echo "🔍 GitHub仓库确认和推送"
echo "========================="
echo ""
echo "请确认以下信息："
echo ""
echo "1. 你的GitHub账户: yninmc7-mc"
echo "2. 仓库名称: bilibili-ai-digest"
echo "3. 完整URL: https://github.com/yninmc7-mc/bilibili-ai-digest"
echo ""
echo "如果信息正确，请按回车继续..."
echo "如果信息不正确，请输入正确的仓库名称："
read REPO_NAME

if [ -z "$REPO_NAME" ]; then
    REPO_NAME="bilibili-ai-digest"
fi

echo ""
echo "🔧 配置仓库为: github.com/yninmc7-mc/$REPO_NAME"
echo ""

cd ~/bilibili-digest

# 更新远程仓库URL（使用SSH）
git remote set-url origin git@github.com:yninmc7-mc/$REPO_NAME.git

echo "🚀 尝试推送..."
echo ""

# 显示当前状态
echo "📊 推送信息："
echo "   目标: git@github.com:yninmc7-mc/$REPO_NAME.git"
echo "   分支: main"
echo "   Commits: $(git log --oneline | wc -l | tr -d ' ')"
echo "   文件: $(git ls-files | wc -l | tr -d ' ')"
echo ""

# 测试SSH连接
echo "🔑 测试SSH连接..."
if ssh -T git@github.com 2>&1 | grep -q "yinmc7-mc"; then
    echo "✅ SSH连接正常"
else
    echo "❌ SSH连接有问题"
    echo "请检查SSH密钥配置"
    exit 1
fi

echo ""
echo "📤 推送代码..."
echo ""

# 执行推送
if git push -u origin main 2>&1; then
    echo ""
    echo "🎉 成功！代码已推送到GitHub！"
    echo ""
    echo "📍 仓库地址: https://github.com/yninmc7-mc/$REPO_NAME"
    echo ""
    echo "✅ 推送完成的内容:"
    git log --oneline -5
    echo ""
    
    # 在浏览器中打开仓库
    echo "🌐 在浏览器中打开仓库..."
    open "https://github.com/yninmc7-mc/$REPO_NAME"
    echo ""
    echo "🎊 恭喜！你的B站AI摘要系统已在GitHub上线！"
    echo ""
    echo "📋 系统功能："
    echo "   ✅ 17个AI/科技UP主监控"
    echo "   ✅ 每日自动扫描新视频"
    echo "   ✅ 双语摘要生成"
    echo "   ✅ 飞书自动推送"
    echo "   ✅ 定时任务调度（7:30AM）"
    echo ""
    echo "🚀 GitHub推送完成！"
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "可能的原因："
    echo "1. 仓库名称不正确"
    echo "2. 仓库权限问题"
    echo "3. 网络连接问题"
    echo ""
    echo "💡 解决方法："
    echo "1. 确认仓库名称: $REPO_NAME"
    echo "2. 访问: https://github.com/yninmc7-mc/$REPO_NAME"
    echo "3. 如果404，说明仓库不存在，需要先创建"
    echo ""
    echo "🔄 重新运行: bash ~/bilibili-digest/confirm-and-push.sh"
    exit 1
fi
