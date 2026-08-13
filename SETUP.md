# 環境セットアップ

新しい環境でこのプロジェクトをビルドできるようにするまでの手順。

## 手順 1：ツールを揃える（マシンごとに一度）

**このプロジェクト固有のものは何も無い。** Quarto でドキュメントを書くための
一般的な環境なので、[ansible-miscs](https://github.com/dobachi/ansible-miscs) に集約してある。

```bash
git clone https://github.com/dobachi/ansible-miscs
cd ansible-miscs
ansible-playbook -i hosts playbooks/conf/linux/doc_authoring.yml \
  -e server=localhost --connection=local -K
```

Quarto・TeX Live（日本語込み）・Node.js・mermaid-cli・rsvg-convert・
Noto CJK フォントが入る。**個々のツールの版と入れ方は ansible-miscs 側が持っている**ので、
ここには書かない（書き写すと片方が古くなる）。

### 注意：TeX の導入経路を二重にしないこと

`quarto install tinytex` と `scripts/setup-quarto.sh --legacy` は、いずれも
上記とは別に TeX を入れる。**併用するとパッケージ探索とフォント解決が食い違い**、
「このマシンでは通るが別マシンで落ちる」状態を作る。どれか一つに寄せること。
日本語 PDF を出すなら ansible-miscs の経路が確実（`texlive-lang-japanese` と
Noto CJK の設定まで含む）。

### Debian/Ubuntu 以外

ansible-miscs の役割は Debian/Ubuntu 向け。macOS などでは

```bash
bash scripts/setup-quarto.sh
```

が従来どおり動く。ただし**日本語 TeX は含まれない**ので、PDF を出すなら別途入れること。

## 手順 2：確認する

```bash
make check-env
```

**このプロジェクトが実際に必要とするものだけ**を検査する。何が必要かは
リポジトリの中身から判定する（`_quarto.yml` が PDF を宣言しているか、
`Makefile` に `figures` があるか、など）ので、設定は要らない。
必須が揃っていれば終了コード 0。

## 手順 3：ビルドする

```bash
make report      # reports/ をビルド
make preview     # ライブプレビュー
```

---

## このプロジェクト固有の事情を書きたいとき

`scripts/env.conf` を作る（無ければ置かなくてよい）。`make check-env` が読む。

```sh
# 追加で要るコマンド
TOOLS=(
  "pandoc|required|変換に使う"
)
# git 管理外で、人手で配置する資材
ASSETS=(
  "_sources|required|無いと逐語引用の再照合ができない|社外秘・引用不可"
)
# python モジュール
PY_MODULES=("pptx|pptx を読む場合のみ")
```

**社内固有・非公開の事情はここ（各プロジェクトのリポジトリ）に書くこと。**
`scripts/check-env.sh` は公開テンプレート由来の同梱物で、派生先で編集しても
次の取り込みで失われる。

資材の置き場所を書くときは、**端末ごとに変わる絶対パスを書かない。**
共有ストレージの同期先はユーザ名やアカウントで変わるため、不変な末尾の階層だけを
手がかりにして探す形にする。認証が要る社内ストレージからの取得は自動化せず、
人が配置する前提にすること。
