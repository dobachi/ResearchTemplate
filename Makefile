# 調査報告書ビルドシステム Makefile
# Quarto + 共有パッケージ生成

# 設定
REPORT_TEMPLATE := reports/templates/report_template.qmd
OUTPUT_DIR := output
PACKAGE_DIR := $(OUTPUT_DIR)/package
PACKAGE_NAME := research-report-$(shell date +%Y%m%d)
REFS_DIR := sources/references
DIAGRAMS_DIR := sources/diagrams

# デフォルトターゲット
.PHONY: all
all: html

# ヘルプ表示
.PHONY: help
help:
	@echo "利用可能なターゲット:"
	@echo "  make html          - HTML版を生成"
	@echo "  make pdf           - PDF版を生成"
	@echo "  make epub          - EPUB版を生成"
	@echo "  make all-formats   - 全形式（HTML/PDF/EPUB）を生成"
	@echo "  make package       - 共有用パッケージを生成（全形式+ソース）"
	@echo "  make preview       - ライブプレビュー開始"
	@echo "  make clean         - 生成ファイルを削除"
	@echo "  make check-refs    - 参考文献の整合性チェック"

# HTML生成
.PHONY: html
html:
	@echo "📄 HTML版を生成中..."
	@echo "  - テンプレートをビルド..."
	quarto render $(REPORT_TEMPLATE) --to html
	@echo "  - プロジェクト全体をビルド（site_libs生成）..."
	quarto render --to html
	@echo "✅ HTML生成完了"

# PDF生成
.PHONY: pdf
pdf:
	@echo "📋 PDF版を生成中..."
	@echo "  - テンプレートをビルド..."
	quarto render $(REPORT_TEMPLATE) --to pdf
	@echo "  - プロジェクト全体をビルド..."
	quarto render --to pdf
	@echo "✅ PDF生成完了"

# EPUB生成
.PHONY: epub
epub:
	@echo "📚 EPUB版を生成中..."
	@echo "  - テンプレートをビルド..."
	quarto render $(REPORT_TEMPLATE) --to epub
	@echo "✅ EPUB生成完了"

# 全形式生成
.PHONY: all-formats
all-formats: html pdf epub
	@echo "✅ 全形式の生成が完了しました"

# 共有用パッケージ生成
.PHONY: package
package: all-formats
	@echo "📦 共有用パッケージを生成中..."
	@echo "  - プロジェクト全体のHTMLを再ビルド（site_libs保持）..."
	@quarto render --to html
	@mkdir -p $(PACKAGE_DIR)
	@mkdir -p $(PACKAGE_DIR)/formats
	@mkdir -p $(PACKAGE_DIR)/sources
	@mkdir -p $(PACKAGE_DIR)/references

	# 生成ファイルをコピー（関連ファイルも含む）
	@echo "  - 生成ファイルをコピー中..."
	@echo "    HTML/PDF/EPUBファイルをコピー..."
	@find reports/templates -maxdepth 1 -name "*.html" -exec cp {} $(PACKAGE_DIR)/formats/ \; 2>/dev/null || true
	@find reports/templates -maxdepth 1 -name "*.pdf" -exec cp {} $(PACKAGE_DIR)/formats/ \; 2>/dev/null || true
	@find reports/templates -maxdepth 1 -name "*.epub" -exec cp {} $(PACKAGE_DIR)/formats/ \; 2>/dev/null || true
	@if [ -d "$(OUTPUT_DIR)" ]; then \
		echo "    プロジェクト全体ビルドの出力もコピー..."; \
		cp -r $(OUTPUT_DIR)/*.html $(PACKAGE_DIR)/formats/ 2>/dev/null || true; \
		cp -r $(OUTPUT_DIR)/site_libs $(PACKAGE_DIR)/formats/ 2>/dev/null || true; \
		cp -r $(OUTPUT_DIR)/search.json $(PACKAGE_DIR)/formats/ 2>/dev/null || true; \
		find $(OUTPUT_DIR) -maxdepth 1 -name "*.pdf" -exec cp {} $(PACKAGE_DIR)/formats/ \; 2>/dev/null || true; \
		find $(OUTPUT_DIR) -maxdepth 1 -name "*.epub" -exec cp {} $(PACKAGE_DIR)/formats/ \; 2>/dev/null || true; \
	fi

	# ソースファイルをコピー
	@echo "  - ソースファイルをコピー中..."
	@cp -r reports/templates/*.qmd $(PACKAGE_DIR)/sources/ 2>/dev/null || true
	@cp -r reports/*.qmd $(PACKAGE_DIR)/sources/ 2>/dev/null || true

	# 参考文献をコピー
	@echo "  - 参考文献をコピー中..."
	@if [ -d "$(REFS_DIR)" ]; then \
		cp -r $(REFS_DIR)/*.bib $(PACKAGE_DIR)/references/ 2>/dev/null || true; \
		cp -r $(REFS_DIR)/*.json $(PACKAGE_DIR)/references/ 2>/dev/null || true; \
	fi

	# 図表ソースをコピー（オプション）
	@echo "  - 図表ソースをコピー中..."
	@if [ -d "$(DIAGRAMS_DIR)" ]; then \
		mkdir -p $(PACKAGE_DIR)/diagrams; \
		cp -r $(DIAGRAMS_DIR)/mermaid $(PACKAGE_DIR)/diagrams/ 2>/dev/null || true; \
		cp -r $(DIAGRAMS_DIR)/plantuml $(PACKAGE_DIR)/diagrams/ 2>/dev/null || true; \
		cp -r $(DIAGRAMS_DIR)/graphviz $(PACKAGE_DIR)/diagrams/ 2>/dev/null || true; \
		cp -r $(DIAGRAMS_DIR)/generated $(PACKAGE_DIR)/diagrams/ 2>/dev/null || true; \
	fi

	# READMEを生成
	@echo "  - READMEを生成中..."
	@echo "# 調査報告書パッケージ" > $(PACKAGE_DIR)/README.md
	@echo "" >> $(PACKAGE_DIR)/README.md
	@echo "生成日: $(shell date '+%Y-%m-%d %H:%M:%S')" >> $(PACKAGE_DIR)/README.md
	@echo "" >> $(PACKAGE_DIR)/README.md
	@echo "## 内容" >> $(PACKAGE_DIR)/README.md
	@echo "- \`formats/\`: 生成された報告書（HTML/PDF/EPUB）" >> $(PACKAGE_DIR)/README.md
	@echo "- \`sources/\`: ソースファイル（.qmd）" >> $(PACKAGE_DIR)/README.md
	@echo "- \`references/\`: 参考文献データベース" >> $(PACKAGE_DIR)/README.md
	@echo "- \`diagrams/\`: 図表ソース（Mermaid/PlantUML/Graphviz）" >> $(PACKAGE_DIR)/README.md
	@echo "" >> $(PACKAGE_DIR)/README.md
	@echo "## 利用方法" >> $(PACKAGE_DIR)/README.md
	@echo "1. 生成済みファイル: \`formats/\`内のファイルを参照" >> $(PACKAGE_DIR)/README.md
	@echo "   - **重要**: HTMLファイルを閲覧する場合は、\`formats/\`ディレクトリ全体を保持してください" >> $(PACKAGE_DIR)/README.md
	@echo "   - HTMLは\`site_libs/\`と\`search.json\`に依存しています" >> $(PACKAGE_DIR)/README.md
	@echo "2. 編集・再生成: \`sources/\`内の.qmdファイルを編集し、Quartoで再ビルド" >> $(PACKAGE_DIR)/README.md
	@echo "3. 図表の編集: \`diagrams/\`内のファイルを編集し、\`scripts/generate-diagrams.sh\`で再生成" >> $(PACKAGE_DIR)/README.md

	# パッケージを圧縮
	@echo "  - アーカイブを作成中..."
	@cd $(OUTPUT_DIR) && zip -r $(PACKAGE_NAME).zip package/
	@echo "✅ パッケージ生成完了: $(OUTPUT_DIR)/$(PACKAGE_NAME).zip"
	@echo "📊 パッケージ内容:"
	@cd $(OUTPUT_DIR) && unzip -l $(PACKAGE_NAME).zip | head -20

# ライブプレビュー
.PHONY: preview
preview:
	@echo "🔄 ライブプレビューを開始..."
	quarto preview $(REPORT_TEMPLATE)

# 参考文献チェック
.PHONY: check-refs
check-refs:
	@echo "🔍 参考文献の整合性をチェック中..."
	@if [ -f "scripts/check-references.sh" ]; then \
		bash scripts/check-references.sh $(REPORT_TEMPLATE) --check-urls; \
	else \
		echo "⚠️  チェックスクリプトが見つかりません"; \
	fi

# クリーンアップ
.PHONY: clean
clean:
	@echo "🧹 生成ファイルを削除中..."
	@rm -rf _site/
	@rm -rf $(OUTPUT_DIR)/
	@rm -rf .quarto/
	@echo "✅ クリーンアップ完了"

# 統合開発サーバー起動
.PHONY: dev
dev:
	@echo "🚀 統合開発サーバーを起動..."
	@if [ -f "scripts/dev-server.sh" ]; then \
		bash scripts/dev-server.sh; \
	else \
		echo "⚠️  開発サーバースクリプトが見つかりません。プレビューを開始します..."; \
		make preview; \
	fi

# ディレクトリ作成
$(OUTPUT_DIR):
	@mkdir -p $(OUTPUT_DIR)

$(PACKAGE_DIR):
	@mkdir -p $(PACKAGE_DIR)
