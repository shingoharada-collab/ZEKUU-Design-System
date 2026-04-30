# Atlas Design System — CLAUDE-UI-DESIGN.md

> このファイルは Claude などの AI 開発エージェントに、本リポジトリで生成・変更する UI が **Atlas Design System** に準拠するよう指示するための仕様書です。
> 新しい画面、コンポーネント、プロダクトを生成するときは、必ず本書のルールに従ってください。

---

## 0. 前提

- 対象業界: **建設 (Construction)**, **不動産 (Real Estate)**, およびこれらに依存しない **業界中立 (Universal)** プロダクト。
- 想定デバイス: **モバイル (スマホ)**, **タブレット**, **デスクトップ**。Apple HIG (Human Interface Guidelines) に着想を得た「静かに正確で、コンテンツが主役」なUI。
- 技術中立: トークンは CSS 変数として定義され、HTML / React / SwiftUI / Jetpack Compose / Flutter のいずれにも翻訳できます。
- 同梱資産: `design-tokens.css` (本サイトの `:root` をエクスポート), `index.html` (ライブ可視化), 本 `CLAUDE-UI-DESIGN.md`。
- ファイル名の意図: `CLAUDE-UI-DESIGN.md` は **UIデザインに関する規約** に特化したClaude向け指示書。バックエンド・データ・運用などの別領域用ガイドライン (例: `CLAUDE-API.md`, `CLAUDE-DATA.md`) と並列して配置することを想定している。

---

## 1. AI への黄金律 (このまま守ってください)

1. **セマンティックトークンを必ず経由する。** `--accent`, `--fg-default`, `--bg-canvas`, `--border-subtle` などを使い、`--brand-500` や `--neutral-200` をコンポーネント実装で**直接参照しない**。
2. **モバイルファーストで CSS を書く。** ベースをモバイル(〜480px)向けに書き、`@media (min-width: …)` で上位デバイスへ拡張する。逆順 (`max-width:` ベース) は禁止。
3. **タップ最小 44×44px。** 建設バリアントでは 48×48px。`min-height: var(--touch-min)` を必ず付ける。
4. **入力フィールドのフォントは 16px 以上。** iOS Safariの自動ズームを防ぐため `font-size: max(16px, var(--fs-callout));`。
5. **`prefers-reduced-motion` を尊重する。** 装飾アニメーションは停止し、状態変化はクロスフェードに置換する。
6. **コントラスト比は WCAG 2.2 AA 以上。** 建設バリアントは屋外で読むため AAA (本文 7:1) を目標にする。
7. **業界バリアントは見た目だけ変える。** 情報設計 (構造・順序・粒度) は変えない。同じ機能は3バリアントで等価に動く。
8. **claude.md (本ファイル) と `design-tokens.css` の整合性を保つ。** トークン名を変更したら両方更新する。

---

## 2. デザイントークン (CSS 変数)

> 実装では必ずセマンティック層を参照すること。バリアントは `data-variant` 属性で切替。

```html
<body data-variant="universal" data-theme="light"> ... </body>
<!-- data-variant: "universal" | "construction" | "realestate" -->
<!-- data-theme:   "light" | "dark" -->
```

### 2.1 カラー (セマンティック層)

| トークン | 用途 |
|---|---|
| `--accent` | プライマリアクション、リンク、選択状態 |
| `--accent-pressed` | 押下/アクティブ状態 |
| `--accent-soft` | アクセントの背景バリエーション (タグ、選択中ハイライト) |
| `--bg-canvas` | アプリ最背面 |
| `--bg-surface` | カード、シート、モーダル |
| `--bg-surface-2` / `--bg-surface-3` | 段階的に上に重なる面 |
| `--bg-overlay` | 半透明オーバーレイ (topbar/bottom-nav 用) |
| `--border-subtle` / `--border-default` / `--border-strong` | 境界線 (用途で使い分け) |
| `--fg-default` | 本文テキスト |
| `--fg-secondary` / `--fg-tertiary` | 補助テキスト |
| `--fg-on-accent` | アクセント上の文字 (通常 `#fff`) |
| `--status-success` / `--status-warning` / `--status-danger` / `--status-info` | 状態色 |

### 2.2 タイポグラフィ

```css
--font-sans: -apple-system, "SF Pro Text", "Hiragino Sans", "Noto Sans JP", system-ui, sans-serif;
--fs-caption2: 11px; --fs-caption1: 12px; --fs-footnote: 13px;
--fs-subhead:  15px; --fs-callout: 16px; --fs-body: 17px; --fs-headline: 17px;
--fs-title3:   20px; --fs-title2:  22px; --fs-title1: 28px; --fs-largetitle: 34px;
--fs-display:  48px;
--lh-tight: 1.2;  --lh-normal: 1.45;  --lh-relaxed: 1.6;
--tracking-display: -0.022em;  --tracking-title: -0.012em;
```

**ルール**

- 日本語の本文は `--lh-normal: 1.45` 以上を維持。
- 見出しのみトラッキングを負方向に。本文は 0。
- 入力フィールドは **16px 以上**にし、iOS の自動ズームを防止。

### 2.3 スペーシング (4pt / 8pt grid)

`--space-2 (4)` `--space-3 (8)` `--space-4 (12)` `--space-5 (16)` `--space-6 (20)` `--space-7 (24)` `--space-8 (32)` `--space-10 (48)` `--space-12 (64)` `--space-16 (96)`

**ルール**

- コンポーネント内側は 4 の倍数 (4, 8, 12, 16, 20, 24)。
- コンポーネント間は 8 の倍数 (8, 16, 24, 32, 48, 64)。

### 2.4 角丸 / エレベーション / モーション

```css
--radius-xs:4 --radius-sm:6 --radius-md:10 --radius-lg:14 --radius-xl:20 --radius-2xl:28 --radius-full:9999

--elev-1: 0 1px 2px rgba(15,17,21,.04), 0 1px 1px rgba(15,17,21,.02);
--elev-2: 0 4px 12px ...;  --elev-3: 0 8px 24px ...;  --elev-modal: 0 24px 64px ...;

--ease-standard: cubic-bezier(.4, 0, .2, 1);
--ease-emphasized: cubic-bezier(.2, 0, 0, 1);
--dur-2: 150ms; --dur-3: 200ms; --dur-4: 300ms; --dur-5: 400ms;
```

### 2.5 レスポンシブ・ブレークポイント

| 名前 | 幅 | 主な対象 | ナビ形状 | 列数の目安 |
|---|---|---|---|---|
| mobile-sm | 〜375px | iPhone SE / 小型 Android | タブバー (下) + ドロワー | 1列 |
| mobile | 〜480px | 標準スマホ縦 | タブバー (下) + ドロワー | 1列 |
| tablet-sm | 〜768px | iPad mini / 縦持ちタブ | サイドバー (折畳) | 2列 |
| tablet | 〜1024px | iPad / iPad Pro 縦 | サイドバー (常設) | 2–3列 |
| desktop | 〜1280px | ノートPC | サイドバー + 詳細 | 3–4列 |
| desktop-lg | 1280px〜 | 外部ディスプレイ | サイドバー + 詳細 + ペイン | 4–6列 |

**実装テンプレート (CSS)**

```css
/* mobile-first: ベースが最小幅 */
.layout { grid-template-columns: 1fr; }

@media (min-width: 768px) {
  .layout { grid-template-columns: 220px 1fr; }   /* tablet */
}
@media (min-width: 1024px) {
  .layout { grid-template-columns: 248px 1fr; }   /* desktop */
}
@media (min-width: 1280px) {
  .layout { grid-template-columns: 280px 1fr 320px; } /* desktop-lg */
}
```

**SwiftUI / Flutter でも同等に**: `horizontalSizeClass == .compact` でモバイル相当、`MediaQuery` の breakpoint 関数を `bp-mobile/tablet/desktop` 名で揃える。

---

## 3. バリアント (業界別の上書き)

> セマンティック層**だけ**を上書きする。原始トークン (`--brand-*`) も上書き対象。

### 3.1 Universal (業界中立)

- `--accent: #007aff` (system-blue)
- BIダッシュボード、社内ツール、認証画面、設定画面など。

### 3.2 Construction (建設)

- `--accent: #ff6b00` (Safety Orange)
- `--touch-min: 48px` でタップ拡大 (グローブ対応)
- 屋外コントラスト用に `--border-default: #b9bec7`、`--fg-secondary: #4a4d54`
- 状態色: `--status-active`(進行中) `--status-onhold`(停止) `--status-delayed`(遅延) `--status-complete`(完了) `--status-warning: #ffcc00` (Hard Hat Yellow)
- 推奨フォント最小: 本文 17px、ラベル 13px。屋外では 1px 上げる選択肢を残す。
- アイコンは線太 2.5px (現場の眩しさで線が消えないよう)。

### 3.3 Real Estate (不動産)

- `--accent: #2f3a8a` (Deep Estate Indigo)
- `--accent-2: #c8a86b` (Warm Gold) — 価格・特集などプレミアム強調に。
- `--bg-canvas: #faf8f5` (warm off-white) でプレミアム感。
- 物件写真を主役にしたレイアウト。`property-card .photo` の `aspect-ratio: 16/10` (デスクトップ) / `4/3` (モバイル)。
- ディスプレイフォント (`--fs-display: 48px`) はヒーローのみ。

---

## 4. コンポーネント実装ルール

### 4.1 命名

- BEM 風: `.btn`, `.btn-primary`, `.btn-sm`, `.card`, `.card.elevated`, `.list .row` …
- React/Vue 等のフレームワークでは、上記クラス名と同じ意味のプロップス (`variant="primary"`, `size="sm"`) を持たせる。

### 4.2 ボタン

- `.btn` 基本、`.btn-primary` / `.btn-secondary` / `.btn-ghost` / `.btn-danger`。
- `min-height: var(--touch-min)`、`touch-action: manipulation`、`-webkit-tap-highlight-color: transparent`。
- **1画面に Primary は1つ**。
- 建設バリアントは `padding: 14px 22px` でさらに大きく。

### 4.3 入力

- `.input`, `.textarea`, `.select` は `border-radius: var(--radius-md)`、`padding: 11px 14px`。
- フォント: `font-size: max(16px, var(--fs-callout))`。
- フォーカス: `box-shadow: 0 0 0 4px color-mix(in srgb, var(--accent) 18%, transparent)`。
- エラー: `aria-invalid="true"` + `border-color: var(--status-danger)`。

### 4.4 カード / リスト

- カードは `--elev-1` を基本、ホバー対象は `--elev-2`。
- リスト行は最低 `padding: 14px 20px`、行の境界に `border-bottom: 1px solid var(--border-subtle)`。
- 行のリーディングアイコン枠は `36×36` 角丸 10px (Apple iOS Settings 風)。

### 4.5 タブ / トグル / プログレス

- セグメンテッドコントロール: `.tabs` で iOS 風の pill。
- トグル: 51×31px、緑(成功)で ON。
- プログレス: `4px` 高、アクセント色、トランジション `var(--dur-5) var(--ease-emphasized)`。

### 4.6 フィードバック (Toast / Modal / Tag)

- Toast: `--elev-3`、最大幅 420px (デスクトップ)、モバイルでは画面端から 12px の余白で全幅。
- Modal: `--radius-xl`、`--elev-modal`。モバイルではボトムシート (`border-radius: 20px 20px 0 0`、画面下端から登場) を推奨。
- Tag: pill 形状、`--bg-surface-2` 基本。状態タグは `color-mix` で半透明背景。

---

## 5. レイアウトとナビゲーション

### 5.1 デバイス別ナビ

| デバイス | 主ナビ | 補助 |
|---|---|---|
| モバイル | **下部タブバー** (3〜5項目) | ドロワー (左) |
| タブレット縦 | サイドバー (折畳可) | 上部に検索バー |
| タブレット横 / デスクトップ | **サイドバー (常設)** + 詳細ペイン | コマンドパレット (`Cmd/Ctrl+K`) |

### 5.2 セーフエリア (iOS / Android)

- `topbar`: `padding-top: env(safe-area-inset-top)`
- `main`: `padding-bottom: max(48px, env(safe-area-inset-bottom))`
- `bottom-nav`: `padding-bottom: calc(8px + env(safe-area-inset-bottom))`

### 5.3 親指リーチ (片手操作)

- 主要アクションは画面**下部**または**右下** (FAB) に配置。
- 画面上部のタップは戻る・閉じるなど補助操作のみ。

---

## 6. アクセシビリティ要件

- すべてのインタラクティブ要素に `:focus-visible` のリング (3px、`color-mix(... 35% transparent)`、オフセット 2px)。
- アイコンのみのボタンには `aria-label` を必ず付ける。
- フォームの `<label>` は `for` で関連付け。`hint` は `aria-describedby` に紐づける。
- カラーだけで状態を伝えない (アイコン or テキストを併用)。
- `prefers-reduced-motion: reduce` でアニメ停止。
- 言語属性: `<html lang="ja">` を基本に、英語コンテンツは `<span lang="en">`。

---

## 7. アイコン

- 24×24 グリッド、ストローク 2px (建設バリアントは 2.5px)、丸キャップ・丸ジョイン。
- 推奨セット: SF Symbols 互換または Lucide / Heroicons の outline。
- ファイルアイコンは現場・物件・図面・カレンダー・チャットの5系統を最低用意。

---

## 8. AI へのプロンプト・テンプレート

新規画面を生成する場合、以下のテンプレートに従って Claude に依頼してください。

```
[Atlas Design System準拠]
- バリアント: <universal | construction | realestate>
- 主デバイス: <mobile | tablet | desktop> (ただしモバイルでも崩れないこと)
- 画面: <例: 「日次の安全パトロール記録画面」>
- 主目的: <例: 「現場で立ったまま記録を残す」>
- 必須要素: <フィールド一覧、操作>

ルール:
- セマンティックトークンを参照する (--accent, --bg-surface, --fg-default ...)
- モバイルファースト CSS を書く (@media (min-width: ...) で拡張)
- すべてのインタラクティブ要素に min-height: 44px (建設は 48px)
- 入力フィールドは font-size: max(16px, var(--fs-callout))
- prefers-reduced-motion を尊重
- WCAG 2.2 AA を満たす配色とフォーカスリング
- 出力は単一HTMLまたはReactコンポーネントで、design-tokens.css を読み込む形
```

---

## 9. ファイル構成 (推奨)

```
your-app/
├── CLAUDE-UI-DESIGN.md        ← 本書 (UIデザインに関するAI向け指針)
├── CLAUDE.md                  ← (任意) 全体トップ。本書へのポインタを置く
│                                例: 「UIに関する作業は CLAUDE-UI-DESIGN.md を参照」
├── design-tokens.css          ← :root の CSS 変数 (Atlas DS から書き出し)
├── design-system/
│   ├── index.html             ← ライブ可視化サイト (オプション)
│   └── components/            ← 各コンポーネントの実装
└── src/
    ├── App.(tsx|swift|kt|dart)
    └── screens/
```

**`design-tokens.css` の冒頭は `:root { ... }` 一個だけにし、追記は禁止**。バリアントは `[data-variant="..."]` セレクタで上書き、テーマは `[data-theme="dark"]` で上書き。

---

## 10. 実装テンプレート (HTML / React / SwiftUI / Flutter)

### 10.1 HTML

```html
<!doctype html>
<html lang="ja">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
  <link rel="stylesheet" href="/design-tokens.css" />
</head>
<body data-variant="construction" data-theme="light">
  <header class="topbar">…</header>
  <main>…</main>
  <nav class="bottom-nav">…</nav>
</body>
</html>
```

### 10.2 React (CSS Modules / Tailwind 不問)

```jsx
export function PrimaryButton({ children, ...rest }) {
  return (
    <button
      className="btn btn-primary"
      style={{ minHeight: 'var(--touch-min)' }}
      {...rest}
    >
      {children}
    </button>
  );
}
```

### 10.3 SwiftUI (トークン名は同一に)

```swift
extension Color {
  static let atlasAccent     = Color("accent")
  static let atlasBgCanvas   = Color("bgCanvas")
  static let atlasFgDefault  = Color("fgDefault")
}
struct PrimaryButton: View {
  var title: String; var action: () -> Void
  var body: some View {
    Button(action: action) { Text(title).fontWeight(.semibold) }
      .frame(minHeight: 44).padding(.horizontal, 18)
      .background(Color.atlasAccent).foregroundColor(.white)
      .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}
```

### 10.4 Flutter

```dart
final atlasAccent = const Color(0xFF007AFF);
class PrimaryButton extends StatelessWidget {
  final String label; final VoidCallback onPressed;
  const PrimaryButton({super.key, required this.label, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: atlasAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
```

---

## 11. レビュー・チェックリスト (PR 前に AI が自己点検)

- [ ] 直接の HEX / 直接の `--brand-*` / `--neutral-*` を実装で参照していないか
- [ ] モバイルファーストで CSS を書いたか (`min-width` ベース)
- [ ] すべてのタップ要素が 44×44px (建設は 48×48) 以上か
- [ ] 入力フィールドのフォントが 16px 以上か
- [ ] `prefers-reduced-motion` を考慮したか
- [ ] フォーカスリングが見えるか (`:focus-visible`)
- [ ] ダークモードで破綻していないか (`[data-theme="dark"]`)
- [ ] バリアント切替で情報設計が変わっていないか (見た目だけ変える)
- [ ] WCAG 2.2 AA を満たすコントラストか (建設は AAA を目標)
- [ ] セーフエリアを考慮しているか (notch / home indicator)
- [ ] 日本語表示で行間 1.45 以上、長文の禁則処理が破綻しないか

---

## 12. 改訂履歴

- v0.1 (2026-04) — 初版。Universal / Construction / Real Estate の3バリアント、モバイル/タブレット/デスクトップ対応、Apple HIG ベースのトークン定義。
