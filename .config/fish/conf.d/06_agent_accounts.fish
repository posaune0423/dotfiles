#---------------------------
# Agent accounts (Claude Code / Codex)
#---------------------------
# Picks CLAUDE_CONFIG_DIR and CODEX_HOME from the repository owner on every cd,
# so `claude` / `codex` use the work account in work repositories and the
# personal one elsewhere. The mapping lives in ~/.config/agent-accounts/config and is
# resolved by dotagents' scripts/agent-account.sh (the Orca account-router
# plugin reads the same file for agents Orca launches).
#---------------------------
status is-interactive; or return

set -q AGENT_ACCOUNT_RESOLVER
or set -g AGENT_ACCOUNT_RESOLVER $HOME/ghq/github.com/posaune0423/dotagents/scripts/agent-account.sh
test -x $AGENT_ACCOUNT_RESOLVER; or return

function __agent_account_apply --on-variable PWD --description 'Route Claude Code / Codex to the account for this directory'
    set -l account
    set -l claude
    set -l codex
    for line in ($AGENT_ACCOUNT_RESOLVER --dir $PWD 2>/dev/null)
        set -l kv (string split -m 1 = -- $line)
        switch $kv[1]
            case account
                set account $kv[2]
            case claude
                set claude $kv[2]
            case codex
                set codex $kv[2]
        end
    end
    test -n "$account"; or return 0

    set -gx AGENT_ACCOUNT $account
    if test -n "$claude"
        set -gx CLAUDE_CONFIG_DIR $claude
        # Orca's `claude` function re-reads its own account pointer when this matches
        # CLAUDE_CONFIG_DIR; clearing it makes the directory above win.
        set -q ORCA_CLAUDE_INJECTED_CONFIG_DIR; and set -gx ORCA_CLAUDE_INJECTED_CONFIG_DIR ''
    end
    if test -n "$codex"
        set -gx CODEX_HOME $codex
        # Orca's zsh/bash wrappers restore CODEX_HOME from this in nested shells.
        set -q ORCA_CODEX_HOME; and set -gx ORCA_CODEX_HOME $codex
    end
end

__agent_account_apply
