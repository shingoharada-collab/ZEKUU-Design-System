# Atlas Design System

建設・不動産プロダクトのための統合UIデザインシステム。
Apple Human Interface Guidelines に着想を得て、**Universal / Construction (建設) / Real Estate (不動産)** の3バリアントを切替可能。
モバイル / タブレット / デスクトップに対応。

## 公開URL

GitHub Pages にデプロイすると以下のURLで閲覧できます (リポジトリ名は適宜置換):

```
https://<your-org-or-username>.github.io/<repo-name>/
```

例: `https://synesthesias.github.io/atlas-design-system/`

## 含まれるもの

| ファイル | 役割 |
|---|---|
| `index.html` | デザインシステム可視化サイト (この1ファイルで完結) |
| `design-tokens.css` | CSS 変数のみを抽出した配布用トークン |
| `CLAUDE-UI-DESIGN.md` | Claude などのAIに本DSへ準拠させるためのガイドライン |
| `.nojekyll` | GitHub Pages の Jekyll 処理を無効化 |
| `.github/workflows/pages.yml` | push で自動デプロイする GitHub Actions |

## ローカルで動かす

`index.html` をブラウザで開くだけでも動きますが、`file://` だと一部の機能が制限されることがあるため簡易サーバ推奨:

```sh
# Python があれば
python3 -m http.server 8080
# Node があれば
npx serve .
```

ブラウザで `http://localhost:8080/` を開くと閲覧できます。

## GitHub Pages にデプロイする (3つの方法)

### 方法A: 自動デプロイ (推奨)

リポジトリに `.github/workflows/pages.yml` を含めてあるので、以下の手順で自動デプロイできます。

1. GitHubで新しいリポジトリを作成 (例: `atlas-design-system`)
2. このフォルダの中身をすべて push:
   ```sh
   git init
   git branch -M main
   git remote add origin git@github.com:<your-org>/atlas-design-system.git
   git add .
   git commit -m "Initial commit: Atlas Design System v0.1"
   git push -u origin main
   ```
3. リポジトリの **Settings → Pages** を開く
4. **Source** を `GitHub Actions` に設定
5. push のたびに自動でビルド&公開され、`https://<owner>.github.io/<repo>/` で閲覧可能

### 方法B: main ブランチから直接配信

GitHub Actions を使わず、`main` ブランチのルートをそのまま配信する方法:

1. リポジトリにファイルを push
2. **Settings → Pages**
3. **Source** を `Deploy from a branch` に設定
4. **Branch** を `main` / `/ (root)` に設定
5. 数十秒待つと公開URLが表示される

### 方法C: docs フォルダから配信 (リポジトリ整理向け)

ソースコードと公開ファイルを混在させたくない場合、`docs/` フォルダに移動:

```sh
mkdir docs
mv index.html design-tokens.css CLAUDE-UI-DESIGN.md .nojekyll docs/
git add . && git commit -m "Move site to docs/" && git push
```

その後 **Settings → Pages → Source: `main` / `/docs`** を選択。

## 公開範囲のコントロール

`index.html` の `<head>` 内に以下のmetaタグが入っています:

```html
<meta name="robots" content="noindex,nofollow" />
```

- **このまま**: URLを知っている人だけが見られる (検索エンジンに載らない)
- **完全公開する**: この行を削除すれば検索インデックス対象になります

**もっと厳密に制限したい場合 (パスワードや SSO):**

GitHub Pages のパブリックリポジトリは誰でもURL経由でアクセス可能です。アクセス制限が必要な場合は以下の選択肢を検討:

- **Private リポジトリ + GitHub Enterprise** — Pages を組織内限定で公開可能
- **Cloudflare Pages + Cloudflare Access** — Google/Microsoft アカウントでSSO
- **Netlify + Password Protection** — 簡易パスワード保護 (有料プラン)

## カスタムドメイン

`design.synesthesias.jp` のような独自ドメインを使うには:

1. リポジトリのルートに `CNAME` ファイルを作成し、ドメイン名のみを記述:
   ```
   design.synesthesias.jp
   ```
2. DNSプロバイダで CNAME レコードを `<owner>.github.io` に向ける
3. **Settings → Pages → Custom domain** に同じドメインを入力
4. **Enforce HTTPS** にチェック

## 開発ワークフロー

- 主な変更箇所は `index.html` 内 `<style>...</style>` のCSS変数および各セクションのHTML
- `design-tokens.css` は `index.html` の `:root` 部分と1対1で同期させる (`extract-tokens.sh` 等のスクリプトを将来追加予定)
- `CLAUDE-UI-DESIGN.md` のトークン参照表もトークン名変更時に更新

## ライセンス / 帰属

社内利用を想定。Apple HIG / Material Design 3 を参考に独自構築。
