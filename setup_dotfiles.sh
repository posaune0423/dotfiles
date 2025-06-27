#!/bin/bash

# dotfiles setup script
# Copy .config and .zsh related files to home directory

# Color settings for messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get script location (dotfiles repository root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Function to ask user for confirmation
ask_overwrite() {
    local file_path="$1"
    local relative_path="$2"

    print_warning "File already exists: ${relative_path}"
    echo -e "${YELLOW}Do you want to overwrite it? (y/n):${NC} \c"
    read -r response

    case "$response" in
    [yY] | [yY][eE][sS])
        return 0 # Overwrite
        ;;
    *)
        print_info "Skipped: ${relative_path}"
        return 1 # Skip
        ;;
    esac
}

# Function to copy files
copy_file() {
    local src="$1"
    local dest="$2"
    local relative_path="$3"

    # Create destination directory if it doesn't exist
    local dest_dir="$(dirname "$dest")"
    if [[ ! -d "$dest_dir" ]]; then
        mkdir -p "$dest_dir"
        print_info "Created directory: $dest_dir"
    fi

    # Check if file already exists
    if [[ -e "$dest" ]]; then
        if ask_overwrite "$dest" "$relative_path"; then
            cp -r "$src" "$dest"
            print_success "Copied (overwritten): ${relative_path}"
        fi
    else
        cp -r "$src" "$dest"
        print_success "Copied: ${relative_path}"
    fi
}

# Main process
main() {
    print_header "Dotfiles Setup Script"
    echo "Copying .config and .zsh related files from dotfiles repository to home directory"
    echo "Repository: $SCRIPT_DIR"
    echo "Destination: $HOME_DIR"
    echo ""

    # Process .zsh related files
    print_header "Copying .zsh related files"

        # .zshenv file
    if [[ -f "$SCRIPT_DIR/.zshenv" ]]; then
        copy_file "$SCRIPT_DIR/.zshenv" "$HOME_DIR/.zshenv" "~/.zshenv"
    fi

    # .zprofile file
    if [[ -f "$SCRIPT_DIR/.zprofile" ]]; then
        copy_file "$SCRIPT_DIR/.zprofile" "$HOME_DIR/.zprofile" "~/.zprofile"
    fi

    # .zshrc file
    if [[ -f "$SCRIPT_DIR/.zshrc" ]]; then
        copy_file "$SCRIPT_DIR/.zshrc" "$HOME_DIR/.zshrc" "~/.zshrc"
    fi

    echo ""

    # Process .config directory
    print_header "Copying .config directory"

        if [[ -d "$SCRIPT_DIR/.config" ]]; then
        # Process each item in .config directory individually
        for item in "$SCRIPT_DIR/.config"/*; do
            if [[ -e "$item" ]]; then
                local item_name="$(basename "$item")"
                local dest_path="$HOME_DIR/.config/$item_name"
                local relative_path="~/.config/$item_name"

                copy_file "$item" "$dest_path" "$relative_path"
            fi
        done
    else
        print_warning ".config directory not found"
    fi

    echo ""
    print_header "Setup Complete"
    print_success "Dotfiles setup completed successfully!"
    print_info "To apply changes, open a new terminal or run 'source ~/.zshrc'"
}

# Execute script
main "$@"
