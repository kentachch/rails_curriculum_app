# bin/wt-test と bin/wt-serve が共有するセットアップ関数（直接実行しない・source して使う）

# リポジトリルートへ移動
wt_cd_root() {
  cd "$(git rev-parse --show-toplevel)"
}

# メイン worktree のパス（= git worktree list の1行目）
wt_main_dir() {
  git worktree list --porcelain | awk '/^worktree /{print $2; exit}'
}

# メイン worktree で実行されているか
wt_is_main() {
  [ "$(pwd -P)" = "$(cd "$(wt_main_dir)" && pwd -P)" ]
}

# メインリポジトリの db コンテナが起動しているか（compose のラベルで特定する）
wt_require_db() {
  local main
  main="$(wt_main_dir)"
  if [ -z "$(docker ps -q \
      --filter "label=com.docker.compose.project.working_dir=${main}" \
      --filter "label=com.docker.compose.service=db")" ]; then
    echo "ERROR: メインリポジトリの db コンテナが起動していません。" >&2
    echo "       ${main} で docker compose up -d db を実行してください。" >&2
    exit 1
  fi
}

# 他の worktree が使っていない最小の WORKTREE_INDEX（1以上）を返す
# （worktree 一覧の並び順で採番すると、削除後に新しく作った worktree と番号が被るため）
wt_free_index() {
  local here used idx dir
  here="$(pwd -P)"
  used=""
  while read -r dir; do
    [ "$dir" = "$here" ] && continue
    if [ -f "$dir/.env" ]; then
      idx=$(grep '^WORKTREE_INDEX=' "$dir/.env" | tail -1 | cut -d= -f2)
      [ -n "$idx" ] && used="$used $idx "
    fi
  done < <(git worktree list --porcelain | awk '/^worktree /{print $2}')
  idx=1
  while [[ "$used" == *" $idx "* ]]; do idx=$((idx + 1)); done
  echo "$idx"
}

# worktree 用の compose.override.yml / .env を用意する
wt_ensure_env() {
  if [ ! -f compose.override.yml ] || ! cmp -s compose.override.yml.example compose.override.yml; then
    cp compose.override.yml.example compose.override.yml
    echo "==> compose.override.yml を生成しました"
  fi
  if [ ! -f .env ] || ! grep -q '^WORKTREE_INDEX=' .env; then
    local idx
    idx="$(wt_free_index)"
    { echo "WORKTREE_INDEX=$idx"; echo "APP_PORT=$((3000 + idx))"; } >> .env
    echo "==> .env に WORKTREE_INDEX=$idx / APP_PORT=$((3000 + idx)) を設定しました"
  fi
}

# .env から APP_PORT を読む（無ければ 3000）
wt_app_port() {
  local port
  port=$(grep '^APP_PORT=' .env 2>/dev/null | tail -1 | cut -d= -f2 || true)
  echo "${port:-3000}"
}
