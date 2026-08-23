#!/bin/sh
# Verify the git-wt integration by observable behavior:
#   1. tracked .gitconfig places worktrees under <repo>/.worktrees
#   2. the `git` wrapper installed by `git wt --init` still passes every
#      non-`wt` subcommand through to the real binary (and `g` still works)
#   3. `git wt <branch>` creates the worktree and cd's into it
# Nothing outside the temporary fixture repository is touched.
set -eu

REPO_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
TRACKED_GITCONFIG="$REPO_ROOT/.gitconfig"
EXPECTED_BASEDIR=".worktrees"

fail() {
  echo "[fail] $1" >&2
  exit 1
}

actual_basedir="$(git config --file "$TRACKED_GITCONFIG" --get wt.basedir || true)"
if [ "$actual_basedir" != "$EXPECTED_BASEDIR" ]; then
  fail "tracked .gitconfig wt.basedir is '$actual_basedir', expected '$EXPECTED_BASEDIR'"
fi
echo "[ok] tracked .gitconfig sets wt.basedir = $EXPECTED_BASEDIR"

if ! command -v git-wt > /dev/null 2>&1; then
  echo "[skip] git-wt is not installed; shell behavior not verified" >&2
  echo "       install it with: mise install 'aqua:k1LoW/git-wt'" >&2
  exit 0
fi

TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-git-wt.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT HUP INT TERM

FIXTURE="$TEST_ROOT/repo"
# Resolve symlinks (macOS /var -> /private/var) so path comparisons hold.
mkdir -p "$FIXTURE"
FIXTURE="$(CDPATH= cd -- "$FIXTURE" && pwd -P)"

# Exercise the tracked global config, and only that one.
GIT_CONFIG_GLOBAL="$TRACKED_GITCONFIG"
GIT_CONFIG_SYSTEM=/dev/null
export GIT_CONFIG_GLOBAL GIT_CONFIG_SYSTEM

git init -q -b main "$FIXTURE"
echo seed > "$FIXTURE/seed.txt"
git -C "$FIXTURE" add seed.txt
git -C "$FIXTURE" -c commit.gpgsign=false commit -qm "seed"

cat > "$TEST_ROOT/probe.fish" << 'PROBE_FISH'
set -l repo_root $argv[1]
set -l fixture $argv[2]

source $repo_root/.config/fish/conf.d/03_tools.fish
source $repo_root/.config/fish/conf.d/98_aliases.fish

if not functions -q git
    echo "[fail] fish: git wrapper function was not installed" >&2
    exit 1
end

cd $fixture

set -l branch (git rev-parse --abbrev-ref HEAD)
if test "$branch" != main
    echo "[fail] fish: plain git no longer passes through (got '$branch')" >&2
    exit 1
end

set -l aliased (g rev-parse --abbrev-ref HEAD)
if test "$aliased" != main
    echo "[fail] fish: 'g' alias no longer reaches git (got '$aliased')" >&2
    exit 1
end

git wt verify/fish > /dev/null
set -l here (pwd -P)
if test "$here" != "$fixture/.worktrees/verify/fish"
    echo "[fail] fish: expected cwd $fixture/.worktrees/verify/fish, got $here" >&2
    exit 1
end

echo "[ok] fish: git wt switches worktrees and plain git still passes through"
PROBE_FISH

cat > "$TEST_ROOT/probe.zsh" << 'PROBE_ZSH'
repo_root=$1
fixture=$2

source "$repo_root/.config/zsh/tools.zsh"
source "$repo_root/.config/zsh/aliases.zsh"

if [[ "$(whence -w git)" != *function* ]]; then
  echo "[fail] zsh: git wrapper function was not installed" >&2
  exit 1
fi

cd "$fixture"

branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$branch" != main ]]; then
  echo "[fail] zsh: plain git no longer passes through (got '$branch')" >&2
  exit 1
fi

# eval so the alias defined above is expanded at parse time
aliased=$(eval 'g rev-parse --abbrev-ref HEAD')
if [[ "$aliased" != main ]]; then
  echo "[fail] zsh: 'g' alias no longer reaches git (got '$aliased')" >&2
  exit 1
fi

git wt verify/zsh > /dev/null
here=$(pwd -P)
if [[ "$here" != "$fixture/.worktrees/verify/zsh" ]]; then
  echo "[fail] zsh: expected cwd $fixture/.worktrees/verify/zsh, got $here" >&2
  exit 1
fi

echo "[ok] zsh: git wt switches worktrees and plain git still passes through"
PROBE_ZSH

# --no-config / -f keep the ambient user config out of the probe, so the
# assertions only reflect what this repository's files do.
if command -v fish > /dev/null 2>&1; then
  fish --no-config -i "$TEST_ROOT/probe.fish" "$REPO_ROOT" "$FIXTURE"
else
  echo "[skip] fish not found" >&2
fi

if command -v zsh > /dev/null 2>&1; then
  # `zsh -i` without a tty warns about zle; keep real diagnostics, drop that noise.
  zsh_status=0
  zsh -f -i "$TEST_ROOT/probe.zsh" "$REPO_ROOT" "$FIXTURE" 2> "$TEST_ROOT/zsh.err" || zsh_status=$?
  grep -v "can't change option: zle" "$TEST_ROOT/zsh.err" >&2 || true
  [ "$zsh_status" -eq 0 ] || fail "zsh probe exited $zsh_status"
else
  echo "[skip] zsh not found" >&2
fi

# The worktree base directory must not show up as untracked noise in the parent repo.
dirty="$(git -C "$FIXTURE" status --porcelain)"
if [ -n "$dirty" ]; then
  fail "worktrees under $EXPECTED_BASEDIR pollute git status of the main repo: $dirty"
fi
echo "[ok] $EXPECTED_BASEDIR stays out of the main repository's git status"
