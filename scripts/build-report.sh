#!/bin/bash

# 報告書ビルドスクリプト
# 使用法: ./build-report.sh [html|pdf] input.md [output_name]

set -e

# カラー出力の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# エラーハンドリング
error_exit() {
    echo -e "${RED}エラー: $1${NC}" >&2
    exit 1
}

# 使用法の表示
show_usage() {
    cat << EOF
使用法: $0 [html|pdf] input.md [output_name]

引数:
  html|pdf    : 出力形式
  input.md    : 入力Markdownファイル
  output_name : 出力ファイル名（オプション、拡張子なし）

例:
  $0 html reports/my-report.md
  $0 pdf reports/my-report.md final-report

必要なツール:
  HTML生成: pandoc
  PDF生成: pandoc, wkhtmltopdf または pdflatex

EOF
}

# 引数チェック
if [ $# -lt 2 ]; then
    show_usage
    exit 1
fi

FORMAT=$1
INPUT_FILE=$2
OUTPUT_NAME=${3:-$(basename "$INPUT_FILE" .md)}

# 入力ファイルの存在確認
if [ ! -f "$INPUT_FILE" ]; then
    error_exit "入力ファイル '$INPUT_FILE' が見つかりません"
fi

# プロジェクトルートディレクトリの取得
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT_DIR="$PROJECT_ROOT/output"
TEMPLATE_DIR="$PROJECT_ROOT/reports/templates"
STYLES_DIR="$TEMPLATE_DIR/styles"

# 出力ディレクトリの作成
mkdir -p "$OUTPUT_DIR/html" "$OUTPUT_DIR/pdf"

# pandocの存在確認
if ! command -v pandoc &> /dev/null; then
    error_exit "pandocがインストールされていません。以下のコマンドでインストールしてください:
    Ubuntu/Debian: sudo apt-get install pandoc
    macOS: brew install pandoc
    その他: https://pandoc.org/installing.html"
fi

# HTML生成関数
generate_html() {
    local input=$1
    local output="$OUTPUT_DIR/html/${OUTPUT_NAME}.html"

    echo -e "${GREEN}HTMLレポートを生成中...${NC}"

    # CSSファイルの確認
    local css_file="$STYLES_DIR/report-style.css"
    if [ ! -f "$css_file" ]; then
        echo -e "${YELLOW}警告: CSSファイル '$css_file' が見つかりません。デフォルトスタイルを使用します。${NC}"
        css_file=""
    fi

    # pandocコマンドの構築
    local pandoc_cmd="pandoc \"$input\" -o \"$output\""
    pandoc_cmd="$pandoc_cmd --standalone"
    pandoc_cmd="$pandoc_cmd --toc --toc-depth=3"
    pandoc_cmd="$pandoc_cmd --metadata title=\"\$(grep '^# ' \"$input\" | head -1 | sed 's/^# //')\""

    if [ -n "$css_file" ]; then
        # CSSファイルをHTMLに埋め込む
        pandoc_cmd="$pandoc_cmd --css=\"$css_file\" --embed-resources"
    fi

    pandoc_cmd="$pandoc_cmd --metadata lang=ja"
    pandoc_cmd="$pandoc_cmd --from=markdown+footnotes+definition_lists+yaml_metadata_block"
    pandoc_cmd="$pandoc_cmd --to=html5"

    # pandocの実行
    eval $pandoc_cmd

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ HTMLレポートが生成されました: $output${NC}"

        # ファイルサイズの表示
        local size=$(du -h "$output" | cut -f1)
        echo -e "  ファイルサイズ: $size"

        # ブラウザで開くか確認
        read -p "ブラウザで開きますか？ (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if command -v xdg-open &> /dev/null; then
                xdg-open "$output"
            elif command -v open &> /dev/null; then
                open "$output"
            else
                echo -e "${YELLOW}ブラウザを自動で開けませんでした。手動で開いてください。${NC}"
            fi
        fi
    else
        error_exit "HTML生成に失敗しました"
    fi
}

# PDF生成関数
generate_pdf() {
    local input=$1
    local output="$OUTPUT_DIR/pdf/${OUTPUT_NAME}.pdf"

    echo -e "${GREEN}PDFレポートを生成中...${NC}"

    # PDF生成エンジンの確認
    local pdf_engine=""
    if command -v pdflatex &> /dev/null; then
        pdf_engine="pdflatex"
        echo "  PDF生成エンジン: pdflatex"
    elif command -v xelatex &> /dev/null; then
        pdf_engine="xelatex"
        echo "  PDF生成エンジン: xelatex"
    elif command -v wkhtmltopdf &> /dev/null; then
        # まずHTMLを生成してからPDFに変換
        echo "  PDF生成エンジン: wkhtmltopdf (HTML経由)"
        local temp_html="$OUTPUT_DIR/html/${OUTPUT_NAME}_temp.html"
        generate_html "$input"

        wkhtmltopdf \
            --enable-local-file-access \
            --margin-top 20mm \
            --margin-bottom 20mm \
            --margin-left 20mm \
            --margin-right 20mm \
            --page-size A4 \
            --encoding utf-8 \
            "$OUTPUT_DIR/html/${OUTPUT_NAME}.html" \
            "$output"

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ PDFレポートが生成されました: $output${NC}"
            local size=$(du -h "$output" | cut -f1)
            echo -e "  ファイルサイズ: $size"
        else
            error_exit "PDF生成に失敗しました"
        fi
        return
    else
        error_exit "PDF生成エンジンがインストールされていません。
        以下のいずれかをインストールしてください:
        - pdflatex (texlive-latex-base)
        - xelatex (texlive-xetex)
        - wkhtmltopdf"
    fi

    # pandocによるPDF生成
    pandoc "$input" -o "$output" \
        --pdf-engine="$pdf_engine" \
        --toc --toc-depth=3 \
        --variable documentclass=ltjarticle \
        --variable classoption=a4paper \
        --variable geometry:margin=2cm \
        --variable mainfont="Noto Sans CJK JP" \
        --from=markdown+footnotes+definition_lists+yaml_metadata_block \
        --metadata lang=ja

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ PDFレポートが生成されました: $output${NC}"
        local size=$(du -h "$output" | cut -f1)
        echo -e "  ファイルサイズ: $size"
    else
        echo -e "${YELLOW}警告: LaTeXでのPDF生成に失敗しました。HTML経由での生成を試みます...${NC}"

        # HTML経由でのPDF生成を試みる
        if command -v wkhtmltopdf &> /dev/null; then
            generate_html "$input"
            wkhtmltopdf "$OUTPUT_DIR/html/${OUTPUT_NAME}.html" "$output"
        else
            error_exit "PDF生成に失敗しました"
        fi
    fi
}

# メイン処理
echo -e "${GREEN}=== 報告書ビルドスクリプト ===${NC}"
echo "入力ファイル: $INPUT_FILE"
echo "出力形式: $FORMAT"
echo "出力名: $OUTPUT_NAME"
echo ""

case $FORMAT in
    html|HTML)
        generate_html "$INPUT_FILE"
        ;;
    pdf|PDF)
        generate_pdf "$INPUT_FILE"
        ;;
    *)
        error_exit "不正な出力形式: $FORMAT (htmlまたはpdfを指定してください)"
        ;;
esac

echo -e "${GREEN}=== ビルド完了 ===${NC}"