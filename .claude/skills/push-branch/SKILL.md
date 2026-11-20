---
name: push-branch
description: 作業ブランチを origin に push する。
---

# 実行手順

## 0. 目的

リモートに変更内容を共有する。

## 1. 手順

1. 現在のブランチが `main` でないことを確認する（`git branch --show-current`）。main なら push しない。
2. `git push -u origin <type>/{issue_number}-{short_description}`（例 `feat/12-header-footer`）
   - rebase 後の2回目以降は `git push --force-with-lease`（`--force` は使わない）。
3. push は**ユーザーの明示指示があるときだけ**実行する。
