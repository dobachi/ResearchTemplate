# ResearchTemplate Makefile
# 調査報告書作成プロジェクトのビルド自動化

.PHONY: help setup build build-pdf build-all check dev prod clean test

# デフォルトターゲット：ヘルプを表示
help:
	@echo "ResearchTemplate Makefile"
	@echo ""
	@echo "利用可能なコマンド:"
	@echo "  make setup       - 環境セットアップ（Quarto、日本語LaTeX等）"
	@echo "  make init        - Git submoduleの初期化"
	@echo "  make build       - HTMLレポート生成"
	@echo "  make build-pdf   - PDFレポート生成（日本語LaTeX対応）"
	@echo "  make build-all   - HTML/PDF両方を生成"
	@echo "  make check       - 引用整合性チェック"
	@echo "  make check-urls  - 引用整合性チェック + URL有効性確認"
	@echo "  make dev         - 開発モード（自動ビルド + サーバー + 監視）"
	@echo "  make prod        - 本番モード（完全チェック + ダッシュボード）"
	@echo "  make clean       - 生成ファイルを削除"
	@echo "  make test        - テストレポートでビルド確認"
	@echo ""
	@echo "変数:"
	@echo "  REPORT=reports/report.md  - ビルド対象のMarkdownファイル"
	@echo "  OUTPUT=report             - 出力ファイル名（拡張子なし）"
	@echo ""
	@echo "使用例:"
	@echo "  make build REPORT=reports/my-report.md"
	@echo "  make build-pdf OUTPUT=final-report"
	@echo "  make dev REPORT=reports/research.md"

# 変数定義
REPORT ?= reports/report.md
OUTPUT ?= $(basename $(notdir $(REPORT)))
SCRIPTS_DIR = scripts
OUTPUT_DIR = output

# 環境セットアップ
setup:
	@echo "環境セットアップを開始します..."
	@bash $(SCRIPTS_DIR)/setup.sh

# Git submoduleの初期化
init:
	@echo "Git submoduleを初期化しています..."
	@git submodule update --init --recursive
	@echo "Git submoduleの初期化が完了しました"

# HTMLレポート生成
build:
	@echo "HTMLレポートを生成中: $(REPORT) -> $(OUTPUT).html"
	@bash $(SCRIPTS_DIR)/build-report.sh html $(REPORT) $(OUTPUT)

# PDFレポート生成
build-pdf:
	@echo "PDFレポートを生成中: $(REPORT) -> $(OUTPUT).pdf"
	@bash $(SCRIPTS_DIR)/build-report.sh pdf $(REPORT) $(OUTPUT)

# HTML/PDF両方を生成
build-all: build build-pdf
	@echo "HTML/PDF両方の生成が完了しました"

# 引用整合性チェック
check:
	@echo "引用整合性チェックを実行中: $(REPORT)"
	@bash $(SCRIPTS_DIR)/check-references.sh $(REPORT)

# 引用整合性チェック + URL有効性確認
check-urls:
	@echo "引用整合性チェック（URL有効性確認含む）を実行中: $(REPORT)"
	@bash $(SCRIPTS_DIR)/check-references.sh $(REPORT) --check-urls

# 自動ビルド（単発）
auto:
	@echo "自動ビルドを実行中: $(REPORT)"
	@bash $(SCRIPTS_DIR)/auto-build.sh $(REPORT)

# 開発モード（継続的ビルド）
dev:
	@echo "開発モードを起動中..."
	@bash $(SCRIPTS_DIR)/continuous-build.sh --dev $(REPORT)

# 本番モード（継続的ビルド + 完全チェック）
prod:
	@echo "本番モードを起動中..."
	@bash $(SCRIPTS_DIR)/continuous-build.sh --prod $(REPORT)

# クイックモード（チェックなし）
quick:
	@echo "クイックモードを起動中..."
	@bash $(SCRIPTS_DIR)/continuous-build.sh --quick $(REPORT)

# 生成ファイルを削除
clean:
	@echo "生成ファイルを削除中..."
	@rm -rf $(OUTPUT_DIR)/html/*
	@rm -rf $(OUTPUT_DIR)/pdf/*
	@echo "クリーンアップが完了しました"

# テストレポートでビルド確認
test:
	@echo "テストビルドを実行中..."
	@if [ -f reports/samples/sample_ai_regulation.md ]; then \
		make build REPORT=reports/samples/sample_ai_regulation.md OUTPUT=test-report; \
		echo "テストビルドが成功しました"; \
	else \
		echo "テストレポートが見つかりません"; \
		exit 1; \
	fi

# バージョン情報表示
version:
	@echo "=== インストール済みツール ==="
	@echo -n "Git: "; git --version || echo "未インストール"
	@echo -n "Pandoc: "; pandoc --version | head -1 || echo "未インストール"
	@echo -n "Quarto: "; quarto --version || echo "未インストール"
	@echo -n "pdfLaTeX: "; pdflatex --version | head -1 || echo "未インストール"
	@echo -n "LuaLaTeX: "; lualatex --version | head -1 || echo "未インストール"
