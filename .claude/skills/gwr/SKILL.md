---
name: gwr
description: git worktree（gtr）で複数の Issue・タスクを並行して進める。worktree の作成・移動・動作確認・片付けの手順。
---

# 実行手順

## 0. 目的

複数 Issue を同時進行するために、git worktree を使って作業ディレクトリを分離する。
詳細は [docs/worktree-development.md](../../../docs/worktree-development.md)。

## 1. 事前確認

- 対象 Issue 番号と概要を確認する。
- 既存の作業ブランチ・worktree がある場合は優先して使い、重複作成しない（`git gtr list`）。
- メインリポジトリの db コンテナが起動しているか確認する。worktree は DB をメインと共有するため、起動していなければユーザーに `docker compose up -d db`（メインで実行）を依頼する。

## 2. worktree 作成

ブランチ名・worktree の作り方は [branch-create](../branch-create/SKILL.md) が正本。要点だけ再掲する。

1. ブランチ名は `<type>/{issue_number}-{short_description}`（スラッグは半角英数のケバブケース）。
2. `git gtr new <branch>` で作成する（`git worktree add` は使わない）。
3. `cd "$(git gtr go <branch>)"` で移動する。

## 3. worktree での作業

| やりたいこと | コマンド（worktree 内で実行） |
| --- | --- |
| テスト | `bin/wt-test [test/path/to_test.rb[:行番号]]` |
| ブラウザで動作確認（人間に依頼） | `bin/wt-serve` → `http://localhost:<APP_PORT>`（Ctrl+C で片付けまで自動） |
| Rails コマンド | `docker compose run --rm --no-deps web bin/rails <cmd>` |
| 別セッションで Claude Code を起動 | `git gtr ai <branch>` |
| エディタで開く | `git gtr editor <branch>` |

- **AI 自身は `docker compose up -d` で常駐コンテナを立てない。** 動作確認は `bin/wt-serve` を人間に案内し、確認 URL と確認観点（どの画面で何が変わったか）をセットで伝える。
- 開発 DB はメインと共有している。worktree で `db:migrate` するとメイン側にも反映されるため、実行する前にユーザーに確認する（テスト DB は worktree ごとに分離されているので `bin/wt-test` は安全）。

## 4. 片付け

- PR がマージされたら `git gtr rm <branch>`（マージ済みの一括削除は `git gtr clean --merged`）。
- 削除前にその worktree のコンテナが残っていないか確認する: worktree 内で `docker compose ps`。

## 5. 失敗時の対処

- worktree 追加に失敗したら `git gtr list` で既存の worktree を確認する。
- gtr が入っていない場合は [docs/worktree-development.md](../../../docs/worktree-development.md) のインストール節を案内する。
- ポートが衝突する場合は worktree の `.env` の `APP_PORT` を変える。
