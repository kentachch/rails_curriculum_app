---
name: github-issue-create
description: 重複を確認したうえで、ラベル・担当つきの GitHub Issue を gh CLI で新規作成する。
---

# 実行手順

## 0. 目的

新規 Issue を作成し、重複や形式の不備を防ぐ。

## 1. 事前確認

- 対象リポジトリを確認する（`gh repo view --json nameWithOwner -q .nameWithOwner`）。
- 類似 Issue がないか検索する（`gh issue list --state all --search "<keyword>"`）。重複があれば新規作成せず、既存 Issue への追記を提案する。

## 2. Issue 作成

1. タイトルと本文を整理する。壁打ちの成果があれば [issue-brainstorm](../issue-brainstorm/SKILL.md) のフォーマットを使う。最低限、次の見出しを入れる:

   ```markdown
   ## 課題 / 背景
   ## 目的（この Issue で達成したいこと）
   ## 受け入れ条件（Done の定義）
   ```

2. 作成内容（タイトル・本文・ラベル・担当）をユーザーに提示し、了承を得てから作成する。
3. 本文をファイルに書き出して作成する:

   ```sh
   gh issue create --title "..." --body-file <path> --label "<ラベル>" --assignee "@me"
   ```

   - 使えるラベルは `gh label list` で確認する。存在しないラベルを付けると失敗するので、新しく必要なら `gh label create` するかユーザーに確認する。
4. 作成した Issue の URL を伝える。

## 3. 後付けの変更

```sh
gh issue edit <番号> --add-label "..." --add-assignee <user>
```
