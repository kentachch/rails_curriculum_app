---
name: ghi-resolver
description: GitHub Issue を通しで片付ける（Issue 読み込み → worktree 作成 → 実装 → テスト → コミット → push → PR）。Issue 番号を渡されて「この Issue を対応して」と頼まれたときに使う。
---

# 実行手順

## 0. 目的

Issue ごとに worktree を分けて安全に作業を進め、最終的に PR 作成まで完了させる。

## 1. スキル構成（参照先）

1. [ghi-reader](../ghi-reader/SKILL.md) — Issue の情報を取得する
2. [gwr](../gwr/SKILL.md) / [branch-create](../branch-create/SKILL.md) — worktree とブランチを作る
3. 実装（`docs/issues/` の実装プランがあれば従う）
4. [commit-changes](../commit-changes/SKILL.md) — lint・テストを通してコミットする
5. [push-branch](../push-branch/SKILL.md) — push する
6. [pr-create](../pr-create/SKILL.md) — PR を作成する

## 2. 実行順序

1. [ghi-reader](../ghi-reader/SKILL.md) で要件・受け入れ条件を把握する。要件があいまいなら実装に入らず、[issue-brainstorm](../issue-brainstorm/SKILL.md) か [ghi-specifier](../ghi-specifier/SKILL.md) を提案して止まる。
2. [branch-create](../branch-create/SKILL.md) で `<type>/<番号>-<slug>` の worktree を作り、以降の作業はその worktree 内で行う。
3. `docs/issues/${ISSUE_NUMBER}_*_ISSUE_PLAN.md` があれば実装方針として参照する。
4. 実装する。テストは実装と並行して追加する。
5. `bin/wt-test` で関連テスト → 全体の順に緑を確認する。
6. 画面に関わる変更なら、人間に `bin/wt-serve` での確認を依頼する（確認 URL と確認観点をセットで伝える）。
7. [commit-changes](../commit-changes/SKILL.md)
8. [push-branch](../push-branch/SKILL.md)
9. [pr-create](../pr-create/SKILL.md)（本文に `Closes #<番号>` を入れる）

## 3. 注意

- Issue の受け入れ条件を満たしたかを最後に1つずつ確認し、満たせなかったものは PR の「その他」に書く。
