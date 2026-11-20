---
name: commit-changes
description: 差分を確認し、Docker 内で RuboCop とテストを通したうえで、関心事ごとに安全にコミットする。
---

# 実行手順

## 0. 目的

変更内容を確認し、lint／テストを通したうえで、安全に履歴として確定する。

## 1. 手順

1. 変更差分を確認する。
   - `git status -sb`
   - `git diff` / `git diff --stat`
2. **コミットの切り分けを判断する。** 変更が複数の関心事にまたがるなら、関心事ごとにコミットを分ける。判定は次の3層で:
   - **完結性（主判定）**: 各コミットが単体で成立するか。①その時点でテストが緑を保つ ②後で単体で revert できる ③メッセージが「〜と〜」でつながず1文で書ける（つなぎたくなったら分割サイン）。
   - **混ぜない境界**: 機能実装 ↔ docs / スキーマ変更（migration） ↔ それを使うロジック / リファクタ（振る舞い不変） ↔ 機能追加 / アプリ本体 ↔ 設定・CI。
   - **レビュアー視点**: 1コミットを「これは○○の変更」と一言で言える単位に。ただし1つの関心事を無意味に割らない。
3. **Lint（RuboCop・Docker 内）**
   - メイン: `docker compose exec web bin/rubocop <変更ファイル>`
   - worktree: `docker compose run --rm --no-deps web bin/rubocop <変更ファイル>`
   - 基準は「**自分の変更で新規 offense を増やさない**」こと（安全な自動修正は `-a`、`-A` は影響を確認のうえ）。
4. **テスト（Docker 内）**
   - 変更に対応するテストを追加・実行する: `bin/wt-test <対象テスト>`（メイン・worktree どちらでも同じ）
   - 影響範囲の回帰も回す（例: `bin/wt-test` で全体）。
   - Docker が起動しておらずテストできない場合は、コミットは進めてよいが「未実行」であることを最終報告に必ず書く。
5. **ステージ & コミット（関心事ごとに繰り返す）**
   - 関心事1つ分のファイルだけを**明示指定**してステージする（`git add <path> <path> …`）。`git add -A` / `git add .` は使わない。1ファイル内に複数の関心事が混ざる場合は `git add -p` で分ける。
   - `<type>: <日本語の要約>` 形式のメッセージでコミットする（type は CLAUDE.md 参照）。
   - `git show --stat HEAD` で意図したファイルだけが入ったか確認する。
   - 残りの関心事について繰り返す。

## 2. 絶対に守るルール

- **`config/master.key`・`.env*`・`compose.override.yml` はコミットしない**（ローカル専用）。ステージ後に
  `git diff --cached --name-only | grep -E 'master\.key|\.env|compose\.override\.yml$'` が空であることを確認する。
- **明示ステージング**を徹底する。作業ツリーに自分と無関係な変更が混ざっている前提で、自分の変更ファイルだけを add する。
- **`main` へ直接コミットしない**。main にいる場合はブランチを切ってから（[branch-create](../branch-create/SKILL.md)）。
- migration を追加・実行したら `db/schema.rb` も同じコミットに含める（CI の `db:test:prepare` が schema.rb を使う）。
