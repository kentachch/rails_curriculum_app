---
name: ghi-specifier
description: GitHub Issue を読んで、実装内容・影響範囲・受け入れ条件をまとめた実装プランを docs/issues に作成する（実装はしない）。
---

# 実行手順

## 0. 目的

GitHub Issue の内容を整理し、実装する内容・影響範囲・受け入れ条件をまとめたプランを `docs/issues/` に出力する。

## 1. スキル構成（参照先）

1. [ghi-reader](../ghi-reader/SKILL.md) — Issue の情報を取得する
2. [branch-create](../branch-create/SKILL.md) — ブランチ（worktree）を切る
3. [commit-changes](../commit-changes/SKILL.md) — コミットする
4. [push-branch](../push-branch/SKILL.md) — push する
5. [pr-create](../pr-create/SKILL.md) — PR を作成する

## 2. 実行順序

1. [ghi-reader](../ghi-reader/SKILL.md)
2. [branch-create](../branch-create/SKILL.md)（type は `docs`）
3. 関連する既存コード（routes / controllers / models / views / test）を読み、影響範囲を洗い出す
4. `docs/issues/` に実装プランを作成する
   - ファイル名: `${ISSUE_NUMBER}_${ISSUE_TITLE}_ISSUE_PLAN.md`
   - 構成: Issue 概要 / 目的・背景 / 受け入れ条件 / 影響範囲 / 実装タスク / 追加確認事項
5. [commit-changes](../commit-changes/SKILL.md)
6. push・PR 作成はユーザーの指示があれば [push-branch](../push-branch/SKILL.md) → [pr-create](../pr-create/SKILL.md)

## 3. 失敗時の対処

- Issue 情報が不足している場合は、追加確認事項に明記して作業を止める。
- 既存の `docs/issues/` と重複している場合は統合・追記する。
