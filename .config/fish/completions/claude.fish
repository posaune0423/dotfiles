set -l claude_permission_modes acceptEdits bypassPermissions default dontAsk plan auto
set -l claude_effort_levels low medium high max
set -l claude_input_formats text stream-json
set -l claude_output_formats text json stream-json
set -l claude_commands agents auth doctor install mcp plugin plugins setup-token update upgrade

complete -c claude -f

complete -c claude -n __fish_use_subcommand -a agents -d "List configured agents"
complete -c claude -n __fish_use_subcommand -a auth -d "Manage authentication"
complete -c claude -n __fish_use_subcommand -a doctor -d "Check the health of the Claude Code auto-updater"
complete -c claude -n __fish_use_subcommand -a install -d "Install Claude Code native build"
complete -c claude -n __fish_use_subcommand -a mcp -d "Configure and manage MCP servers"
complete -c claude -n __fish_use_subcommand -a plugin -d "Manage Claude Code plugins"
complete -c claude -n __fish_use_subcommand -a plugins -d "Manage Claude Code plugins"
complete -c claude -n __fish_use_subcommand -a setup-token -d "Set up a long-lived authentication token"
complete -c claude -n __fish_use_subcommand -a update -d "Check for updates and install if available"
complete -c claude -n __fish_use_subcommand -a upgrade -d "Check for updates and install if available"

complete -c claude -l add-dir -r -f -a "(__fish_complete_directories)" -d "Additional directories to allow tool access to"
complete -c claude -l agent -r -d "Agent for the current session"
complete -c claude -l agents -r -d "JSON object defining custom agents"
complete -c claude -l allow-dangerously-skip-permissions -d "Enable bypassing permission checks as an option"
complete -c claude -l allowedTools -r -d "Comma or space-separated list of tool names to allow"
complete -c claude -l allowed-tools -r -d "Comma or space-separated list of tool names to allow"
complete -c claude -l append-system-prompt -r -d "Append a system prompt to the default system prompt"
complete -c claude -l betas -r -d "Beta headers to include in API requests"
complete -c claude -l brief -d "Enable SendUserMessage tool for agent-to-user communication"
complete -c claude -l chrome -d "Enable Claude in Chrome integration"
complete -c claude -s c -l continue -d "Continue the most recent conversation in the current directory"
complete -c claude -l dangerously-skip-permissions -d "Bypass all permission checks"
complete -c claude -s d -l debug -r -d "Enable debug mode with optional category filtering"
complete -c claude -l debug-file -r -F -d "Write debug logs to a specific file path"
complete -c claude -l disable-slash-commands -d "Disable all skills"
complete -c claude -l disallowedTools -r -d "Comma or space-separated list of tool names to deny"
complete -c claude -l disallowed-tools -r -d "Comma or space-separated list of tool names to deny"
complete -c claude -l effort -r -f -a "low\tLow
medium\tMedium
high\tHigh
max\tMax" -d "Effort level for the current session"
complete -c claude -l fallback-model -r -d "Fallback model to use with --print"
complete -c claude -l file -r -F -d "File resources to download at startup"
complete -c claude -l fork-session -d "Create a new session ID when resuming"
complete -c claude -l from-pr -r -d "Resume a session linked to a PR"
complete -c claude -s h -l help -d "Display help for command"
complete -c claude -l ide -d "Automatically connect to an IDE on startup"
complete -c claude -l include-partial-messages -d "Include partial chunks as they arrive"
complete -c claude -l input-format -r -f -a "text\tPlain text
stream-json\tStreaming JSON input" -d "Input format for --print"
complete -c claude -l json-schema -r -d "JSON Schema for structured output validation"
complete -c claude -l max-budget-usd -r -d "Maximum dollar amount to spend on API calls"
complete -c claude -l mcp-config -r -F -d "Load MCP servers from JSON files or strings"
complete -c claude -l mcp-debug -d "Enable MCP debug mode"
complete -c claude -l model -r -d "Model for the current session"
complete -c claude -s n -l name -r -d "Display name for this session"
complete -c claude -l no-chrome -d "Disable Claude in Chrome integration"
complete -c claude -l no-session-persistence -d "Disable session persistence"
complete -c claude -l output-format -r -f -a "text\tPlain text
json\tSingle JSON result
stream-json\tStreaming JSON output" -d "Output format for --print"
complete -c claude -l permission-mode -r -f -a "acceptEdits\tAccept edits
bypassPermissions\tBypass permissions
default\tDefault mode
dontAsk\tDo not ask
plan\tPlan mode
auto\tAuto mode" -d "Permission mode to use for the session"
complete -c claude -l plugin-dir -r -f -a "(__fish_complete_directories)" -d "Load plugins from a directory"
complete -c claude -s p -l print -d "Print response and exit"
complete -c claude -l replay-user-messages -d "Re-emit user messages from stdin to stdout"
complete -c claude -s r -l resume -r -d "Resume a conversation by session ID"
complete -c claude -l session-id -r -d "Use a specific session ID for the conversation"
complete -c claude -l setting-sources -r -d "Comma-separated list of setting sources to load"
complete -c claude -l settings -r -F -d "Path to a settings JSON file or a JSON string"
complete -c claude -l strict-mcp-config -d "Only use MCP servers from --mcp-config"
complete -c claude -l system-prompt -r -d "System prompt to use for the session"
complete -c claude -l tmux -r -d "Create a tmux session for the worktree"
complete -c claude -l tools -r -d "Specify the list of available built-in tools"
complete -c claude -l verbose -d "Override verbose mode setting from config"
complete -c claude -s v -l version -d "Output the version number"
complete -c claude -s w -l worktree -r -d "Create a new git worktree for this session"
