---
name: branch-create
description: Issue（または作業内容）ごとに作業ブランチと worktree を gtr で作成する。
---

# 実行手順

## 0. 目的

Issue ごとに作業ブランチと worktree を作成して、作業ディレクトリを分離する。

## 1. 手順

1. ブランチ名を決める。形式は `<type>/{issue_number}-{short_description}`（例 `feat/12-header-footer`）。
   - Issue が無い作業は `<type>/{short_description}`（例 `chore/ci-schema`）。
   - **スラッグは半角英数のケバブケース（英語）にする。** Issue タイトルが日本語でも英訳して付ける。日本語をそのまま入れない（GitHub が "hidden characters" 警告を出し、ツール連携でも不整合になる）。
   - type は `feat` / `fix` / `chore` / `docs` / `refactor`（正本: CLAUDE.md の「Git / PR のルール」）。
2. worktree を作成する。**`git worktree add` ではなく gtr を使う。**
   - `git gtr new <type>/<ID>-<short_description>`
   - gtr は origin/main を fetch して最新から切り、`.gtrconfig` の `[copy]` に従って `config/master.key` をコピーする。
3. 作成したディレクトリに移動する。
   - `cd "$(git gtr go <type>/<ID>-<short_description>)"`
   - worktree は `<リポジトリの兄弟>/rails_curriculum_app-worktrees/<slug>` に作られる（ブランチ名の `/` は `-` になるが、`git gtr go` に渡すのはブランチ名のほう）。
4. worktree の Docker 環境（compose.override.yml / .env）は `bin/wt-test` / `bin/wt-serve` の初回実行時に自動生成されるので、ここでは何もしなくてよい。

## 2. 失敗時の対処

- gtr が入っていない（`git: 'gtr' is not a git command.`）場合は [docs/worktree-development.md](../../../docs/worktree-development.md) のインストール節を案内する。
- worktree 追加に失敗したら既存の worktree 一覧を確認する: `git gtr list`
- 同名ブランチが既にある場合は、そのブランチを使うかユーザーに確認する（既存ブランチからは `git gtr new <branch> --from <branch>`）。
