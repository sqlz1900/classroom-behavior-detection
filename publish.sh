#!/bin/bash
# 一键发布流水线：本地提交 → 推 GitHub + Gitee
# 用法: bash publish.sh "提交说明"
set -e
cd "$(dirname "$0")"   # publish/repo

MSG="${1:-docs: 更新项目展示内容}"
BRANCH="main"

echo "═══ 1/4 暂存变更 ═══"
git add -A

if git diff --cached --quiet; then
  echo "  无变更，跳过提交（仍执行推送）"
else
  git -c user.name="sqlz1900" -c user.email="sqlz1900@users.noreply.github.com" commit -m "$MSG"
  echo "  已提交: $MSG"
fi

echo "═══ 2/4 推送 GitHub ═══"
if git push -u origin "$BRANCH" 2>&1; then
  echo "  ✅ GitHub OK"
else
  echo "  ❌ GitHub 失败——检查: ① github.com 是否已添加 id_ed25519.pub 公钥 ② 仓库是否已创建"
  echo "     手动验证: ssh -T git@github.com"
fi

echo "═══ 3/4 推送 Gitee ═══"
if git push -u gitee "$BRANCH" 2>&1; then
  echo "  ✅ Gitee OK"
else
  echo "  ❌ Gitee 失败——检查: ① gitee 账号是否已加对应公钥 ② 仓库是否已创建"
  echo "     手动验证: ssh -T git@gitee.com"
fi

echo "═══ 4/4 结果 ═══"
git log --oneline -3
echo "GitHub : https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]//;s/\.git$//')"
echo "Gitee  : https://gitee.com/$(git remote get-url gitee | sed 's/.*gitee.com[:/]//;s/\.git$//')"
