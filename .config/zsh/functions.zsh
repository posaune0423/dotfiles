#---------------------------
# Custom Functions
#---------------------------

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