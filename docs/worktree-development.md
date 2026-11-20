# worktree（gtr）並列開発ガイド

git worktree を使うと、1つのリポジトリで複数のブランチを別フォルダに同時に開ける。
stash やブランチ切り替えなしで、Issue ごとに独立して作業（Claude Code のセッションも別々に）できる。

```
Practice/
├── rails_curriculum_app/                 ← メイン（db コンテナはここで起動する）
└── rails_curriculum_app-worktrees/
    ├── feat-12-header-footer/            ← worktree 1（http://localhost:3001）
    └── fix-15-login-error/               ← worktree 2（http://localhost:3002）
```

## インストール

worktree の操作には [gtr（git-worktree-runner）](https://github.com/coderabbitai/git-worktree-runner) を使う。

```sh
git clone https://github.com/coderabbitai/git-worktree-runner.git
cd git-worktree-runner
sudo ln -s "$(pwd)/bin/git-gtr" /usr/local/bin/git-gtr
git gtr version   # 確認
```

## 使い方

### 1. メインで DB を起動しておく

worktree はメインの db コンテナを共有する。

```sh
cd rails_curriculum_app
docker compose up -d db
```

### 2. worktree を作る

```sh
git gtr new feat/12-header-footer       # origin/main から作成（config/master.key も自動コピー）
cd "$(git gtr go feat/12-header-footer)"
```

### 3. 作業する

```sh
bin/wt-test                              # テスト（初回は環境を自動セットアップ）
bin/wt-test test/models/user_test.rb:42  # 1 テストだけ
bin/wt-serve                             # ブラウザ確認（Ctrl+C で片付けまで自動）
git gtr ai feat/12-header-footer         # この worktree で Claude Code を起動
```

初回の `bin/wt-test` / `bin/wt-serve` で次が自動で用意される:

- `compose.override.yml`（`compose.override.yml.example` のコピー・git 管理外）
- `.env` の `WORKTREE_INDEX`（他の worktree と被らない番号）と `APP_PORT`（3000 + 番号）
- gem / node_modules（worktree ごとの Docker volume に入る）

### 4. 片付ける

```sh
git gtr rm feat/12-header-footer         # PR マージ後
git gtr clean --merged                   # マージ済みをまとめて削除
```

## 仕組み

| 項目 | メイン | worktree |
| --- | --- | --- |
| web のポート | 3000 | 3000 + WORKTREE_INDEX |
| db コンテナ | 起動する | 起動しない（メインの db に `host.docker.internal` で接続） |
| 開発 DB | `myapp_development` | メインと**共有** |
| テスト DB | `myapp_test` | `myapp_test_wt<N>`（worktree ごとに分離） |
| コンテナ・volume | `rails_curriculum_app-*` | フォルダ名ごとの compose プロジェクトで別になる |

- **開発 DB は共有**なので、worktree で `db:migrate` するとメインにも反映される。画面確認のために migration が必要なときは影響を理解したうえで実行する。
- テスト DB は分離しているので、複数の worktree で同時に `bin/wt-test` しても壊し合わない。

## AI エージェント向けのルール

1. 実装したら `bin/wt-test <関連テスト>` で緑を確認する。
2. 人間に動作確認を頼むときは「この worktree で `bin/wt-serve` を実行すると http://localhost:<PORT> で確認できます」と、**確認 URL と確認観点（どの画面で何が変わったか）**をセットで伝える。
3. **AI 自身は `docker compose up -d`（常駐起動）をしない。** 起動しっぱなしのコンテナを残さない。
