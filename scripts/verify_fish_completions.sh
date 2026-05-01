#!/bin/sh
set -eu

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
XDG_CONFIG_HOME="$REPO_ROOT/.config"
export XDG_CONFIG_HOME

assert_completion() {
  command_name="$1"
  expected_option="$2"

  output="$(fish -ic "complete -C '$command_name --'")"

  if ! printf '%s\n' "$output" | grep -F -- "$expected_option" >/dev/null 2>&1; then
    echo "[fail] $command_name: missing completion $expected_option" >&2
    exit 1
  fi

  echo "[ok] $command_name: found $expected_option"
}

assert_completion codex --help
assert_completion claude --help
assert_completion cursor-agent --help
