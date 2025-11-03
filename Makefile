# 調査報告書ビルドシステム Makefile
# 設計原則：
# 1. templates/ = テンプレートファイル（ビルド対象外、コピー元）
# 2. reports/ = ユーザーの報告書（ビルド対象）
# 3. examples/ = サンプル報告書（ビルド対象、GitHub Pages表示）
# 4. output/ = ビルド成果物
# 5. dist/ = 配布用パッケージ

# 設定
OUTPUT_DIR := output
DIST_DIR := dist
PACKAGE_NAME := research-report-$(shell date +%Y%m%d)

# デフォルトターゲット
.PHONY: all
all: examples

# ヘルプ表示
.PHONY: help
help:
	@echo "利用可能なコマンド:"
	@echo ""
	@echo "【報告書作成】"
	@echo "  make report          - reports/内のユーザー報告書をビルド（HTML + PDF）"
	@echo "  make report-html     - reports/内のユーザー報告書をHTMLでビルド"
	@echo "  make report-pdf      - reports/内のユーザー報告書をPDFでビルド"
	@echo ""
	@echo "【サンプル・デモ】"
	@echo "  make examples        - examples/内のサンプル報告書をビルド（HTML + PDF）"
	@echo "  make examples-html   - examples/内のサンプル報告書をHTMLでビルド"
	@echo "  make examples-pdf    - examples/内のサンプル報告書をPDFでビルド"
	@echo ""
	@echo "【配布】"
	@echo "  make package         - 報告書を配布用パッケージ化（成果物 + ソース）"
	@echo ""
	@echo "【開発・プレビュー】"
	@echo "  make preview         - ライブプレビュー起動"
	@echo "  make clean           - ビルド成果物を削除"
	@echo ""
	@echo "【使い方】"
	@echo "  1. cp templates/report_template.qmd reports/my-research.qmd"
	@echo "  2. vim reports/my-research.qmd  # 報告書を編集"
	@echo "  3. make report                  # ビルド"
	@echo "  4. make package                 # 配布用ZIP作成"

# ===============================================
# ユーザー報告書のビルド
# ===============================================

.PHONY: report
report: report-html report-pdf
	@echo "✅ 報告書ビルド完了"
	@echo "📍 成果物: $(OUTPUT_DIR)/"
	@find $(OUTPUT_DIR) -maxdepth 1 \( -name "*.html" -o -name "*.pdf" \) -exec ls -lh {} \; 2>/dev/null || echo "  （ファイルなし）"

.PHONY: report-html
report-html:
	@echo "📄 reports/内の報告書をHTMLでビルド中..."
	@if [ -z "$$(find reports -name '*.qmd' -not -name 'README.md' 2>/dev/null)" ]; then \
		echo "⚠️  reports/内に.qmdファイルがありません"; \
		echo "   cp templates/report_template.qmd reports/my-research.qmd"; \
		exit 0; \
	fi
	@quarto render reports/ --to html --output-dir $(OUTPUT_DIR)
	@echo "✅ HTML生成完了"
	@echo "📍 HTML出力先: $(OUTPUT_DIR)/"

.PHONY: report-pdf
report-pdf:
	@echo "📋 reports/内の報告書をPDFでビルド中..."
	@if [ -z "$$(find reports -name '*.qmd' -not -name 'README.md' 2>/dev/null)" ]; then \
		echo "⚠️  reports/内に.qmdファイルがありません"; \
		exit 0; \
	fi
	@quarto render reports/ --to pdf --output-dir $(OUTPUT_DIR)
	@echo "✅ PDF生成完了"
	@echo "📍 PDF出力先: $(OUTPUT_DIR)/"

# ===============================================
# サンプル報告書のビルド（GitHub Pages表示用）
# ===============================================

.PHONY: examples
examples: examples-html examples-pdf
	@echo "✅ サンプルビルド完了"
	@echo "📍 成果物: $(OUTPUT_DIR)/examples/"
	@find $(OUTPUT_DIR)/examples -name "*.html" -o -name "*.pdf" 2>/dev/null | xargs ls -lh 2>/dev/null || echo "  （ファイルなし）"

.PHONY: examples-html
examples-html:
	@echo "📚 examples/内のサンプル報告書をHTMLでビルド中..."
	@mkdir -p $(OUTPUT_DIR)
	@quarto render examples/ --to html --output-dir $(OUTPUT_DIR)
	@echo "✅ サンプルHTML生成完了"
	@echo "📍 HTML出力先: $(OUTPUT_DIR)/examples/"
	@ls -lh $(OUTPUT_DIR)/examples/*.html 2>/dev/null || echo "  （HTMLファイルなし）"

.PHONY: examples-pdf
examples-pdf:
	@echo "📋 examples/内のサンプル報告書をPDFでビルド中..."
	@mkdir -p $(OUTPUT_DIR)
	@quarto render examples/ --to pdf --output-dir $(OUTPUT_DIR)
	@echo "✅ サンプルPDF生成完了"
	@echo "📍 PDF出力先: $(OUTPUT_DIR)/examples/"
	@ls -lh $(OUTPUT_DIR)/examples/*.pdf 2>/dev/null || echo "  （PDFファイルなし）"

# ===============================================
# 配布用パッケージ作成
# ===============================================

.PHONY: package
package:
	@echo "📦 報告書配布パッケージ作成中..."
	@
	@# ビルド成果物の存在確認
	@if [ ! -d "$(OUTPUT_DIR)" ] || [ -z "$$(ls -A $(OUTPUT_DIR) 2>/dev/null)" ]; then \
		echo "⚠️  成果物がありません。先に 'make report' を実行してください"; \
		exit 1; \
	fi
	@
	@mkdir -p $(DIST_DIR)/package/formats
	@mkdir -p $(DIST_DIR)/package/sources
	@mkdir -p $(DIST_DIR)/package/references
	@mkdir -p $(DIST_DIR)/package/diagrams
	@
	@# 成果物をコピー
	@echo "  - 成果物をコピー中..."
	@find $(OUTPUT_DIR) -maxdepth 1 -name '*.html' -exec cp {} $(DIST_DIR)/package/formats/ \; 2>/dev/null || true
	@find $(OUTPUT_DIR) -maxdepth 1 -name '*.pdf' -exec cp {} $(DIST_DIR)/package/formats/ \; 2>/dev/null || true
	@find $(OUTPUT_DIR) -maxdepth 1 -name '*.epub' -exec cp {} $(DIST_DIR)/package/formats/ \; 2>/dev/null || true
	@cp -r $(OUTPUT_DIR)/site_libs $(DIST_DIR)/package/formats/ 2>/dev/null || true
	@cp -r $(OUTPUT_DIR)/search.json $(DIST_DIR)/package/formats/ 2>/dev/null || true
	@
	@# 画像ファイルをコピー（*_files/ディレクトリ）
	@echo "  - 画像ファイルをコピー中..."
	@find $(OUTPUT_DIR) -maxdepth 1 -type d -name '*_files' -exec cp -r {} $(DIST_DIR)/package/formats/ \; 2>/dev/null || true
	@find $(OUTPUT_DIR) -maxdepth 1 \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.svg' -o -name '*.gif' \) -exec cp {} $(DIST_DIR)/package/formats/ \; 2>/dev/null || true
	@
	@# ソースをコピー
	@echo "  - ソースファイルをコピー中..."
	@find reports -name '*.qmd' -not -name 'README.md' -exec cp {} $(DIST_DIR)/package/sources/ \; 2>/dev/null || true
	@
	@# 参考文献をコピー
	@echo "  - 参考文献をコピー中..."
	@cp sources/references/*.bib $(DIST_DIR)/package/references/ 2>/dev/null || true
	@
	@# 図表ソースをコピー
	@echo "  - 図表ソースをコピー中..."
	@cp -r sources/diagrams/* $(DIST_DIR)/package/diagrams/ 2>/dev/null || true
	@
	@# READMEを生成
	@echo "  - READMEを生成中..."
	@echo "# 調査報告書パッケージ" > $(DIST_DIR)/package/README.md
	@echo "" >> $(DIST_DIR)/package/README.md
	@echo "生成日時: $$(date '+%Y-%m-%d %H:%M:%S')" >> $(DIST_DIR)/package/README.md
	@echo "" >> $(DIST_DIR)/package/README.md
	@echo "## 📁 内容" >> $(DIST_DIR)/package/README.md
	@echo "" >> $(DIST_DIR)/package/README.md
	@echo "- \`formats/\`: 閲覧用ファイル（HTML/PDF/EPUB）" >> $(DIST_DIR)/package/README.md
	@echo "- \`sources/\`: 報告書ソースファイル（.qmd）" >> $(DIST_DIR)/package/README.md
	@echo "- \`references/\`: 参考文献データベース（.bib）" >> $(DIST_DIR)/package/README.md
	@echo "- \`diagrams/\`: 図表ソースファイル（Mermaid/PlantUML等）" >> $(DIST_DIR)/package/README.md
	@echo "" >> $(DIST_DIR)/package/README.md
	@echo "## 📄 閲覧方法" >> $(DIST_DIR)/package/README.md
	@echo "" >> $(DIST_DIR)/package/README.md
	@echo "### HTML" >> $(DIST_DIR)/package/README.md
	@echo "- **重要**: HTMLを閲覧する場合は、\`formats/\`ディレクトリ全体を保持してください" >> $(DIST_DIR)/package/README.md
	@echo "- \`formats/\`内の\`.html\`ファイルをブラウザで開く" >> $(DIST_DIR)/package/README.md
	@echo "- \`site_libs/\`と\`search.json\`に依存しています" >> $(DIST_DIR)/package/README.md
	@echo "" >> $(DIST_DIR)/package/README.md
	@echo "### PDF" >> $(DIST_DIR)/package/README.md
	@echo "- \`formats/\`内の\`.pdf\`ファイルを開く" >> $(DIST_DIR)/package/README.md
	@echo "" >> $(DIST_DIR)/package/README.md
	@echo "## 🔧 再ビルド方法" >> $(DIST_DIR)/package/README.md
	@echo "" >> $(DIST_DIR)/package/README.md
	@echo "1. Quartoをインストール: https://quarto.org/docs/get-started/" >> $(DIST_DIR)/package/README.md
	@echo "2. 日本語PDF生成の場合、XeLaTeX + Noto Fontsが必要" >> $(DIST_DIR)/package/README.md
	@echo "3. ソースファイルをビルド:" >> $(DIST_DIR)/package/README.md
	@echo "" >> $(DIST_DIR)/package/README.md
	@echo "\`\`\`bash" >> $(DIST_DIR)/package/README.md
	@echo "quarto render sources/*.qmd --to html" >> $(DIST_DIR)/package/README.md
	@echo "\`\`\`" >> $(DIST_DIR)/package/README.md
	@echo "" >> $(DIST_DIR)/package/README.md
	@echo "## 📚 参考" >> $(DIST_DIR)/package/README.md
	@echo "" >> $(DIST_DIR)/package/README.md
	@echo "- [Quarto公式ドキュメント](https://quarto.org)" >> $(DIST_DIR)/package/README.md
	@echo "- [ResearchTemplate](https://github.com/dobachi/ResearchTemplate)" >> $(DIST_DIR)/package/README.md
	@
	@# ZIP圧縮
	@echo "  - アーカイブを作成中..."
	@cd $(DIST_DIR) && zip -r $(PACKAGE_NAME).zip package/ > /dev/null
	@rm -rf $(DIST_DIR)/package
	@
	@echo "✅ パッケージ生成完了: $(DIST_DIR)/$(PACKAGE_NAME).zip"
	@echo "📊 パッケージ情報:"
	@ls -lh $(DIST_DIR)/$(PACKAGE_NAME).zip
	@unzip -l $(DIST_DIR)/$(PACKAGE_NAME).zip | head -20

# ===============================================
# プレビュー・開発
# ===============================================

.PHONY: preview
preview:
	@echo "🔄 ライブプレビューを開始..."
	@echo "   reports/内の.qmdファイルを編集すると自動的に再ビルドされます"
	@quarto preview reports/

# ===============================================
# クリーンアップ
# ===============================================

.PHONY: clean
clean:
	@echo "🧹 ビルド成果物を削除中..."
	@rm -rf $(OUTPUT_DIR)/
	@rm -rf $(DIST_DIR)/
	@rm -rf .quarto/
	@rm -rf reports/*.html reports/*.pdf reports/*.epub reports/*_files/
	@rm -rf examples/*.html examples/*.pdf examples/*.epub examples/*_files/
	@echo "✅ クリーンアップ完了"

# ===============================================
# ディレクトリ作成
# ===============================================

$(OUTPUT_DIR):
	@mkdir -p $(OUTPUT_DIR)

$(DIST_DIR):
	@mkdir -p $(DIST_DIR)
