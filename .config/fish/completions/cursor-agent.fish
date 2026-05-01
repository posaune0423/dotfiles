set -l cursor_agent_output_formats text json stream-json
set -l cursor_agent_modes plan ask
set -l cursor_agent_sandbox_modes enabled disabled

complete -c cursor-agent -f

complete -c cursor-agent -n __fish_use_subcommand -a install-shell-integration -d "Install shell integration to ~/.zshrc"
complete -c cursor-agent -n __fish_use_subcommand -a uninstall-shell-integration -d "Remove shell integration from ~/.zshrc"
complete -c cursor-agent -n __fish_use_subcommand -a login -d "Authenticate with Cursor"
complete -c cursor-agent -n __fish_use_subcommand -a logout -d "Sign out and clear stored authentication"
complete -c cursor-agent -n __fish_use_subcommand -a mcp -d "Manage MCP servers"
complete -c cursor-agent -n __fish_use_subcommand -a status -d "View authentication status"
complete -c cursor-agent -n __fish_use_subcommand -a whoami -d "View authentication status"
complete -c cursor-agent -n __fish_use_subcommand -a models -d "List available models for this account"
complete -c cursor-agent -n __fish_use_subcommand -a about -d "Display version, system, and account information"
complete -c cursor-agent -n __fish_use_subcommand -a update -d "Update Cursor Agent to the latest version"
complete -c cursor-agent -n __fish_use_subcommand -a create-chat -d "Create a new empty chat and return its ID"
complete -c cursor-agent -n __fish_use_subcommand -a generate-rule -d "Generate a new Cursor rule with interactive prompts"
complete -c cursor-agent -n __fish_use_subcommand -a rule -d "Generate a new Cursor rule with interactive prompts"
complete -c cursor-agent -n __fish_use_subcommand -a agent -d "Start the Cursor Agent"
complete -c cursor-agent -n __fish_use_subcommand -a ls -d "Resume a chat session"
complete -c cursor-agent -n __fish_use_subcommand -a resume -d "Resume the latest chat session"
complete -c cursor-agent -n __fish_use_subcommand -a help -d "Display help for command"

complete -c cursor-agent -s v -l version -d "Output the version number"
complete -c cursor-agent -l api-key -r -d "API key for authentication"
complete -c cursor-agent -s H -l header -r -d "Add a custom header"
complete -c cursor-agent -s p -l print -d "Print responses to console"
complete -c cursor-agent -l output-format -r -f -a "text\tPlain text
json\tSingle JSON result
stream-json\tStreaming JSON output" -d "Output format for --print"
complete -c cursor-agent -l stream-partial-output -d "Stream partial output as text deltas"
complete -c cursor-agent -s c -l cloud -d "Start in cloud mode"
complete -c cursor-agent -l mode -r -f -a "plan\tRead-only planning mode
ask\tRead-only Q and A mode" -d "Start in the given execution mode"
complete -c cursor-agent -l plan -d "Start in plan mode"
complete -c cursor-agent -l resume -r -d "Select a session to resume"
complete -c cursor-agent -l continue -d "Continue previous session"
complete -c cursor-agent -l model -r -d "Model to use"
complete -c cursor-agent -l list-models -d "List available models and exit"
complete -c cursor-agent -s f -l force -d "Force allow commands unless explicitly denied"
complete -c cursor-agent -l yolo -d "Alias for --force"
complete -c cursor-agent -l sandbox -r -f -a "enabled\tEnable sandbox
disabled\tDisable sandbox" -d "Explicitly enable or disable sandbox mode"
complete -c cursor-agent -l approve-mcps -d "Automatically approve all MCP servers"
complete -c cursor-agent -l trust -d "Trust the current workspace without prompting"
complete -c cursor-agent -l workspace -r -f -a "(__fish_complete_directories)" -d "Workspace directory to use"
complete -c cursor-agent -s w -l worktree -r -d "Start in an isolated git worktree"
complete -c cursor-agent -l worktree-base -r -d "Branch or ref to base the new worktree on"
complete -c cursor-agent -l skip-worktree-setup -d "Skip worktree setup scripts"
complete -c cursor-agent -s h -l help -d "Display help for command"
