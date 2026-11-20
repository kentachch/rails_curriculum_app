---
name: pr-create
description: リポジトリの PR テンプレ（関連する issue / 概要 / 背景 / 動作確認 / その他）で PR 本文を作成する。指示があれば gh pr create まで行う。
---

# 実行手順

## 0. 目的

レビュー可能な形で変更内容を提出する。

## 1. 手順

1. ベースブランチ（`main`）と、PR に含まれるコミット範囲・差分規模を確認する。
   - `git log --oneline main..HEAD` / `git diff --stat main...HEAD`
   - 複数機能が混在していないか（＝PR スコープが妥当か）を確認し、混在するなら分割の要否をユーザーに確認する。
2. 同じブランチの PR が既にあるか確認する: `gh pr list --head <branch> --state open`
3. PR 本文を下記テンプレ（[.github/PULL_REQUEST_TEMPLATE.md](../../../.github/PULL_REQUEST_TEMPLATE.md) と同じ構成）で作成する。
4. 「動作確認」欄は**実際に叩いたコマンドと結果**を書く（例: `bin/wt-test` の件数・ブラウザ確認の手順と結果）。憶測で「動くはず」と書かない。未実施の項目は未実施と書く。
5. 提出方法:
   - ユーザーが **PR の作成まで指示している**場合: 未 push なら [push-branch](../push-branch/SKILL.md) を行い、本文をファイルに書き出して
     `gh pr create --base main --title "<type>: <日本語の要約>" --body-file <path>` で作成する。作成した PR の URL を伝える。
   - **下書きだけ求められた**場合・指示があいまいな場合: 本文を **md コピペ可能な形（コードブロック）で出力**して手渡す（push / PR 作成はしない）。
   - 関連 Issue がある場合は本文に `Closes #<番号>` を入れる（マージ時に Issue が自動で閉じる）。

## 2. PR 本文テンプレ

```markdown
## 関連する issue

## 概要

## 背景

## 動作確認

## その他
```

## 3. 注意

- CI（`.github/workflows/ci.yml`）では brakeman / bundler-audit / RuboCop / テスト / system テストが走る。PR 作成後に `gh pr checks` で結果を確認できる。
