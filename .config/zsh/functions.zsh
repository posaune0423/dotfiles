#---------------------------
# Custom Functions
#---------------------------

# Enhanced cat function with image support
function cat() {
  # If no arguments or "-" is passed, read from stdin
  if [ $# -eq 0 ] || [[ "$*" == *"-"* ]]; then
    command cat "$@"
    return
  fi

  # Process each file argument
  for file in "$@"; do
    case "${file##*.}" in
      jpg | jpeg | png | gif | bmp | tiff | webp)
        if command -v viu > /dev/null 2>&1; then
          viu "$file"
        else
          command cat "$file"
        fi
        ;;
      *)
        if command -v bat > /dev/null 2>&1; then
          bat "$file"
        else
          command cat "$file"
        fi
        ;;
    esac
  done
}
