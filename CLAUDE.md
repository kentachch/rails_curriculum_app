# rails_curriculum_app

Rails 8 + PostgreSQL の学習用アプリ。開発環境は Docker Compose（`compose.yml`）で動かす。

## 禁止事項（セキュリティ・安全）

- 環境変数・認証情報の値を出力しない。認証情報をハードコードしない
- `config/master.key`・`.env*`・`compose.override.yml` はコミットしない（ローカル専用）
- ステージはファイルを明示指定する（`git add -A` / `git add .` を使わない）
- `main` へ直接コミットしない
- DB に対して `DELETE` / `DROP` / `TRUNCATE` を許可なく実行しない
- push・PR 作成・Issue 作成など GitHub への書き込みは、指示されたときだけ実行する

## 開発環境

- 起動: `docker compose up`（初回や Dockerfile.dev 変更時は `--build`）／停止: `docker compose down`
- Rails コマンドはコンテナ内で実行する（`config/database.yml` の host が `db` のため、ホストからは DB に繋がらない）
  - メイン: `docker compose exec web bin/rails <cmd>`
  - worktree: `docker compose run --rm --no-deps web bin/rails <cmd>`

## テスト・検証

- テストは実装と並行して追加する
- テスト: `bin/wt-test [test/path/to_test.rb[:行番号]]`（メイン・worktree 共通。DB 準備込み）
- Lint: `docker compose exec web bin/rubocop`（worktree では `docker compose run --rm --no-deps web bin/rubocop`）
- CI（`.github/workflows/ci.yml`）は brakeman / bundler-audit / RuboCop / テスト / system テストを実行する
- migration を追加・実行したら `db/schema.rb` も必ずコミットする（CI の `db:test:prepare` が schema.rb を使う）

## Git / PR のルール

- ベースブランチ・PR のマージ先は `main`
- ブランチ名: `<type>/<issue番号>-<スラッグ>`（例 `feat/12-header-footer`）。Issue が無ければ `<type>/<スラッグ>`
  - type: `feat` 機能追加 / `fix` バグ修正 / `chore` 環境・設定・雑務 / `docs` ドキュメントのみ / `refactor` 挙動を変えない整理
  - スラッグは半角英数のケバブケース（英語）。日本語を入れない
- コミットメッセージ: `<type>: <日本語の要約>`（例 `feat: ヘッダーとフッターを設置`）
  - type: `feat` / `fix` / `docs` / `chore` / `style` / `refactor` / `test`
  - 1 コミット = 1 論理変更。無関係な変更を混ぜない
- PR 本文は [.github/PULL_REQUEST_TEMPLATE.md](.github/PULL_REQUEST_TEMPLATE.md)（関連する issue / 概要 / 背景 / 動作確認 / その他）に従う

## スキル・並列作業

スキルは `.claude/skills/`。Issue 起点の作業は次の流れで使う。

| やりたいこと | スキル |
| --- | --- |
| Issue を新規作成 | `/github-issue-create` |
| Issue の中身を読む・要件を要約 | `/ghi-reader <番号>` |
| 要件を壁打ちして詰める（実装しない） | `/issue-brainstorm <番号>` |
| 実装プランを docs/issues に作る | `/ghi-specifier <番号>` |
| Issue を通しで片付ける（読む → worktree → 実装 → commit → push → PR） | `/ghi-resolver <番号>` |
| ブランチ＋worktree を切って着手 | `/branch-create <番号>` |
| 複数 Issue を worktree で並行して進める | `/gwr` |
| コミット（RuboCop・テスト込み） | `/commit-changes` |
| push | `/push-branch` |
| PR を作る（テンプレ本文で） | `/pr-create` |
| main を最新にする | `/branch-latest-sync` |

- 複数タスクの並列作業は git worktree（gtr）で行う。詳細は [docs/worktree-development.md](docs/worktree-development.md)
- worktree は DB をメインと共有する（開発 DB は共有、テスト DB は `TEST_DB_SUFFIX` で worktree ごとに分離）
- worktree でのテストは `bin/wt-test`、人間へのブラウザ確認の依頼は `bin/wt-serve` を案内する（確認 URL と確認観点をセットで伝える）
- **AI 自身は `docker compose up -d` で常駐コンテナを立てない**
