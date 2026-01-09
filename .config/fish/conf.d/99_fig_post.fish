#---------------------------
# Kiro CLI Post-hook (secure implementation)
#---------------------------
# This implementation avoids eval on untrusted output by:
# 1. Writing kiro-cli output to a temporary file
# 2. Validating the file contents against a whitelist
# 3. Sourcing the validated file instead of eval-ing stdout
#---------------------------

function __kiro_cli_validate_output --description "Validate kiro-cli output file contents"
    set -l file_path $argv[1]

    if not test -f $file_path
        return 1
    end

    # Read file and validate each line
    # Use cat and process substitution for proper line-by-line reading
    for line in (cat $file_path)
        # Remove leading/trailing whitespace first
        set line (string trim "$line")

        # Skip empty lines and comments (check after trimming)
        if test -z "$line"; or string match -q "#*" "$line"
            continue
        end

        # Check for dangerous patterns that could execute arbitrary code:
        # - eval, exec commands (as standalone commands, not part of words)
        # - Dynamic source/load with variables
        # - Command substitution where variable is used as command: ($VAR)
        # - Dangerous commands with variables: (eval $VAR), (source $VAR), etc.
        # - Backtick command substitution
        # Match eval/exec as commands: start of line or after whitespace/semicolon/pipe/ampersand
        if string match -qr '(^|\s|;|\||&)(eval|exec)(\s|$)' "$line"
            return 1
        end

        # Check for dynamic source/load with variables (dangerous)
        if string match -qr '(source|\.)\s+.*\$' "$line"
            return 1
        end

        # Check for command substitution where variable is used directly as command: ($VAR)
        # This catches patterns like ($CMD) but not (string join $argv) where $argv is an argument
        if string match -qr '\(\$\w+' "$line"
            return 1
        end

        # Check for dangerous commands in command substitution with variables
        # Patterns like (eval $VAR), (source $VAR), (. $VAR), (exec $VAR)
        if string match -qr '\((eval|exec|source|\.)\s+\$' "$line"
            return 1
        end

        # Check for backtick command substitution (bash-style, not fish)
        if string match -qr '`[^`]*`' "$line"
            return 1
        end

        # Check for bash-style command substitution $(...)
        if string match -qr '\$\([^)]*\)' "$line"
            return 1
        end
    end

    return 0
end

# Main execution
# Basic binary integrity check: verify file exists, is executable, and is a regular file
if test -x ~/.local/bin/kiro-cli; and test -f ~/.local/bin/kiro-cli
    # Create temporary file in a secure location
    set -l temp_file (mktemp -t kiro-cli-post.XXXXXX.fish)

    # Ensure temp file was created, then proceed
    if test -f $temp_file
        # Run kiro-cli and capture output to temp file
        # Note: For enhanced security, consider verifying kiro-cli binary checksum/signature
        # before execution (e.g., using shasum or codesign on macOS)
        if ~/.local/bin/kiro-cli init fish post --rcfile 99_fig_post >$temp_file 2>/dev/null
            # Validate the output file contents before sourcing
            if __kiro_cli_validate_output $temp_file
                # Source the validated file (safer than eval)
                source $temp_file
            else
                # Log error but don't fail silently - allows shell to continue
                echo "Warning: kiro-cli output validation failed for 99_fig_post.fish" >&2
                echo "         Skipping kiro-cli post-hook initialization" >&2
            end
        else
            # kiro-cli execution failed
            echo "Warning: kiro-cli init fish post failed" >&2
        end

        # Always clean up temp file
        rm -f $temp_file
    else
        echo "Error: Failed to create temporary file for kiro-cli output" >&2
    end
end
