---
name: branch-latest-sync
description: main ブランチを最新の状態に同期する。作業の起点を最新にしたいときに使う。
---

# 実行手順

## 0. 目的

作業の起点を最新の main に合わせる。

## 1. 手順

1. `git status -sb` で未コミットの変更が無いか確認する。あれば切り替えずにユーザーに確認する（勝手に stash しない）。
2. `git switch main`
3. `git pull --ff-only`

> worktree で作業する場合は `git gtr new` が origin/main を fetch して最新から切るので、本スキルの事前実行は不要。
