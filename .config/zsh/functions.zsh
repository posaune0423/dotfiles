#---------------------------
# Custom Functions
#---------------------------

# Create directory and change to it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Quick file search
ff() {
  find . -name "*$1*" -type f 2>/dev/null
}

# Copy file content to clipboard (macOS)
cpc() {
  if [[ -f "$1" ]]; then
    cat "$1" | pbcopy
    echo "Content of $1 copied to clipboard"
  else
    echo "File not found: $1"
  fi
}

# Extract various archive formats
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xvjf "$1" ;;
      *.tar.gz) tar xvzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xvf "$1" ;;
      *.tbz2) tar xvjf "$1" ;;
      *.tgz) tar xvzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *.7z) 7z x "$1" ;;
      *) echo "don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

# Enhanced cat function with image support
function cat() {
  for file in "$@"; do
    case "${file##*.}" in
    jpg | jpeg | png | gif | bmp | tiff | webp)
      viu "$file"
      ;;
    *)
      bat "$file"
      ;;
    esac
  done
}

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
