#!/bin/sh
# Manage dotfile-owned macOS preferences that live in defaults(1) domains.
# Typical flow:
#   ./scripts/macos-defaults.sh status
#   ./scripts/macos-defaults.sh --dry-run apply
#   ./scripts/macos-defaults.sh apply
# The keyboard keys are read at login, so log out and back in after `apply`.
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROFILE_FILE="${MACOS_DEFAULTS_PROFILE:-$DOTFILES_DIR/.config/macos/defaults.conf}"
DRY_RUN=0
PARSED_DOMAIN=""
PARSED_KEY=""
PARSED_TYPE=""
PARSED_VALUE=""

usage() {
  cat << USAGE
Usage: ./scripts/macos-defaults.sh [--dry-run] <command> [path]

Commands:
  show                    Print the tracked profile
  path                    Print the profile file path
  validate                Validate profile syntax
  status                  Compare live defaults with the profile
  apply                   Write the profile with defaults(1); log out afterwards
  export-defaults [path]  Write current live values in profile format

Environment:
  MACOS_DEFAULTS_PROFILE  Profile file (default: .config/macos/defaults.conf)

Examples:
  ./scripts/macos-defaults.sh status
  ./scripts/macos-defaults.sh --dry-run apply
  ./scripts/macos-defaults.sh export-defaults ./.config/macos/defaults.conf
USAGE
}

die() {
  printf '%s\n' "$*" >&2
  exit 1
}

require_darwin() {
  if [ "$(uname -s 2> /dev/null || echo unknown)" != "Darwin" ]; then
    die "This command only supports macOS (Darwin)."
  fi
}

require_command() {
  command -v "$1" > /dev/null 2>&1 || die "Required command not found: $1"
}

require_profile() {
  [ -f "$PROFILE_FILE" ] || die "Profile not found: $PROFILE_FILE"
}

# Normalize a bool spelling to 1 or 0 so profile text and `defaults read` agree.
normalize_bool() {
  case "$1" in
    1 | true | TRUE | yes | YES) printf '1' ;;
    0 | false | FALSE | no | NO) printf '0' ;;
    *) return 1 ;;
  esac
}

# Render a normalized bool (1/0) as true/false for defaults(1) and profile text.
bool_word() {
  case "$1" in
    1) printf 'true' ;;
    0) printf 'false' ;;
    *) printf '%s' "$1" ;;
  esac
}

defaults_type_flag() {
  case "$1" in
    string) printf -- '-string' ;;
    bool) printf -- '-bool' ;;
    int) printf -- '-int' ;;
  esac
}

parse_profile_line() {
  PARSED_DOMAIN=""
  PARSED_KEY=""
  PARSED_TYPE=""
  PARSED_VALUE=""
  _raw_line="$1"
  _line="$(printf '%s' "$_raw_line" | sed 's/[[:space:]]*#.*$//; s/^[[:space:]]*//; s/[[:space:]]*$//')"
  [ -n "$_line" ] || return 0

  # shellcheck disable=SC2086 # word splitting is the parser here
  set -- $_line
  [ "$#" -eq 4 ] || die "Invalid line (expected <domain> <key> <type> <value>): $_raw_line"
  PARSED_DOMAIN="$1"
  PARSED_KEY="$2"
  PARSED_TYPE="$3"
  PARSED_VALUE="$4"

  # A domain is either a reverse-DNS name or a plist path used for isolated tests.
  case "$PARSED_DOMAIN" in
    *[!A-Za-z0-9_./-]*) die "Invalid defaults domain: $PARSED_DOMAIN" ;;
  esac

  case "$PARSED_KEY" in
    *[!A-Za-z0-9_.-]*) die "Invalid defaults key: $PARSED_KEY" ;;
  esac

  case "$PARSED_TYPE" in
    string) ;;
    bool)
      PARSED_VALUE="$(normalize_bool "$PARSED_VALUE")" || die "Bool values must be true/false: $PARSED_KEY"
      ;;
    int)
      # Optional single leading minus, then one or more digits.
      case "${PARSED_VALUE#-}" in
        '' | *[!0-9]*) die "Int values must be integers: $PARSED_KEY=$PARSED_VALUE" ;;
      esac
      ;;
    *) die "Unsupported type for $PARSED_KEY: $PARSED_TYPE (use string|bool|int)" ;;
  esac
}

validate_profile_syntax() {
  require_profile
  _seen_entries="|"
  _entry_count=0

  while IFS= read -r _raw_line || [ -n "$_raw_line" ]; do
    parse_profile_line "$_raw_line"
    [ -n "$PARSED_KEY" ] || continue
    _entry="$PARSED_DOMAIN $PARSED_KEY"
    case "$_seen_entries" in
      *"|$_entry|"*) die "Duplicate entry in $(basename "$PROFILE_FILE"): $_entry" ;;
    esac
    _seen_entries="${_seen_entries}${_entry}|"
    _entry_count=$((_entry_count + 1))
  done < "$PROFILE_FILE"

  [ "$_entry_count" -gt 0 ] || die "Profile is empty: $PROFILE_FILE"
}

# Print the live value for a key, or "<unset>" when the key does not exist.
read_live_value() {
  _domain="$1"
  _key="$2"
  _type="$3"
  if ! _value="$(defaults read "$_domain" "$_key" 2> /dev/null)"; then
    printf '<unset>'
    return 0
  fi
  if [ "$_type" = "bool" ]; then
    _value="$(normalize_bool "$_value" || printf '%s' "$_value")"
  fi
  printf '%s' "$_value"
}

print_status() {
  require_darwin
  require_command defaults
  validate_profile_syntax
  _drift=0

  printf 'profile-file: %s\n' "$PROFILE_FILE"
  printf '\n'
  printf '%-16s %-26s %-7s %-10s %-10s %s\n' "domain" "key" "type" "current" "target" "state"
  printf '%-16s %-26s %-7s %-10s %-10s %s\n' "----------------" "--------------------------" "-------" \
    "----------" "----------" "-----"

  while IFS= read -r _raw_line || [ -n "$_raw_line" ]; do
    parse_profile_line "$_raw_line"
    [ -n "$PARSED_KEY" ] || continue
    _current_value="$(read_live_value "$PARSED_DOMAIN" "$PARSED_KEY" "$PARSED_TYPE")"
    _state="drift"
    if [ "$_current_value" = "$PARSED_VALUE" ]; then
      _state="ok"
    else
      _drift=1
    fi
    printf '%-16s %-26s %-7s %-10s %-10s %s\n' "$PARSED_DOMAIN" "$PARSED_KEY" "$PARSED_TYPE" \
      "$_current_value" "$PARSED_VALUE" "$_state"
  done < "$PROFILE_FILE"

  return "$_drift"
}

apply_profile() {
  require_darwin
  require_command defaults
  validate_profile_syntax

  while IFS= read -r _raw_line || [ -n "$_raw_line" ]; do
    parse_profile_line "$_raw_line"
    [ -n "$PARSED_KEY" ] || continue
    _flag="$(defaults_type_flag "$PARSED_TYPE")"
    _write_value="$PARSED_VALUE"
    if [ "$PARSED_TYPE" = "bool" ]; then
      # defaults(1) -bool accepts only true/false/yes/no, never 1/0.
      _write_value="$(bool_word "$PARSED_VALUE")"
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
      printf 'defaults write %s %s %s %s\n' "$PARSED_DOMAIN" "$PARSED_KEY" "$_flag" "$_write_value"
      continue
    fi
    defaults write "$PARSED_DOMAIN" "$PARSED_KEY" "$_flag" "$_write_value"
    printf 'wrote: %s %s=%s\n' "$PARSED_DOMAIN" "$PARSED_KEY" "$_write_value"
  done < "$PROFILE_FILE"

  if [ "$DRY_RUN" -eq 1 ]; then
    printf 'would apply profile: %s\n' "$PROFILE_FILE"
  else
    printf 'applied profile: %s\n' "$PROFILE_FILE"
    printf 'Log out and back in (or reboot) to load the new values.\n'
  fi
}

emit_live_profile() {
  require_darwin
  require_command defaults
  validate_profile_syntax
  printf '# Snapshot captured on %s.\n' "$(date '+%Y-%m-%d %H:%M:%S %z')"
  printf '# Format: <domain> <key> <type> <value>   (type: string | bool | int)\n'
  while IFS= read -r _raw_line || [ -n "$_raw_line" ]; do
    parse_profile_line "$_raw_line"
    [ -n "$PARSED_KEY" ] || continue
    _current_value="$(read_live_value "$PARSED_DOMAIN" "$PARSED_KEY" "$PARSED_TYPE")"
    if [ "$_current_value" = "<unset>" ]; then
      printf '# %s %s is unset on this machine; keeping the tracked value.\n' "$PARSED_DOMAIN" "$PARSED_KEY"
      _current_value="$PARSED_VALUE"
    fi
    if [ "$PARSED_TYPE" = "bool" ]; then
      _current_value="$(bool_word "$_current_value")"
    fi
    printf '%-16s %-26s %-6s %s\n' "$PARSED_DOMAIN" "$PARSED_KEY" "$PARSED_TYPE" "$_current_value"
  done < "$PROFILE_FILE"
}

export_defaults() {
  [ "$#" -le 1 ] || die "export-defaults accepts at most one output path"
  if [ "$#" -eq 0 ]; then
    emit_live_profile
    return 0
  fi
  _output_path="$1"
  _tmp_file="${_output_path}.tmp.$$"
  mkdir -p "$(dirname "$_output_path")"
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
  show)
    [ "$#" -eq 0 ] || die "show takes no arguments"
    require_profile
    cat "$PROFILE_FILE"
    ;;
  path)
    [ "$#" -eq 0 ] || die "path takes no arguments"
    printf '%s\n' "$PROFILE_FILE"
    ;;
  validate)
    [ "$#" -eq 0 ] || die "validate takes no arguments"
    validate_profile_syntax
    printf 'ok: %s\n' "$PROFILE_FILE"
    ;;
  status)
    [ "$#" -eq 0 ] || die "status takes no arguments"
    print_status
    ;;
  apply)
    [ "$#" -eq 0 ] || die "apply takes no arguments"
    apply_profile
    ;;
  export-defaults)
    export_defaults "$@"
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
