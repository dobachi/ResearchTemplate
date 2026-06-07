# ResearchTemplate

[![GitHub Pages](https://img.shields.io/badge/docs-GitHub%20Pages-blue)](https://dobachi.github.io/ResearchTemplate/)
[![License](https://img.shields.io/badge/license-Apache%202.0-green)](LICENSE)

Quartoを使用した調査報告書作成のテンプレートリポジトリです。

> 📖 **詳細な使い方は[GitHub Pages](https://dobachi.github.io/ResearchTemplate/)をご覧ください**

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

### 2. 環境セットアップ（初回のみ）

#### 🚀 ワンライナーセットアップ（推奨）

すべての依存関係（Quarto、日本語LaTeX、submodule）を自動インストール：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/dobachi/ResearchTemplate/main/scripts/setup.sh)
```

または、既にクローン済みの場合：

```bash
scripts/setup.sh
```

**自動インストールされるもの:**
- ✅ Git submodule（AI指示書システム）
- ✅ Pandoc（必須）
- ✅ Quarto（対話的にインストール確認）
- ✅ 日本語LaTeX環境（TeX Live / MacTeX + Noto CJK フォント）
- ✅ その他の依存パッケージ

#### 手動セットアップ

最小限の設定のみ行う場合：

```bash
# Git submoduleの初期化のみ
git submodule update --init --recursive
```

### 3. 報告書を作成

```bash
# テンプレートをコピー
cp templates/report_template.qmd reports/my-research.qmd

# エディタで編集
vim reports/my-research.qmd
```

### 4. ビルド

```bash
# HTML + PDFでビルド
make report

# 成果物を確認
ls output/
```

### 5. 配布パッケージ作成（オプション）

```bash
# 報告書をZIPパッケージ化（成果物 + ソース）
make package

# dist/に生成されます
ls dist/
```

## 基本コマンド

```bash
make help              # ヘルプ表示
make report            # 報告書をビルド（HTML + PDF）→ output/
make examples          # サンプルをビルド（HTML + PDF）→ output/examples/
make package           # 配布パッケージ作成 → dist/
make preview           # ライブプレビュー
make clean             # ビルド成果物削除
```

## ドキュメント

- **[使い方ガイド](https://dobachi.github.io/ResearchTemplate/)** - 詳細な使用方法とワークフロー
- **[サンプル報告書](https://dobachi.github.io/ResearchTemplate/examples/technology-survey.html)** - Quarto機能の実例（使い方ガイドとしても機能）
- **[テンプレート一覧](templates/README.md)** - 利用可能なテンプレート

## 要件

### 必須

- [Quarto](https://quarto.org/docs/get-started/) 1.3以上
- Git
- Pandoc

### 推奨（PDF生成用）

- LuaLaTeX（日本語PDF対応）
- luatexja（日本語組版パッケージ）
- Noto Sans CJK JP フォント（日本語対応）

### 🚀 自動インストール（推奨）

すべての依存関係をワンライナーで自動インストール：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/dobachi/ResearchTemplate/main/scripts/setup.sh)
```

対応OS: Ubuntu/Debian、RedHat/Fedora、macOS

### 手動インストール例（Ubuntu/Debian）

```bash
# Quarto
wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.549/quarto-1.4.549-linux-amd64.deb
sudo dpkg -i quarto-1.4.549-linux-amd64.deb

# LaTeX + フォント（PDF生成用）
sudo apt-get install texlive-luatex texlive-lang-japanese fonts-noto-cjk
```

### TeX Live 2025へのアップデート

現在の環境がTeX Live 2023を使用している場合、より高度な日本語組版機能や最新の機能を利用するためにTeX Live 2025にアップデートできます。

> **注意**: 現在のTeX Live 2023環境でも日本語PDF生成は正常に動作します。アップデートは必須ではありません。

#### アップデート手順

<details>
<summary><strong>Ubuntu/Debian環境でのTeX Live 2025アップデート手順</strong></summary>

```bash
# 1. 現在のTeX Live環境をバックアップ（オプション）
which lualatex  # 現在のパスを確認
lualatex --version  # 現在のバージョンを確認

# 2. 既存のTeX Live環境を削除
sudo apt remove --purge texlive-* tex-common

# 3. 依存関係をクリーンアップ
sudo apt autoremove
sudo apt autoclean

# 4. TeX Live 2025のダウンロードとインストール
cd /tmp
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xzf install-tl-unx.tar.gz
cd install-tl-*

# 5. インストールの実行（管理者権限）
sudo ./install-tl
# インストーラーの指示に従って設定
# 推奨: full schemeを選択（容量が大きいが全機能利用可能）

# 6. パスの設定
echo 'export PATH=/usr/local/texlive/2025/bin/x86_64-linux:$PATH' >> ~/.bashrc
echo 'export MANPATH=/usr/local/texlive/2025/texmf-dist/doc/man:$MANPATH' >> ~/.bashrc
echo 'export INFOPATH=/usr/local/texlive/2025/texmf-dist/doc/info:$INFOPATH' >> ~/.bashrc
source ~/.bashrc

# 7. 日本語パッケージのインストール
sudo tlmgr install hyphen-japanese ptex-fonts japanese-otf luatexja

# 8. フォントのインストール（必要な場合）
sudo apt install fonts-noto-cjk

# 9. 動作確認
lualatex --version
tlmgr --version

# 10. Quartoでの動作確認
quarto render examples/technology-survey.qmd --to pdf
```

</details>

<details>
<summary><strong>macOS環境でのTeX Live 2025アップデート手順</strong></summary>

```bash
# 1. 現在のMacTeX環境を確認
which lualatex
lualatex --version

# 2. 新しいMacTeX 2025をダウンロード・インストール
# https://tug.org/mactex/ から最新版をダウンロード
# または Homebrew を使用:
brew install --cask mactex

# 3. 日本語フォントのインストール
brew install font-noto-sans-cjk-jp

# 4. パスの更新（必要な場合）
echo 'export PATH=/usr/local/texlive/2025/bin/x86_64-darwin:$PATH' >> ~/.zshrc
source ~/.zshrc

# 5. 動作確認
lualatex --version
quarto render examples/technology-survey.qmd --to pdf
```

</details>

#### アップデート後の確認

```bash
# バージョン確認
lualatex --version  # TeX Live 2025が表示されることを確認

# 日本語PDF生成テスト
quarto render examples/technology-survey.qmd --to pdf

# 生成されたPDFファイルを確認
ls -la output/examples/technology-survey.pdf
```

#### トラブルシューティング

**パッケージが見つからない場合:**
```bash
sudo tlmgr update --self
sudo tlmgr update --all
sudo tlmgr install <パッケージ名>
```

**権限エラーが発生する場合:**
```bash
sudo tlmgr option autobackup -- -1
sudo tlmgr option repository ctan
```

**フォントが見つからない場合:**
```bash
# システムフォントキャッシュの更新
fc-cache -fv
```

## プロジェクト構造

```
ResearchTemplate/
├── templates/          # テンプレートファイル
├── reports/            # ユーザーの報告書（あなたが作成）
├── examples/           # サンプル報告書
├── sources/            # リソース（参考文献、図表）
├── output/             # ビルド成果物
└── dist/               # 配布パッケージ
```

詳細は[使い方ガイド](https://dobachi.github.io/ResearchTemplate/)を参照してください。

## AI指示書システム（オプション）

このプロジェクトは[AI指示書システム](https://github.com/your-org/ai_instruction_kits)をgitサブモジュールとして任意で導入できます。

**対応AIツール**:
- Claude Code（推奨）
- Cursor
- その他のAIコーディングアシスタント

**セットアップ（任意）**:
```bash
# AI指示書システムをサブモジュールとして追加
git submodule add https://github.com/your-org/ai_instruction_kits.git instructions/ai_instruction_kits
git submodule update --init --recursive
```

**使い方**:
- AIツールは自動的に`CLAUDE.md`や`CURSOR.md`を読み込みます
- プロジェクト固有の指示は`instructions/PROJECT.md`を参照
- タスク管理・進捗追跡・worktree・ビルドはAIツールのネイティブ機能を利用

詳細は[CLAUDE.md](CLAUDE.md)を参照してください。

## ライセンス

[Apache-2.0](LICENSE)

## リンク

- [GitHub Pages](https://dobachi.github.io/ResearchTemplate/) - 詳細ドキュメント
- [Issues](https://github.com/dobachi/ResearchTemplate/issues) - バグ報告・機能要望
- [Quarto公式ドキュメント](https://quarto.org/docs/guide/) - Quartoの詳細
