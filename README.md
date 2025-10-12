# ResearchTemplate

[![GitHub Pages](https://img.shields.io/badge/docs-GitHub%20Pages-blue)](https://dobachi.github.io/ResearchTemplate/)
[![License](https://img.shields.io/badge/license-Apache%202.0-green)](LICENSE)

Quartoを使用した調査報告書作成のテンプレートリポジトリです。

## 特徴

- 📝 **シンプル**: Markdown記法で簡単に記述
- 🎨 **高品質**: プロフェッショナルなデザイン
- 📚 **多様な出力**: HTML / PDF / EPUB対応
- 🔗 **参考文献管理**: BibTeX統合
- 🤖 **自動化**: GitHub Actions対応
- 📦 **配布機能**: 報告書をZIPパッケージ化

## クイックスタート

### 1. リポジトリの準備

```bash
# このリポジトリをfork/cloneまたはテンプレートから作成
git clone https://github.com/dobachi/ResearchTemplate.git
cd ResearchTemplate
```

### 2. 報告書を作成

```bash
# テンプレートをコピー
cp templates/report_template.qmd reports/my-research.qmd

# エディタで編集
vim reports/my-research.qmd
```

### 3. ビルド

```bash
# HTML + PDFでビルド
make report

# 成果物を確認
ls output/
```

### 4. 配布パッケージ作成

```bash
# 報告書をZIPパッケージ化（成果物 + ソース）
make package

# dist/に生成されます
ls dist/
```

## ディレクトリ構造

```
ResearchTemplate/
├── templates/          # テンプレートファイル
│   ├── report_template.qmd
│   └── styles/
├── reports/            # ユーザーの報告書（あなたが作成）
│   └── .gitkeep
├── examples/           # サンプル報告書
│   └── technology-survey.qmd
├── sources/            # リソース
│   ├── references/    # 参考文献（.bib）
│   └── diagrams/      # 図表ソース
├── output/             # ビルド成果物
├── dist/               # 配布パッケージ
└── Makefile            # ビルドツール
```

## 基本コマンド

```bash
make help              # ヘルプ表示
make report            # 報告書をビルド（HTML + PDF）
make package           # 配布パッケージ作成
make preview           # ライブプレビュー
make clean             # ビルド成果物削除
```

## ドキュメント

詳細な使い方は[GitHub Pages](https://dobachi.github.io/ResearchTemplate/)をご覧ください：

- [使い方ガイド](https://dobachi.github.io/ResearchTemplate/)
- [サンプル報告書](https://dobachi.github.io/ResearchTemplate/examples/technology-survey.html)
- [テンプレート一覧](templates/README.md)

## 要件

### 必須

- [Quarto](https://quarto.org/docs/get-started/) 1.3以上

### オプション（PDF生成用）

- XeLaTeX
- Noto Sans CJK JP フォント（日本語対応）

### インストール例（Ubuntu/Debian）

```bash
# Quarto
wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.549/quarto-1.4.549-linux-amd64.deb
sudo dpkg -i quarto-1.4.549-linux-amd64.deb

# LaTeX + フォント（PDF生成用）
sudo apt-get install texlive-xetex fonts-noto-cjk
```

## ワークフロー

### 開発フロー

```bash
# 1. テンプレートをコピー
cp templates/report_template.qmd reports/my-research.qmd

# 2. ライブプレビュー開始
make preview
# ブラウザで http://localhost:xxxx が自動で開きます

# 3. my-research.qmdを編集
# 保存すると自動的に再ビルド＆ブラウザ更新

# 4. 最終ビルド
make report
```

### 配布フロー

```bash
# 1. ビルド（まだの場合）
make report

# 2. パッケージ作成
make package

# 3. 配布
# dist/research-report-YYYYMMDD.zip を共有
```

## プロジェクト設計

### テンプレートと報告書の分離

- **templates/** = テンプレートファイル（リポジトリに含まれる、コピー元）
- **reports/** = ユーザーの報告書（git管理外、ローカル作業用）
- **examples/** = サンプル（GitHub Pages表示用）

### パッケージの内容

`make package`で作成されるZIPには以下が含まれます：

- **formats/** - 成果物（HTML/PDF/EPUB）
- **sources/** - 報告書ソース（.qmd）
- **references/** - 参考文献（.bib）
- **diagrams/** - 図表ソース
- **README.md** - パッケージの説明

**テンプレートやビルドツールは含まれません**（報告書配布のため）

## GitHub Actions

mainブランチへのpush時に自動実行：

- examples/とindex.qmdをビルド
- GitHub Pagesにデプロイ

ユーザーの報告書（reports/）は各自のforkでビルドします。

## 技術スタック

- **[Quarto](https://quarto.org)**: 科学技術出版システム
- **Markdown**: 軽量マークアップ言語
- **LaTeX**: 数式・PDF生成
- **BibTeX**: 参考文献管理
- **Make**: ビルド自動化
- **GitHub Actions**: CI/CD

## ライセンス

[Apache-2.0](LICENSE)

## 貢献

Issue、Pull Requestを歓迎します！

## サポート

- [Issues](https://github.com/dobachi/ResearchTemplate/issues)
- [GitHub Pages ドキュメント](https://dobachi.github.io/ResearchTemplate/)

## 関連リンク

- [Quarto公式ドキュメント](https://quarto.org/docs/guide/)
- [Markdown記法](https://www.markdownguide.org/)
- [BibTeX形式](https://www.bibtex.org/)
