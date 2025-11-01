# 調査報告書テンプレート

AI支援による調査報告書作成のためのGitHubテンプレートリポジトリです。

## 特徴

- 🤖 AI指示書システムによる調査・報告書作成支援
- 📊 構造化された報告書テンプレート（エグゼクティブサマリ、参考文献を含む）
- 🔍 信頼性の高い情報源の活用と適切な引用管理
- 📝 HTML/PDF形式での報告書出力対応（日本語LaTeX対応）
- 🎯 IT技術、法制度、ソフトウェアプロジェクト等の調査に最適化
- 🚀 ワンライナーセットアップで依存関係を自動インストール

## 必須・推奨ツール

### 必須ツール
- **Git** - バージョン管理
- **Pandoc** - ドキュメント変換エンジン

### 推奨ツール（自動セットアップ可能）
- **Quarto** - 高度なドキュメント生成（オプション）
- **日本語LaTeX環境** - 高品質な日本語PDF生成
  - TeX Live (Linux)
  - MacTeX (macOS)
  - 日本語フォント (Noto CJK)

### オプションツール
- **GitHub CLI (gh)** - プロジェクト自動作成に必要
- **wkhtmltopdf** - HTML経由のPDF生成（LaTeX不使用時）

**📦 全ての依存関係は `scripts/setup.sh` で自動インストール可能です**

## クイックスタート

### 🚀 ワンライナーで新しいプロジェクトを作成（推奨）

以下のワンライナーを実行すると、GitHubプライベートリポジトリ付きの新しいプロジェクトが自動作成されます：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/dobachi/ResearchTemplate/main/scripts/create-project.sh) your-project-name
```

**前提条件:**
- [GitHub CLI (gh)](https://cli.github.com/) がインストール済み
- GitHub CLI が認証済み (`gh auth login`)

**このワンライナーが実行する処理:**
1. ✅ 新しいプロジェクトディレクトリを作成
2. ✅ このテンプレートを複製
3. ✅ GitHubにプライベートリポジトリを作成
4. ✅ 新しいリポジトリにプッシュ
5. ✅ AI指示書システム（サブモジュール）を初期化
6. ✅ プロジェクト設定を自動更新

### 手動での作成方法

#### 1. テンプレートからリポジトリを作成

GitHubで「Use this template」ボタンをクリックして、新しいリポジトリを作成します。

#### 2. 初期設定

##### 🚀 自動セットアップ（推奨）

```bash
# リポジトリをクローン
git clone https://github.com/あなたのユーザー名/あなたのリポジトリ名.git
cd あなたのリポジトリ名

# すべての依存関係を自動インストール
make setup
```

**`make setup` が実行する処理:**
- ✅ Git submoduleの初期化
- ✅ Pandocのインストール
- ✅ Quartoのインストール（オプション）
- ✅ 日本語LaTeX環境の構築（オプション）
- ✅ その他の依存パッケージ

##### 最小限のセットアップ

Git submoduleのみ初期化する場合：

```bash
# リポジトリをクローン
git clone https://github.com/あなたのユーザー名/あなたのリポジトリ名.git
cd あなたのリポジトリ名

# AI指示書システムの初期化
make init
```

### 調査開始

プロジェクト作成後、以下のように調査を開始できます：

```bash
# プロジェクトディレクトリに移動
cd your-project-name

# 調査テーマの設定（次のセクション参照）
# その後、AI支援による調査開始（さらに次のセクション参照）
```

### 3. 調査テーマの設定

`reports/config.yaml`で調査テーマと範囲を設定：

```yaml
title: "調査報告書タイトル"
topic: "調査テーマ"
scope:
  - IT技術
  - 法制度
  - その他
```

### 4. AI支援による調査開始

```bash
# チェックポイント管理で進捗を追跡
scripts/checkpoint.sh start "調査タスク名" 5

# AI指示書を使用して調査を開始
# Claude/Cursor/Gemini等のAIツールで以下を実行：
# 1. instructions/PROJECT.mdを読み込み
# 2. AI指示書システムのROOT_INSTRUCTIONに従って作業
```

## ディレクトリ構造

```
.
├── README.md                    # このファイル
├── instructions/                # AI指示書と設定
│   ├── PROJECT.md              # プロジェクト固有の設定
│   └── ai_instruction_kits/    # AI指示書システム（サブモジュール）
├── reports/                     # 報告書の保管場所
│   ├── templates/              # 報告書テンプレート
│   │   ├── report_template.md  # Markdownテンプレート
│   │   └── styles/            # HTMLスタイルシート
│   ├── samples/               # サンプル報告書
│   └── config.yaml           # 報告書設定
├── sources/                    # 調査資料の保管場所
│   ├── references/            # 参考文献
│   ├── data/                  # データファイル
│   └── notes/                 # 調査メモ
├── scripts/                    # ユーティリティスクリプト
│   ├── setup.sh               # 環境セットアップ（ワンライナー対応）
│   ├── checkpoint.sh          # 進捗管理
│   ├── commit.sh             # クリーンなコミット
│   ├── build-report.sh       # 報告書ビルド
│   ├── auto-build.sh         # 自動ビルド
│   ├── continuous-build.sh   # 継続的ビルド
│   ├── watch-files.sh        # ファイル監視
│   ├── check-references.sh   # 引用整合性チェック
│   └── worktree-manager.sh   # Git worktree管理
└── output/                    # 生成された報告書（gitignore対象）
    ├── html/
    └── pdf/
```

## 報告書作成のベストプラクティス

### 1. 信頼性の高い情報源の活用

- 🏛️ 行政機関の公式発表
- 📚 査読付き学術論文
- 📋 国際標準・業界標準
- 🏢 企業の公式技術文書

### 2. 適切な引用と参照

- すべての事実に引用元を明記
- 参考文献リストとの相互参照を確保
- 引用形式の一貫性を保つ

### 3. 多角的な視点

- 複数の見解や理論を検討
- バランスの取れた分析
- 明確な考察と事実の区別

### 4. 報告書の構成

必須項目：
- エグゼクティブサマリ
- 目次
- 本文（背景、調査方法、結果、考察）
- 結論
- 参考文献一覧

## 報告書のビルドとエクスポート

### クイックスタート（Make経由）

すべてのビルドコマンドは`make`経由で実行できます：

```bash
# ヘルプを表示
make help

# HTMLレポート生成
make build

# PDFレポート生成（日本語LaTeX対応）
make build-pdf

# HTML/PDF両方を生成
make build-all

# 引用整合性チェック
make check

# 開発モード（自動ビルド + 監視）
make dev

# 本番モード（完全チェック）
make prod
```

### カスタムレポートのビルド

デフォルト以外のレポートをビルドする場合：

```bash
# カスタムレポートをHTMLビルド
make build REPORT=reports/my-research.md

# カスタムレポートをPDFビルド
make build-pdf REPORT=reports/my-research.md OUTPUT=final-report

# 開発モード（カスタムレポート）
make dev REPORT=reports/my-research.md
```

### スクリプトを直接使用する場合

```bash
# HTMLレポート生成
scripts/build-report.sh html reports/your-report.md

# PDFレポート生成
scripts/build-report.sh pdf reports/your-report.md

# 継続的ビルド（開発モード）
scripts/continuous-build.sh --dev reports/report.md
```

詳細は`instructions/PROJECT.md`の「ビルドコマンド」セクション、または`make help`を参照してください。

## AI指示書の活用

このプロジェクトには調査・報告書作成に特化したAI指示書が含まれています：

- `research_analyst.md` - 調査分析の専門指示書
- `report_writer.md` - 報告書執筆の専門指示書
- `fact_checker.md` - ファクトチェックと引用管理

詳細は`instructions/PROJECT.md`を参照してください。

## コントリビューション

プルリクエストを歓迎します。大きな変更の場合は、まずissueを開いて変更内容について議論してください。

## ライセンス

[Apache-2.0](LICENSE)

## サポート

問題が発生した場合は、[Issues](https://github.com/ユーザー名/リポジトリ名/issues)でお知らせください。