#!/usr/bin/env bash
# Atlas Design System — GitHub Pages デプロイ用スクリプト
#
# 使い方:
#   1. このスクリプトと同じフォルダで実行する
#      (index.html, CLAUDE-UI-DESIGN.md などがあるフォルダ)
#   2. 事前にGitHubで空のリポジトリを作成しておく
#      https://github.com/new → リポジトリ名だけ決めて Create
#   3. 下の REMOTE_URL を自分のリポジトリに書き換える
#   4. ./deploy.sh を実行
#
# 必要なもの: git, gh (GitHub CLI) があれば自動でリポジトリも作れる

set -euo pipefail

# ▼ ここをご自身のGitHubリポジトリに書き換えてください ▼
REMOTE_URL="git@github.com:YOUR_ORG_OR_USERNAME/atlas-design-system.git"
COMMIT_MSG="${1:-Atlas Design System: deploy}"
# ▲▲▲

echo "==> Atlas Design System デプロイ開始"

# 既に .git があれば、それを使う。なければ初期化
if [ ! -d .git ]; then
  echo "==> git init"
  git init -q
  git branch -M main
fi

# remote 設定 (なければ追加、あれば更新)
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

# ステージング & コミット
git add -A
if git diff --cached --quiet; then
  echo "==> 変更がないため commit はスキップ"
else
  git commit -m "$COMMIT_MSG" -q
  echo "==> commit 作成完了: $COMMIT_MSG"
fi

# プッシュ
echo "==> push origin main"
git push -u origin main

cat <<EOF

==========================================
✅ GitHub への push 完了
==========================================

次の手順 (初回のみ):
  1. ブラウザで https://github.com/<your-org>/<repo>/settings/pages を開く
  2. Build and deployment → Source を "GitHub Actions" に設定
  3. 数十秒〜1分後、画面上部に公開URLが表示されます
     例: https://<your-org>.github.io/<repo>/

以降は ./deploy.sh を実行するだけで自動再デプロイされます。
EOF
