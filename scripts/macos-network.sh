#!/bin/sh
# Manage dotfile-owned macOS TCP sysctl profiles.
# Typical flow:
#   ./scripts/macos-network.sh status
#   ./scripts/macos-network.sh use balanced-ethernet
#   ./scripts/macos-network.sh status
# Or explicit apply-only:
#   ./scripts/macos-network.sh apply balanced-ethernet
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
NETWORK_DIR="$DOTFILES_DIR/.config/macos/network"
PROFILE_DIR="$NETWORK_DIR/profiles"
ACTIVE_PROFILE_FILE="$NETWORK_DIR/active-profile"
DEFAULT_PROFILE="apple-default"
DRY_RUN=0
PARSED_KEY=""
PARSED_VALUE=""

MANAGED_KEYS="
kern.ipc.maxsockbuf
net.inet.tcp.autorcvbufmax
net.inet.tcp.delayed_ack
net.inet.tcp.mssdflt
net.inet.tcp.recvspace
net.inet.tcp.sendspace
net.inet.tcp.win_scale_factor
"

usage() {
  cat << EOF
Usage: ./scripts/macos-network.sh [--dry-run] <command> [profile|path]

Commands:
  list                    List available profiles
  current                 Print the active profile name
  show [profile]          Print the profile file
  path [profile]          Print the profile file path
  validate [profile]      Validate profile syntax and local sysctl support
  validate --all          Validate every profile
  status [profile]        Compare live sysctl values with a profile
  use <profile>           Set active profile and apply it now
  apply [profile]         Apply a profile with sysctl(8)
  export-defaults [path]  Write current live values in sysctl.conf format

Examples:
  ./scripts/macos-network.sh list
  ./scripts/macos-network.sh status
  ./scripts/macos-network.sh use balanced-ethernet
  ./scripts/macos-network.sh use default
  ./scripts/macos-network.sh --dry-run use balanced-ethernet
EOF
}

die() {
  printf '%s\n' "$*" >&2
  exit 1
}

trim() {
  printf '%s' "$1" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

require_darwin() {
  if [ "$(uname -s 2> /dev/null || echo unknown)" != "Darwin" ]; then
    die "This command only supports macOS (Darwin)."
  fi
}

require_command() {
  command -v "$1" > /dev/null 2>&1 || die "Required command not found: $1"
}

current_profile_name() {
  if [ -f "$ACTIVE_PROFILE_FILE" ]; then
    while IFS= read -r _line || [ -n "$_line" ]; do
      _profile="$(trim "$_line")"
      case "$_profile" in
        '' | \#*)
          continue
          ;;
      esac

      printf '%s\n' "$_profile"
      return 0
    done < "$ACTIVE_PROFILE_FILE"
  fi

  printf '%s\n' "$DEFAULT_PROFILE"
}

resolve_profile_name() {
  if [ "$#" -eq 0 ]; then
    current_profile_name
    return 0
  fi

  if [ "$1" = "default" ]; then
    printf '%s\n' "$DEFAULT_PROFILE"
    return 0
  fi

  case "$1" in
    '' | *[!A-Za-z0-9._-]*)
      die "Invalid profile name: $1"
      ;;
  esac

  printf '%s\n' "$1"
}

profile_file() {
  _profile_name="$(resolve_profile_name "$@")"
  _file="$PROFILE_DIR/${_profile_name}.conf"
  [ -f "$_file" ] || die "Profile not found: $_profile_name"
  printf '%s\n' "$_file"
}

is_managed_key() {
  _key="$1"
  for _managed_key in $MANAGED_KEYS; do
    if [ "$_managed_key" = "$_key" ]; then
      return 0
    fi
  done
  return 1
}

parse_profile_line() {
  PARSED_KEY=""
  PARSED_VALUE=""
  _raw_line="$1"
  _line="$(printf '%s' "$_raw_line" | sed 's/[[:space:]]*#.*$//')"
  _line="$(trim "$_line")"

  [ -n "$_line" ] || return 0

  case "$_line" in
    *=*) ;;
    *)
      die "Invalid line (expected key=value): $_raw_line"
      ;;
  esac

  PARSED_KEY="$(trim "${_line%%=*}")"
  PARSED_VALUE="$(trim "${_line#*=}")"

  [ -n "$PARSED_KEY" ] || die "Missing sysctl key in line: $_raw_line"
  [ -n "$PARSED_VALUE" ] || die "Missing sysctl value for $PARSED_KEY"
  is_managed_key "$PARSED_KEY" || die "Unsupported managed key: $PARSED_KEY"

  case "$PARSED_VALUE" in
    *[!0-9]*)
      die "Values must be unsigned integers: $PARSED_KEY=$PARSED_VALUE"
      ;;
  esac
}

validate_profile_syntax() {
  _file="$1"
  _seen_keys="|"
  _entry_count=0

  while IFS= read -r _raw_line || [ -n "$_raw_line" ]; do
    parse_profile_line "$_raw_line"
    [ -n "$PARSED_KEY" ] || continue

    case "$_seen_keys" in
      *"|$PARSED_KEY|"*)
        die "Duplicate sysctl key in $(basename "$_file"): $PARSED_KEY"
        ;;
    esac

    _seen_keys="${_seen_keys}${PARSED_KEY}|"
    _entry_count=$((_entry_count + 1))
  done < "$_file"

  [ "$_entry_count" -gt 0 ] || die "Profile is empty: $_file"

  for _managed_key in $MANAGED_KEYS; do
    case "$_seen_keys" in
      *"|$_managed_key|"*) ;;
      *)
        die "Missing managed key in $(basename "$_file"): $_managed_key"
        ;;
    esac
  done
}

validate_profile_support() {
  require_darwin
  require_command sysctl
  _file="$1"

  while IFS= read -r _raw_line || [ -n "$_raw_line" ]; do
    parse_profile_line "$_raw_line"
    [ -n "$PARSED_KEY" ] || continue
    sysctl -n "$PARSED_KEY" > /dev/null 2>&1 || die "Unsupported sysctl on this host: $PARSED_KEY"
  done < "$_file"
}

validate_one_profile() {
  _profile_name="$(resolve_profile_name "$@")"
  _file="$(profile_file "$_profile_name")"
  validate_profile_syntax "$_file"
  validate_profile_support "$_file"
  printf 'ok: %s\n' "$_profile_name"
}

list_profiles() {
  _active_profile="$(current_profile_name)"
  _found=0

  for _file in "$PROFILE_DIR"/*.conf; do
    [ -e "$_file" ] || continue
    _found=1
    _profile_name="$(basename "$_file" .conf)"
    _marker=" "
    if [ "$_profile_name" = "$_active_profile" ]; then
      _marker="*"
    fi
    printf '%s %s\n' "$_marker" "$_profile_name"
  done

  [ "$_found" -eq 1 ] || die "No profiles found in $PROFILE_DIR"
}

show_profile() {
  _profile_name="$(resolve_profile_name "$@")"
  _file="$(profile_file "$_profile_name")"
  cat "$_file"
}

print_profile_path() {
  _profile_name="$(resolve_profile_name "$@")"
  profile_file "$_profile_name"
}

write_active_profile() {
  _profile_name="$1"
  _tmp_file="${ACTIVE_PROFILE_FILE}.tmp.$$"
  mkdir -p "$NETWORK_DIR"
  cat > "$_tmp_file" << EOF
# Active profile for ./scripts/macos-network.sh.
# Change the profile name below, then run:
#   ./scripts/macos-network.sh status
#   ./scripts/macos-network.sh use <profile-name>
$_profile_name
EOF
  mv "$_tmp_file" "$ACTIVE_PROFILE_FILE"
}

print_status() {
  require_darwin
  require_command sysctl
  _profile_name="$(resolve_profile_name "$@")"
  _file="$(profile_file "$_profile_name")"
  validate_profile_syntax "$_file"
  validate_profile_support "$_file"

  printf 'active-profile: %s\n' "$(current_profile_name)"
  printf 'selected-profile: %s\n' "$_profile_name"
  printf 'profile-file: %s\n' "$_file"
  printf '\n'
  printf '%-31s %-12s %-12s %s\n' "sysctl" "current" "target" "state"
  printf '%-31s %-12s %-12s %s\n' "-------------------------------" "------------" "------------" "-----"

  while IFS= read -r _raw_line || [ -n "$_raw_line" ]; do
    parse_profile_line "$_raw_line"
    [ -n "$PARSED_KEY" ] || continue
    _current_value="$(sysctl -n "$PARSED_KEY")"
    _state="drift"
    if [ "$_current_value" = "$PARSED_VALUE" ]; then
      _state="ok"
    fi
    printf '%-31s %-12s %-12s %s\n' "$PARSED_KEY" "$_current_value" "$PARSED_VALUE" "$_state"
  done < "$_file"
}

apply_profile() {
  require_darwin
  require_command sysctl
  _profile_name="$(resolve_profile_name "$@")"
  _file="$(profile_file "$_profile_name")"
  validate_profile_syntax "$_file"
  validate_profile_support "$_file"

  if [ "$DRY_RUN" -eq 1 ]; then
    printf 'would apply profile: %s\n' "$_profile_name"
    printf 'sudo sysctl -f %s\n' "$_file"
    return 0
  fi

  printf 'applying profile: %s\n' "$_profile_name"
  if [ "$(id -u)" -eq 0 ]; then
    sysctl -f "$_file"
  else
    require_command sudo
    sudo sysctl -f "$_file"
  fi
}

emit_live_profile() {
  require_darwin
  require_command sysctl
  printf '# Snapshot captured from live sysctl values on %s.\n' "$(date '+%Y-%m-%d %H:%M:%S %z')"
  for _managed_key in $MANAGED_KEYS; do
    printf '%s=%s\n' "$_managed_key" "$(sysctl -n "$_managed_key")"
  done
}

export_defaults() {
  if [ "$#" -gt 1 ]; then
    die "export-defaults accepts at most one output path"
  fi

  if [ "$#" -eq 0 ]; then
    emit_live_profile
    return 0
  fi

  _output_path="$1"
  _output_dir="$(dirname "$_output_path")"
  _tmp_file="${_output_path}.tmp.$$"
  mkdir -p "$_output_dir"
  emit_live_profile > "$_tmp_file"
  mv "$_tmp_file" "$_output_path"
  printf 'wrote: %s\n' "$_output_path"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    *)
      break
      ;;
  esac
done

[ "$#" -gt 0 ] || {
  usage
  exit 1
}

_command="$1"
shift

case "$_command" in
  list)
    [ "$#" -eq 0 ] || die "list takes no arguments"
    list_profiles
    ;;
  current)
    [ "$#" -eq 0 ] || die "current takes no arguments"
    current_profile_name
    ;;
  show)
    [ "$#" -le 1 ] || die "show accepts at most one profile"
    show_profile "$@"
    ;;
  path)
    [ "$#" -le 1 ] || die "path accepts at most one profile"
    print_profile_path "$@"
    ;;
  validate)
    if [ "$#" -eq 0 ]; then
      validate_one_profile
    elif [ "$#" -eq 1 ] && [ "$1" = "--all" ]; then
      _validated_any=0
      for _file in "$PROFILE_DIR"/*.conf; do
        [ -e "$_file" ] || continue
        _validated_any=1
        validate_one_profile "$(basename "$_file" .conf)"
      done
      [ "$_validated_any" -eq 1 ] || die "No profiles found in $PROFILE_DIR"
    elif [ "$#" -eq 1 ]; then
      validate_one_profile "$1"
    else
      die "validate accepts one profile or --all"
    fi
    ;;
  status)
    [ "$#" -le 1 ] || die "status accepts at most one profile"
    print_status "$@"
    ;;
  use)
    [ "$#" -eq 1 ] || die "use requires exactly one profile"
    _profile_name="$(resolve_profile_name "$1")"
    _file="$(profile_file "$_profile_name")"
    validate_profile_syntax "$_file"
    validate_profile_support "$_file"
    if [ "$DRY_RUN" -eq 1 ]; then
      printf 'would set active profile: %s\n' "$_profile_name"
      apply_profile "$_profile_name"
      exit 0
    fi
    write_active_profile "$_profile_name"
    printf 'active profile: %s\n' "$_profile_name"
    apply_profile "$_profile_name"
    ;;
  apply)
    [ "$#" -le 1 ] || die "apply accepts at most one profile"
    apply_profile "$@"
    ;;
  export-defaults)
    export_defaults "$@"
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
