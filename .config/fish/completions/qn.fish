# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_qn_global_optspecs
	string join \n api-key= config-file= o/format= no-color q/quiet w/wide v/verbose no-input retries= y/yes base-url= base-prefix= h/help V/version
end

function __fish_qn_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_qn_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_qn_using_subcommand
	set -l cmd (__fish_qn_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c qn -n "__fish_qn_needs_command" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_needs_command" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_needs_command" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_needs_command" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_needs_command" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_needs_command" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_needs_command" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_needs_command" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_needs_command" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_needs_command" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_needs_command" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_needs_command" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_needs_command" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_needs_command" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_needs_command" -f -a "auth" -d 'Manage CLI authentication (API key)'
complete -c qn -n "__fish_qn_needs_command" -f -a "agent" -d 'Resources for AI agents and automated tools'
complete -c qn -n "__fish_qn_needs_command" -f -a "endpoint" -d 'Manage RPC endpoints on your account'
complete -c qn -n "__fish_qn_needs_command" -f -a "endpoints" -d 'Manage RPC endpoints on your account'
complete -c qn -n "__fish_qn_needs_command" -f -a "team" -d 'Manage teams'
complete -c qn -n "__fish_qn_needs_command" -f -a "teams" -d 'Manage teams'
complete -c qn -n "__fish_qn_needs_command" -f -a "usage" -d 'View account usage'
complete -c qn -n "__fish_qn_needs_command" -f -a "metrics" -d 'View account or endpoint metrics'
complete -c qn -n "__fish_qn_needs_command" -f -a "chain" -d 'List supported blockchains'
complete -c qn -n "__fish_qn_needs_command" -f -a "chains" -d 'List supported blockchains'
complete -c qn -n "__fish_qn_needs_command" -f -a "billing" -d 'View invoices and payments'
complete -c qn -n "__fish_qn_needs_command" -f -a "activity-log" -d 'View the account activity log (who changed what, when)'
complete -c qn -n "__fish_qn_needs_command" -f -a "activity-logs" -d 'View the account activity log (who changed what, when)'
complete -c qn -n "__fish_qn_needs_command" -f -a "activity" -d 'View the account activity log (who changed what, when)'
complete -c qn -n "__fish_qn_needs_command" -f -a "transaction" -d 'View retained transactions submitted through your endpoints'
complete -c qn -n "__fish_qn_needs_command" -f -a "transactions" -d 'View retained transactions submitted through your endpoints'
complete -c qn -n "__fish_qn_needs_command" -f -a "tx" -d 'View retained transactions submitted through your endpoints'
complete -c qn -n "__fish_qn_needs_command" -f -a "stream" -d 'Manage blockchain data streams'
complete -c qn -n "__fish_qn_needs_command" -f -a "streams" -d 'Manage blockchain data streams'
complete -c qn -n "__fish_qn_needs_command" -f -a "webhook" -d 'Manage filter-template webhooks'
complete -c qn -n "__fish_qn_needs_command" -f -a "webhooks" -d 'Manage filter-template webhooks'
complete -c qn -n "__fish_qn_needs_command" -f -a "kv" -d 'Manage the Quicknode KV store (sets and lists)'
complete -c qn -n "__fish_qn_needs_command" -f -a "sql" -d 'List clusters, run SQL queries, and inspect cluster schemas'
complete -c qn -n "__fish_qn_needs_command" -f -a "rpc" -d 'Make RPC calls'
complete -c qn -n "__fish_qn_needs_command" -f -a "wallet" -d 'Manage local payment wallets for the paid RPC lane (`--x402`/`--mpp`)'
complete -c qn -n "__fish_qn_needs_command" -f -a "wallets" -d 'Manage local payment wallets for the paid RPC lane (`--x402`/`--mpp`)'
complete -c qn -n "__fish_qn_needs_command" -f -a "tooling-access" -d 'Manage Tooling Access (the endpoint `qn rpc` uses)'
complete -c qn -n "__fish_qn_needs_command" -f -a "completions" -d 'Generate shell completion scripts'
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -f -a "login" -d 'Prompt for an API key and save it to ~/.config/qn/config.toml'
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -f -a "logout" -d 'Delete the saved API key'
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -f -a "whoami" -d 'Show where the API key would come from, and confirm it works against the API'
complete -c qn -n "__fish_qn_using_subcommand auth; and not __fish_seen_subcommand_from login logout whoami status" -f -a "status" -d 'Show where the API key would come from (no network call)'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from login" -l api-key -d 'Provide the API key directly instead of being prompted. Useful for CI' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from login" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from login" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from login" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from login" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from login" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from login" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from login" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from login" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from login" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from login" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from login" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from login" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from login" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from logout" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from logout" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from logout" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from logout" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from logout" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from logout" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from logout" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from logout" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from logout" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from logout" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from logout" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from logout" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from logout" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from logout" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from whoami" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from whoami" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from whoami" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from whoami" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from whoami" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from whoami" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from whoami" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from whoami" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from whoami" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from whoami" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from whoami" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from whoami" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from whoami" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from whoami" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from status" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from status" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from status" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from status" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from status" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from status" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from status" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from status" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from status" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from status" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from status" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from status" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand auth; and __fish_seen_subcommand_from status" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand agent; and not __fish_seen_subcommand_from context" -f -a "context" -d 'Print a machine-readable usage guide for agents (no auth, no network)'
complete -c qn -n "__fish_qn_using_subcommand agent; and __fish_seen_subcommand_from context" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand agent; and __fish_seen_subcommand_from context" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand agent; and __fish_seen_subcommand_from context" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand agent; and __fish_seen_subcommand_from context" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand agent; and __fish_seen_subcommand_from context" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand agent; and __fish_seen_subcommand_from context" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand agent; and __fish_seen_subcommand_from context" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand agent; and __fish_seen_subcommand_from context" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand agent; and __fish_seen_subcommand_from context" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand agent; and __fish_seen_subcommand_from context" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand agent; and __fish_seen_subcommand_from context" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand agent; and __fish_seen_subcommand_from context" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand agent; and __fish_seen_subcommand_from context" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand agent; and __fish_seen_subcommand_from context" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "list" -d 'List endpoints on the account'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "ls" -d 'List endpoints on the account'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "create" -d 'Create a new endpoint on a chain/network'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "show" -d 'Show full details for a single endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "update" -d 'Update an endpoint\'s label'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "archive" -d 'Archive an endpoint (irreversible from the CLI)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "pause" -d 'Pause an endpoint (stops accepting requests)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "resume" -d 'Resume a paused endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "urls" -d 'Show the HTTP and WebSocket URLs for an endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "logs" -d 'Fetch request logs for an endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "log-details" -d 'Fetch a single request log\'s full request/response payloads'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "metrics" -d 'Fetch metric series for an endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "errors" -d 'Error totals for an endpoint over a time window (account-wide: `qn metrics errors`)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "enable-multichain" -d 'Enable multichain on an endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "disable-multichain" -d 'Disable multichain on an endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "tag" -d 'Manage endpoint tags (per-endpoint add/remove and account-wide list/rename/delete)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "tags" -d 'Manage endpoint tags (per-endpoint add/remove and account-wide list/rename/delete)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "security" -d 'Manage endpoint security settings (tokens, referrers, IPs, JWTs, ...)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "rate-limit" -d 'Manage rate limits on an endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "bulk" -d 'Bulk operations across many endpoints'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l limit -d 'Page size (max 100)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l offset -d 'Offset for pagination' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l search -d 'Free-text search' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l sort-by -d 'Sort key (e.g. `created_at`, `label`)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l sort-direction -d 'Sort direction' -r -f -a "asc\t''
desc\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l network -d 'Filter by network (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l status -d 'Filter by status (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l label -d 'Filter by label (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l dedicated -d 'Dedicated-only filter' -r -f -a "true\t''
false\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l flat-rate -d 'Flat-rate filter' -r -f -a "true\t''
false\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l tag-id -d 'Filter by tag id (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l tag -d 'Filter by tag label (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l limit -d 'Page size (max 100)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l offset -d 'Offset for pagination' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l search -d 'Free-text search' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l sort-by -d 'Sort key (e.g. `created_at`, `label`)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l sort-direction -d 'Sort direction' -r -f -a "asc\t''
desc\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l network -d 'Filter by network (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l status -d 'Filter by status (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l label -d 'Filter by label (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l dedicated -d 'Dedicated-only filter' -r -f -a "true\t''
false\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l flat-rate -d 'Flat-rate filter' -r -f -a "true\t''
false\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l tag-id -d 'Filter by tag id (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l tag -d 'Filter by tag label (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -l chain -d 'Blockchain (e.g. `ethereum`, `solana`; run `qn chain list` to see all)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -l network -d 'Network (e.g. `mainnet`)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from create" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -l label -d 'New label' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from update" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from archive" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from archive" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from archive" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from archive" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from archive" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from archive" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from archive" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from archive" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from archive" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from archive" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from archive" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from archive" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from archive" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from archive" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from pause" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from pause" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from pause" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from pause" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from pause" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from pause" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from pause" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from pause" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from pause" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from pause" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from pause" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from pause" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from pause" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from pause" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from resume" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from resume" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from resume" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from resume" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from resume" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from resume" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from resume" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from resume" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from resume" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from resume" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from resume" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from resume" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from resume" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from resume" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from urls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from urls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from urls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from urls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from urls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from urls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from urls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from urls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from urls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from urls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from urls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from urls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from urls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from urls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -l from -d 'Start of the window (RFC-3339, relative duration like `1h`, or `now`)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -l limit -d 'Page size' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -l next-at -d 'Pagination cursor (from a previous page\'s `next_at`)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -l details -d 'Include full request/response bodies inline'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from logs" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from log-details" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from log-details" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from log-details" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from log-details" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from log-details" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from log-details" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from log-details" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from log-details" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from log-details" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from log-details" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from log-details" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from log-details" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from log-details" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from log-details" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -l metric -d 'Metric name (e.g. `method_calls_over_time`, `metered_endpoint_data_over_time`, `metered_endpoint_credits_over_time`, `credits_over_time`, `response_status_breakdown`)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -l period -d 'Period (`hour`, `day`, `week`, `month`)' -r -f -a "hour\t''
day\t''
week\t''
month\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -l percentile -d 'Percentile (1-100); required for response-time metrics' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from metrics" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l from -d 'Start of the window (RFC-3339, a relative duration like `1h`, or `now`). Required unless --cursor is given' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l limit -d 'Page size (1-1000; the API defaults to 100)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l cursor -d 'Continue from a previous page\'s `next_cursor`. The cursor carries the original query, so no other flag may accompany it' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l group-by -d 'Group rows by these dimensions (repeatable or comma-separated)' -r -f -a "code\t''
network\t''
method\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l kind -d 'Error kind. Method filters and grouping need `rpc`; --status-code needs `http`' -r -f -a "rpc\t''
http\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l network -d 'Only these networks (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l method -d 'Only these RPC methods (repeatable; rpc kind)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l code -d 'Only these RPC error codes (repeatable; rpc kind)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l status-code -d 'Only these HTTP status codes (repeatable; http kind)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from errors" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from enable-multichain" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from enable-multichain" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from enable-multichain" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from enable-multichain" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from enable-multichain" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from enable-multichain" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from enable-multichain" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from enable-multichain" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from enable-multichain" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from enable-multichain" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from enable-multichain" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from enable-multichain" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from enable-multichain" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from enable-multichain" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from disable-multichain" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from disable-multichain" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from disable-multichain" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from disable-multichain" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from disable-multichain" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from disable-multichain" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from disable-multichain" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from disable-multichain" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from disable-multichain" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from disable-multichain" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from disable-multichain" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from disable-multichain" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from disable-multichain" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from disable-multichain" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -f -a "list" -d 'List every tag on the account with usage counts'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -f -a "ls" -d 'List every tag on the account with usage counts'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -f -a "rename" -d 'Rename a tag'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -f -a "delete" -d 'Delete a tag. The tag must not be applied to any endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -f -a "add" -d 'Tag an endpoint. Creates the tag on the account if missing'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tag" -f -a "remove" -d 'Remove a tag from an endpoint. `tag_id` is the numeric tag id from `qn endpoint tag list`'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -f -a "list" -d 'List every tag on the account with usage counts'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -f -a "ls" -d 'List every tag on the account with usage counts'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -f -a "rename" -d 'Rename a tag'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -f -a "delete" -d 'Delete a tag. The tag must not be applied to any endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -f -a "add" -d 'Tag an endpoint. Creates the tag on the account if missing'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from tags" -f -a "remove" -d 'Remove a tag from an endpoint. `tag_id` is the numeric tag id from `qn endpoint tag list`'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -f -a "show" -d 'Show the endpoint\'s full security configuration (tokens, referrers, IPs, ...)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -f -a "options" -d 'List the security feature toggles and their current state'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -f -a "set-options" -d 'Enable/disable individual security feature toggles'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -f -a "token" -d 'Manage authentication tokens on an endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -f -a "referrer" -d 'Manage referrer whitelist'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -f -a "ip" -d 'Manage IP whitelist'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -f -a "jwt" -d 'Manage JWT validation keys'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -f -a "domain-mask" -d 'Manage custom domain masks'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -f -a "request-filter" -d 'Manage RPC method request filters'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -f -a "ip-header" -d 'Manage the custom IP-identifying header'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -f -a "client-cert" -d 'Manage client certificates (mTLS)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -f -a "method-blacklist" -d 'Manage the blocked RPC method list'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -f -a "range-limit" -d 'Manage per-method block-range limits'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from security" -f -a "blocked-ip" -d 'Manage blocked IP addresses and CIDR ranges'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -f -a "get" -d 'Show the endpoint\'s current per-bucket rate limits'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -f -a "set" -d 'Set endpoint-level rate limits (any of rps/rpm/rpd/limit-by-ip; omitted are untouched)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -f -a "delete-override" -d 'Delete a user-set rate-limit override (plan defaults can\'t be deleted)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -f -a "method-list" -d 'List method-level rate limiters on the endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -f -a "method-create" -d 'Create a new method-level rate limiter'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -f -a "method-update" -d 'Update an existing method-level rate limiter'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from rate-limit" -f -a "method-delete" -d 'Delete a method-level rate limiter'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -f -a "pause" -d 'Pause many endpoints at once'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -f -a "resume" -d 'Resume (activate) many endpoints at once'
complete -c qn -n "__fish_qn_using_subcommand endpoint; and __fish_seen_subcommand_from bulk" -f -a "tag" -d 'Manage tags on many endpoints at once'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "list" -d 'List endpoints on the account'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "ls" -d 'List endpoints on the account'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "create" -d 'Create a new endpoint on a chain/network'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "show" -d 'Show full details for a single endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "update" -d 'Update an endpoint\'s label'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "archive" -d 'Archive an endpoint (irreversible from the CLI)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "pause" -d 'Pause an endpoint (stops accepting requests)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "resume" -d 'Resume a paused endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "urls" -d 'Show the HTTP and WebSocket URLs for an endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "logs" -d 'Fetch request logs for an endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "log-details" -d 'Fetch a single request log\'s full request/response payloads'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "metrics" -d 'Fetch metric series for an endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "errors" -d 'Error totals for an endpoint over a time window (account-wide: `qn metrics errors`)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "enable-multichain" -d 'Enable multichain on an endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "disable-multichain" -d 'Disable multichain on an endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "tag" -d 'Manage endpoint tags (per-endpoint add/remove and account-wide list/rename/delete)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "tags" -d 'Manage endpoint tags (per-endpoint add/remove and account-wide list/rename/delete)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "security" -d 'Manage endpoint security settings (tokens, referrers, IPs, JWTs, ...)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "rate-limit" -d 'Manage rate limits on an endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and not __fish_seen_subcommand_from list ls create show update archive pause resume urls logs log-details metrics errors enable-multichain disable-multichain tag tags security rate-limit bulk" -f -a "bulk" -d 'Bulk operations across many endpoints'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l limit -d 'Page size (max 100)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l offset -d 'Offset for pagination' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l search -d 'Free-text search' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l sort-by -d 'Sort key (e.g. `created_at`, `label`)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l sort-direction -d 'Sort direction' -r -f -a "asc\t''
desc\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l network -d 'Filter by network (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l status -d 'Filter by status (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l label -d 'Filter by label (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l dedicated -d 'Dedicated-only filter' -r -f -a "true\t''
false\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l flat-rate -d 'Flat-rate filter' -r -f -a "true\t''
false\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l tag-id -d 'Filter by tag id (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l tag -d 'Filter by tag label (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l limit -d 'Page size (max 100)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l offset -d 'Offset for pagination' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l search -d 'Free-text search' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l sort-by -d 'Sort key (e.g. `created_at`, `label`)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l sort-direction -d 'Sort direction' -r -f -a "asc\t''
desc\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l network -d 'Filter by network (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l status -d 'Filter by status (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l label -d 'Filter by label (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l dedicated -d 'Dedicated-only filter' -r -f -a "true\t''
false\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l flat-rate -d 'Flat-rate filter' -r -f -a "true\t''
false\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l tag-id -d 'Filter by tag id (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l tag -d 'Filter by tag label (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -l chain -d 'Blockchain (e.g. `ethereum`, `solana`; run `qn chain list` to see all)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -l network -d 'Network (e.g. `mainnet`)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from create" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -l label -d 'New label' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from update" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from archive" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from archive" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from archive" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from archive" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from archive" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from archive" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from archive" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from archive" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from archive" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from archive" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from archive" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from archive" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from archive" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from archive" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from pause" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from pause" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from pause" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from pause" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from pause" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from pause" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from pause" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from pause" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from pause" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from pause" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from pause" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from pause" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from pause" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from pause" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from resume" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from resume" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from resume" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from resume" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from resume" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from resume" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from resume" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from resume" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from resume" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from resume" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from resume" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from resume" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from resume" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from resume" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from urls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from urls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from urls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from urls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from urls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from urls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from urls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from urls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from urls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from urls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from urls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from urls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from urls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from urls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -l from -d 'Start of the window (RFC-3339, relative duration like `1h`, or `now`)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -l limit -d 'Page size' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -l next-at -d 'Pagination cursor (from a previous page\'s `next_at`)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -l details -d 'Include full request/response bodies inline'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from logs" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from log-details" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from log-details" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from log-details" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from log-details" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from log-details" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from log-details" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from log-details" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from log-details" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from log-details" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from log-details" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from log-details" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from log-details" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from log-details" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from log-details" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -l metric -d 'Metric name (e.g. `method_calls_over_time`, `metered_endpoint_data_over_time`, `metered_endpoint_credits_over_time`, `credits_over_time`, `response_status_breakdown`)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -l period -d 'Period (`hour`, `day`, `week`, `month`)' -r -f -a "hour\t''
day\t''
week\t''
month\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -l percentile -d 'Percentile (1-100); required for response-time metrics' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from metrics" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l from -d 'Start of the window (RFC-3339, a relative duration like `1h`, or `now`). Required unless --cursor is given' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l limit -d 'Page size (1-1000; the API defaults to 100)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l cursor -d 'Continue from a previous page\'s `next_cursor`. The cursor carries the original query, so no other flag may accompany it' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l group-by -d 'Group rows by these dimensions (repeatable or comma-separated)' -r -f -a "code\t''
network\t''
method\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l kind -d 'Error kind. Method filters and grouping need `rpc`; --status-code needs `http`' -r -f -a "rpc\t''
http\t''"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l network -d 'Only these networks (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l method -d 'Only these RPC methods (repeatable; rpc kind)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l code -d 'Only these RPC error codes (repeatable; rpc kind)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l status-code -d 'Only these HTTP status codes (repeatable; http kind)' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from errors" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from enable-multichain" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from enable-multichain" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from enable-multichain" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from enable-multichain" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from enable-multichain" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from enable-multichain" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from enable-multichain" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from enable-multichain" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from enable-multichain" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from enable-multichain" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from enable-multichain" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from enable-multichain" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from enable-multichain" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from enable-multichain" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from disable-multichain" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from disable-multichain" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from disable-multichain" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from disable-multichain" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from disable-multichain" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from disable-multichain" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from disable-multichain" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from disable-multichain" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from disable-multichain" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from disable-multichain" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from disable-multichain" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from disable-multichain" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from disable-multichain" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from disable-multichain" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -f -a "list" -d 'List every tag on the account with usage counts'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -f -a "ls" -d 'List every tag on the account with usage counts'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -f -a "rename" -d 'Rename a tag'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -f -a "delete" -d 'Delete a tag. The tag must not be applied to any endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -f -a "add" -d 'Tag an endpoint. Creates the tag on the account if missing'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tag" -f -a "remove" -d 'Remove a tag from an endpoint. `tag_id` is the numeric tag id from `qn endpoint tag list`'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -f -a "list" -d 'List every tag on the account with usage counts'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -f -a "ls" -d 'List every tag on the account with usage counts'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -f -a "rename" -d 'Rename a tag'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -f -a "delete" -d 'Delete a tag. The tag must not be applied to any endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -f -a "add" -d 'Tag an endpoint. Creates the tag on the account if missing'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from tags" -f -a "remove" -d 'Remove a tag from an endpoint. `tag_id` is the numeric tag id from `qn endpoint tag list`'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -f -a "show" -d 'Show the endpoint\'s full security configuration (tokens, referrers, IPs, ...)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -f -a "options" -d 'List the security feature toggles and their current state'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -f -a "set-options" -d 'Enable/disable individual security feature toggles'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -f -a "token" -d 'Manage authentication tokens on an endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -f -a "referrer" -d 'Manage referrer whitelist'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -f -a "ip" -d 'Manage IP whitelist'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -f -a "jwt" -d 'Manage JWT validation keys'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -f -a "domain-mask" -d 'Manage custom domain masks'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -f -a "request-filter" -d 'Manage RPC method request filters'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -f -a "ip-header" -d 'Manage the custom IP-identifying header'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -f -a "client-cert" -d 'Manage client certificates (mTLS)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -f -a "method-blacklist" -d 'Manage the blocked RPC method list'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -f -a "range-limit" -d 'Manage per-method block-range limits'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from security" -f -a "blocked-ip" -d 'Manage blocked IP addresses and CIDR ranges'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -f -a "get" -d 'Show the endpoint\'s current per-bucket rate limits'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -f -a "set" -d 'Set endpoint-level rate limits (any of rps/rpm/rpd/limit-by-ip; omitted are untouched)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -f -a "delete-override" -d 'Delete a user-set rate-limit override (plan defaults can\'t be deleted)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -f -a "method-list" -d 'List method-level rate limiters on the endpoint'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -f -a "method-create" -d 'Create a new method-level rate limiter'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -f -a "method-update" -d 'Update an existing method-level rate limiter'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from rate-limit" -f -a "method-delete" -d 'Delete a method-level rate limiter'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -f -a "pause" -d 'Pause many endpoints at once'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -f -a "resume" -d 'Resume (activate) many endpoints at once'
complete -c qn -n "__fish_qn_using_subcommand endpoints; and __fish_seen_subcommand_from bulk" -f -a "tag" -d 'Manage tags on many endpoints at once'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "list" -d 'List all teams on the account'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "ls" -d 'List all teams on the account'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "create" -d 'Create a team'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "show" -d 'Show team detail'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "delete" -d 'Delete a team'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "endpoints" -d 'List endpoints associated with a team'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "set-endpoints" -d 'Replace the set of endpoints associated with a team'
complete -c qn -n "__fish_qn_using_subcommand team; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "member" -d 'Manage team members'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -l name -d 'Team name' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from create" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from delete" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from delete" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from delete" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from delete" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from delete" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from delete" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from delete" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from delete" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from delete" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from delete" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from delete" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from delete" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from delete" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from endpoints" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from endpoints" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from endpoints" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from endpoints" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from endpoints" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from endpoints" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from endpoints" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from endpoints" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from endpoints" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from endpoints" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from endpoints" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from endpoints" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from endpoints" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from endpoints" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from set-endpoints" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from set-endpoints" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from set-endpoints" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from set-endpoints" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from set-endpoints" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from set-endpoints" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from set-endpoints" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from set-endpoints" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from set-endpoints" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from set-endpoints" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from set-endpoints" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from set-endpoints" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from set-endpoints" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from set-endpoints" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -f -a "invite" -d 'Invite a user to a team'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -f -a "remove" -d 'Remove a user from a team'
complete -c qn -n "__fish_qn_using_subcommand team; and __fish_seen_subcommand_from member" -f -a "resend" -d 'Re-send a pending team invitation'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "list" -d 'List all teams on the account'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "ls" -d 'List all teams on the account'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "create" -d 'Create a team'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "show" -d 'Show team detail'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "delete" -d 'Delete a team'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "endpoints" -d 'List endpoints associated with a team'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "set-endpoints" -d 'Replace the set of endpoints associated with a team'
complete -c qn -n "__fish_qn_using_subcommand teams; and not __fish_seen_subcommand_from list ls create show delete endpoints set-endpoints member" -f -a "member" -d 'Manage team members'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -l name -d 'Team name' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from create" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from delete" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from delete" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from delete" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from delete" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from delete" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from delete" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from delete" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from delete" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from delete" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from delete" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from delete" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from delete" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from delete" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from endpoints" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from endpoints" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from endpoints" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from endpoints" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from endpoints" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from endpoints" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from endpoints" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from endpoints" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from endpoints" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from endpoints" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from endpoints" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from endpoints" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from endpoints" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from endpoints" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from set-endpoints" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from set-endpoints" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from set-endpoints" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from set-endpoints" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from set-endpoints" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from set-endpoints" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from set-endpoints" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from set-endpoints" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from set-endpoints" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from set-endpoints" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from set-endpoints" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from set-endpoints" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from set-endpoints" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from set-endpoints" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -f -a "invite" -d 'Invite a user to a team'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -f -a "remove" -d 'Remove a user from a team'
complete -c qn -n "__fish_qn_using_subcommand teams; and __fish_seen_subcommand_from member" -f -a "resend" -d 'Re-send a pending team invitation'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -f -a "summary" -d 'Aggregate usage summary for the billing period (or --from/--to)'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -f -a "by-endpoint" -d 'Per-endpoint usage breakdown'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -f -a "by-method" -d 'Per-RPC-method usage breakdown'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -f -a "by-chain" -d 'Per-chain usage breakdown'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -f -a "by-tag" -d 'Per-tag usage breakdown'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -f -a "credits" -d 'Credit totals over a time window'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -f -a "rpc" -d 'RPC totals over a time window, optionally grouped and filtered'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -f -a "streams" -d 'Streams totals over a time window, optionally grouped by stream'
complete -c qn -n "__fish_qn_using_subcommand usage; and not __fish_seen_subcommand_from summary by-endpoint by-method by-chain by-tag credits rpc streams webhooks" -f -a "webhooks" -d 'Webhooks totals over a time window, optionally grouped by webhook'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -l from -d 'Start time (RFC-3339, relative like `7d`, or `now`). Omit for account-to-date' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -l to -d 'End time. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from summary" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -l from -d 'Start time (RFC-3339, relative like `7d`, or `now`). Omit for account-to-date' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -l to -d 'End time. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-endpoint" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -l from -d 'Start time (RFC-3339, relative like `7d`, or `now`). Omit for account-to-date' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -l to -d 'End time. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-method" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -l from -d 'Start time (RFC-3339, relative like `7d`, or `now`). Omit for account-to-date' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -l to -d 'End time. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-chain" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -l from -d 'Start time (RFC-3339, relative like `7d`, or `now`). Omit for account-to-date' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -l to -d 'End time. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from by-tag" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -l from -d 'Start of the window (RFC-3339, a relative duration like `1h`, or `now`). Required unless --cursor is given' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -l limit -d 'Page size (1-1000; the API defaults to 100)' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -l cursor -d 'Continue from a previous page\'s `next_cursor`. The cursor carries the original query, so no other flag may accompany it' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from credits" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l from -d 'Start of the window (RFC-3339, a relative duration like `1h`, or `now`). Required unless --cursor is given' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l limit -d 'Page size (1-1000; the API defaults to 100)' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l cursor -d 'Continue from a previous page\'s `next_cursor`. The cursor carries the original query, so no other flag may accompany it' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l group-by -d 'Group rows by these dimensions (repeatable or comma-separated)' -r -f -a "method\t''
endpoint\t''
chain\t''
network\t''"
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l endpoint-name -d 'Only these endpoint subdomains (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l chain -d 'Only these chains (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l network -d 'Only these networks (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l method -d 'Only these RPC methods (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l tag-id -d 'Only endpoints carrying these numeric tag ids (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l addon-id -d 'Only these numeric add-on ids (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from rpc" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -l from -d 'Start of the window (RFC-3339, a relative duration like `1h`, or `now`). Required unless --cursor is given' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -l limit -d 'Page size (1-1000; the API defaults to 100)' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -l cursor -d 'Continue from a previous page\'s `next_cursor`. The cursor carries the original query, so no other flag may accompany it' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -l group-by -d 'Group rows by stream' -r -f -a "stream\t''"
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -l stream-id -d 'Only this stream' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from streams" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -l from -d 'Start of the window (RFC-3339, a relative duration like `1h`, or `now`). Required unless --cursor is given' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -l limit -d 'Page size (1-1000; the API defaults to 100)' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -l cursor -d 'Continue from a previous page\'s `next_cursor`. The cursor carries the original query, so no other flag may accompany it' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -l group-by -d 'Group rows by webhook' -r -f -a "webhook\t''"
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -l webhook-id -d 'Only this webhook' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand usage; and __fish_seen_subcommand_from webhooks" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -f -a "account" -d 'Account-level metric series (credits/calls/latency)'
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -f -a "endpoint" -d 'Endpoint-level metric series'
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -f -a "traffic" -d 'Traffic totals over a time window, optionally grouped by method or endpoint'
complete -c qn -n "__fish_qn_using_subcommand metrics; and not __fish_seen_subcommand_from account endpoint traffic errors" -f -a "errors" -d 'Account-wide error totals over a time window, optionally grouped and filtered'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -l period -d 'Period' -r -f -a "hour\t''
day\t''
week\t''
month\t''"
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -l metric -d 'Metric name (e.g. `method_calls_over_time`, `metered_endpoint_data_over_time`, `metered_endpoint_credits_over_time`, `credits_over_time`)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -l percentile -d 'Percentile (for latency metrics)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from account" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -l period -d 'Period' -r -f -a "hour\t''
day\t''
week\t''
month\t''"
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -l metric -d 'Metric name (e.g. `method_calls_over_time`, `metered_endpoint_data_over_time`, `metered_endpoint_credits_over_time`, `credits_over_time`, `response_status_breakdown`)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -l percentile -d 'Percentile (1-100); required for response-time metrics' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from endpoint" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l from -d 'Start of the window (RFC-3339, a relative duration like `1h`, or `now`). Required unless --cursor is given' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l limit -d 'Page size (1-1000; the API defaults to 100)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l cursor -d 'Continue from a previous page\'s `next_cursor`. The cursor carries the original query, so no other flag may accompany it' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l group-by -d 'Group rows by these dimensions (repeatable or comma-separated)' -r -f -a "method\t''
endpoint\t''"
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l endpoint-name -d 'Only these endpoint subdomains (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l chain -d 'Only these chains (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l network -d 'Only these networks (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l method -d 'Only these RPC methods (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l tag-id -d 'Only endpoints carrying these numeric tag ids (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l addon-id -d 'Only these numeric add-on ids (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from traffic" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l from -d 'Start of the window (RFC-3339, a relative duration like `1h`, or `now`). Required unless --cursor is given' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l limit -d 'Page size (1-1000; the API defaults to 100)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l cursor -d 'Continue from a previous page\'s `next_cursor`. The cursor carries the original query, so no other flag may accompany it' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l group-by -d 'Group rows by these dimensions (repeatable or comma-separated)' -r -f -a "code\t''
endpoint\t''
network\t''
method\t''"
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l endpoint -d 'Only these numeric endpoint ids (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l kind -d 'Error kind. Method filters and grouping need `rpc`; --status-code needs `http`' -r -f -a "rpc\t''
http\t''"
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l network -d 'Only these networks (repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l method -d 'Only these RPC methods (repeatable; rpc kind)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l code -d 'Only these RPC error codes (repeatable; rpc kind)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l status-code -d 'Only these HTTP status codes (repeatable; http kind)' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand metrics; and __fish_seen_subcommand_from errors" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -f -a "list" -d 'List supported chains and their networks'
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -f -a "ls" -d 'List supported chains and their networks'
complete -c qn -n "__fish_qn_using_subcommand chain; and not __fish_seen_subcommand_from list ls credits" -f -a "credits" -d 'Show per-method API credit costs for a chain'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from credits" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from credits" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from credits" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from credits" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from credits" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from credits" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from credits" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from credits" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from credits" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from credits" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from credits" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from credits" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from credits" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand chain; and __fish_seen_subcommand_from credits" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -f -a "list" -d 'List supported chains and their networks'
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -f -a "ls" -d 'List supported chains and their networks'
complete -c qn -n "__fish_qn_using_subcommand chains; and not __fish_seen_subcommand_from list ls credits" -f -a "credits" -d 'Show per-method API credit costs for a chain'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from credits" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from credits" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from credits" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from credits" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from credits" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from credits" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from credits" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from credits" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from credits" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from credits" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from credits" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from credits" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from credits" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand chains; and __fish_seen_subcommand_from credits" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -f -a "invoices" -d 'List invoices on the account'
complete -c qn -n "__fish_qn_using_subcommand billing; and not __fish_seen_subcommand_from invoices payments" -f -a "payments" -d 'List payments on the account'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from invoices" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from invoices" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from invoices" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from invoices" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from invoices" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from invoices" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from invoices" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from invoices" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from invoices" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from invoices" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from invoices" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from invoices" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from invoices" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from invoices" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from payments" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from payments" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from payments" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from payments" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from payments" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from payments" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from payments" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from payments" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from payments" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from payments" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from payments" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from payments" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from payments" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand billing; and __fish_seen_subcommand_from payments" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -f -a "list" -d 'List account changes, newest first'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -f -a "ls" -d 'List account changes, newest first'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -f -a "filters" -d 'List the actor ids and target types that `list` accepts as filters'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and not __fish_seen_subcommand_from list ls filters show" -f -a "show" -d 'Show one activity entry'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l query -d 'Free-text search over descriptions, endpoint subdomains, and team names' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l actor -d 'Actor id (a user or API-key UUID from `qn activity-log filters`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l endpoint-id -d 'Only changes to this endpoint (numeric id)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l type -d 'Target type, e.g. `endpoint`, `team`, `api_key` (see `qn activity-log filters`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l from -d 'Start of the window (RFC-3339, a relative duration like `7d`, or `now`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l to -d 'End of the window. Pin it when paging so new entries don\'t shift pages' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l limit -d 'Page size (0-100; the API defaults to 20)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l offset -d 'Entries to skip' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l query -d 'Free-text search over descriptions, endpoint subdomains, and team names' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l actor -d 'Actor id (a user or API-key UUID from `qn activity-log filters`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l endpoint-id -d 'Only changes to this endpoint (numeric id)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l type -d 'Target type, e.g. `endpoint`, `team`, `api_key` (see `qn activity-log filters`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l from -d 'Start of the window (RFC-3339, a relative duration like `7d`, or `now`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l to -d 'End of the window. Pin it when paging so new entries don\'t shift pages' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l limit -d 'Page size (0-100; the API defaults to 20)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l offset -d 'Entries to skip' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from filters" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from filters" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from filters" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from filters" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from filters" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from filters" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from filters" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from filters" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from filters" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from filters" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from filters" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from filters" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from filters" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from filters" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity-log; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -f -a "list" -d 'List account changes, newest first'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -f -a "ls" -d 'List account changes, newest first'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -f -a "filters" -d 'List the actor ids and target types that `list` accepts as filters'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and not __fish_seen_subcommand_from list ls filters show" -f -a "show" -d 'Show one activity entry'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l query -d 'Free-text search over descriptions, endpoint subdomains, and team names' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l actor -d 'Actor id (a user or API-key UUID from `qn activity-log filters`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l endpoint-id -d 'Only changes to this endpoint (numeric id)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l type -d 'Target type, e.g. `endpoint`, `team`, `api_key` (see `qn activity-log filters`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l from -d 'Start of the window (RFC-3339, a relative duration like `7d`, or `now`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l to -d 'End of the window. Pin it when paging so new entries don\'t shift pages' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l limit -d 'Page size (0-100; the API defaults to 20)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l offset -d 'Entries to skip' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l query -d 'Free-text search over descriptions, endpoint subdomains, and team names' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l actor -d 'Actor id (a user or API-key UUID from `qn activity-log filters`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l endpoint-id -d 'Only changes to this endpoint (numeric id)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l type -d 'Target type, e.g. `endpoint`, `team`, `api_key` (see `qn activity-log filters`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l from -d 'Start of the window (RFC-3339, a relative duration like `7d`, or `now`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l to -d 'End of the window. Pin it when paging so new entries don\'t shift pages' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l limit -d 'Page size (0-100; the API defaults to 20)' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l offset -d 'Entries to skip' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from filters" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from filters" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from filters" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from filters" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from filters" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from filters" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from filters" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from filters" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from filters" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from filters" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from filters" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from filters" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from filters" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from filters" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity-logs; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -f -a "list" -d 'List account changes, newest first'
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -f -a "ls" -d 'List account changes, newest first'
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -f -a "filters" -d 'List the actor ids and target types that `list` accepts as filters'
complete -c qn -n "__fish_qn_using_subcommand activity; and not __fish_seen_subcommand_from list ls filters show" -f -a "show" -d 'Show one activity entry'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l query -d 'Free-text search over descriptions, endpoint subdomains, and team names' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l actor -d 'Actor id (a user or API-key UUID from `qn activity-log filters`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l endpoint-id -d 'Only changes to this endpoint (numeric id)' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l type -d 'Target type, e.g. `endpoint`, `team`, `api_key` (see `qn activity-log filters`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l from -d 'Start of the window (RFC-3339, a relative duration like `7d`, or `now`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l to -d 'End of the window. Pin it when paging so new entries don\'t shift pages' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l limit -d 'Page size (0-100; the API defaults to 20)' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l offset -d 'Entries to skip' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l query -d 'Free-text search over descriptions, endpoint subdomains, and team names' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l actor -d 'Actor id (a user or API-key UUID from `qn activity-log filters`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l endpoint-id -d 'Only changes to this endpoint (numeric id)' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l type -d 'Target type, e.g. `endpoint`, `team`, `api_key` (see `qn activity-log filters`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l from -d 'Start of the window (RFC-3339, a relative duration like `7d`, or `now`)' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l to -d 'End of the window. Pin it when paging so new entries don\'t shift pages' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l limit -d 'Page size (0-100; the API defaults to 20)' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l offset -d 'Entries to skip' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from filters" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from filters" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from filters" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from filters" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from filters" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from filters" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from filters" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from filters" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from filters" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from filters" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from filters" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from filters" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from filters" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from filters" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand activity; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -f -a "list" -d 'List retained transactions in a time window, newest first'
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -f -a "ls" -d 'List retained transactions in a time window, newest first'
complete -c qn -n "__fish_qn_using_subcommand transaction; and not __fish_seen_subcommand_from list ls show" -f -a "show" -d 'Show a transaction\'s retained details and submission attempts'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l from -d 'Start of the window (RFC-3339, a relative duration like `1h`, or `now`). Required unless --cursor is given' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l limit -d 'Page size (1-1000; the API defaults to 100)' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l cursor -d 'Continue from a previous page\'s `next_cursor`. The cursor carries the original query, so no other flag may accompany it' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l network -d 'Only this network (e.g. `ethereum-mainnet`)' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l method -d 'Only transactions submitted with this RPC method' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l state -d 'Only this state' -r -f -a "submitted\t''
succeeded\t''
failed\t''"
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l hash -d 'Only this transaction hash' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l endpoint -d 'Only these submitting endpoints (numeric ids; repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l from -d 'Start of the window (RFC-3339, a relative duration like `1h`, or `now`). Required unless --cursor is given' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l limit -d 'Page size (1-1000; the API defaults to 100)' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l cursor -d 'Continue from a previous page\'s `next_cursor`. The cursor carries the original query, so no other flag may accompany it' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l network -d 'Only this network (e.g. `ethereum-mainnet`)' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l method -d 'Only transactions submitted with this RPC method' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l state -d 'Only this state' -r -f -a "submitted\t''
succeeded\t''
failed\t''"
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l hash -d 'Only this transaction hash' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l endpoint -d 'Only these submitting endpoints (numeric ids; repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -l payloads -d 'Include each attempt\'s retained request and response text'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand transaction; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -f -a "list" -d 'List retained transactions in a time window, newest first'
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -f -a "ls" -d 'List retained transactions in a time window, newest first'
complete -c qn -n "__fish_qn_using_subcommand transactions; and not __fish_seen_subcommand_from list ls show" -f -a "show" -d 'Show a transaction\'s retained details and submission attempts'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l from -d 'Start of the window (RFC-3339, a relative duration like `1h`, or `now`). Required unless --cursor is given' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l limit -d 'Page size (1-1000; the API defaults to 100)' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l cursor -d 'Continue from a previous page\'s `next_cursor`. The cursor carries the original query, so no other flag may accompany it' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l network -d 'Only this network (e.g. `ethereum-mainnet`)' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l method -d 'Only transactions submitted with this RPC method' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l state -d 'Only this state' -r -f -a "submitted\t''
succeeded\t''
failed\t''"
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l hash -d 'Only this transaction hash' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l endpoint -d 'Only these submitting endpoints (numeric ids; repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l from -d 'Start of the window (RFC-3339, a relative duration like `1h`, or `now`). Required unless --cursor is given' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l limit -d 'Page size (1-1000; the API defaults to 100)' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l cursor -d 'Continue from a previous page\'s `next_cursor`. The cursor carries the original query, so no other flag may accompany it' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l network -d 'Only this network (e.g. `ethereum-mainnet`)' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l method -d 'Only transactions submitted with this RPC method' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l state -d 'Only this state' -r -f -a "submitted\t''
succeeded\t''
failed\t''"
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l hash -d 'Only this transaction hash' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l endpoint -d 'Only these submitting endpoints (numeric ids; repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -l payloads -d 'Include each attempt\'s retained request and response text'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand transactions; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -f -a "list" -d 'List retained transactions in a time window, newest first'
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -f -a "ls" -d 'List retained transactions in a time window, newest first'
complete -c qn -n "__fish_qn_using_subcommand tx; and not __fish_seen_subcommand_from list ls show" -f -a "show" -d 'Show a transaction\'s retained details and submission attempts'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l from -d 'Start of the window (RFC-3339, a relative duration like `1h`, or `now`). Required unless --cursor is given' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l limit -d 'Page size (1-1000; the API defaults to 100)' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l cursor -d 'Continue from a previous page\'s `next_cursor`. The cursor carries the original query, so no other flag may accompany it' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l network -d 'Only this network (e.g. `ethereum-mainnet`)' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l method -d 'Only transactions submitted with this RPC method' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l state -d 'Only this state' -r -f -a "submitted\t''
succeeded\t''
failed\t''"
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l hash -d 'Only this transaction hash' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l endpoint -d 'Only these submitting endpoints (numeric ids; repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l from -d 'Start of the window (RFC-3339, a relative duration like `1h`, or `now`). Required unless --cursor is given' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l to -d 'End of the window. Defaults to now' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l limit -d 'Page size (1-1000; the API defaults to 100)' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l cursor -d 'Continue from a previous page\'s `next_cursor`. The cursor carries the original query, so no other flag may accompany it' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l network -d 'Only this network (e.g. `ethereum-mainnet`)' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l method -d 'Only transactions submitted with this RPC method' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l state -d 'Only this state' -r -f -a "submitted\t''
succeeded\t''
failed\t''"
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l hash -d 'Only this transaction hash' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l endpoint -d 'Only these submitting endpoints (numeric ids; repeatable)' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -l payloads -d 'Include each attempt\'s retained request and response text'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand tx; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "list" -d 'List streams on the account'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "ls" -d 'List streams on the account'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "create" -d 'Create a stream (webhook destination). For non-webhook destinations, use --stream-config-file'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "show" -d 'Show a stream\'s full configuration and current state'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "update" -d 'Update editable fields on a stream'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "delete" -d 'Delete a stream'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "activate" -d 'Activate (resume) a stream'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "pause" -d 'Pause a stream'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "test-filter" -d 'Run a filter against a block without creating a stream'
complete -c qn -n "__fish_qn_using_subcommand stream; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "enabled-count" -d 'Count of currently enabled streams'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -l limit -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -l offset -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -l order-by -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -l order-direction -r -f -a "asc\t''
desc\t''"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -l stream-type -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -l limit -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -l offset -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -l order-by -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -l order-direction -r -f -a "asc\t''
desc\t''"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -l stream-type -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l stream-config-file -d 'Load full `CreateStreamParams` from a JSON file. When supplied, all other --flags are ignored. (Distinct from the global `--config-file`, which selects the CLI\'s own config TOML.)' -r -F
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l name -d 'Stream name' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l network -d 'Network (e.g. `ethereum-mainnet`)' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l dataset -d 'Dataset (snake_case)' -r -f -a "block\t''
block-with-receipts\t''
transactions\t''
logs\t''
receipts\t''
trace-blocks\t''
debug-traces\t''
block-with-receipts-debug-trace\t''
block-with-receipts-trace-block\t''
blob-sidecars\t''
programs-with-logs\t''
ledger\t''
events\t''
orders\t''
trades\t''
book-updates\t''
twap\t''
writer-actions\t''"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l start -d 'Start block' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l end -d 'End block (`-1` for continuous)' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l region -d 'Region' -r -f -a "usa-east\t''
europe-central\t''
asia-east\t''"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l plan -d 'Billing plan slug (optional)' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l webhook -d 'Webhook URL for the primary destination (use `--stream-config-file` for other destination types)' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l webhook-security-token -d 'Webhook security token (32-byte minimum). Optional' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l compression -d 'Payload compression (`gzip` or `none`). Defaults to `none`' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l batch-size -d 'dataset_batch_size (defaults to 1)' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l fix-block-reorgs -d 'Fix block reorgs (true/false). Defaults to false (disabled)' -r -f -a "true\t''
false\t''"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l elastic-batch-enabled -d 'elastic_batch_enabled' -r -f -a "true\t''
false\t''"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l notification-email -d 'Notification email' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l status -d 'Initial status' -r -f -a "active\t''
paused\t''
terminated\t''
completed\t''
blocked\t''"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l filter -d 'Filter function source (raw text). Will be base64-encoded' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l filter-file -d 'Path to a filter function file (will be base64-encoded)' -r -F
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l filter-language -d 'Filter language' -r -f -a "javascript\t''
go\t''
wasm\t''"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l threshold-fetch-buffer -d 'Threshold fetch buffer (server default applies if omitted)' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l keep-distance-from-tip -d 'Keep distance from tip (server default applies if omitted)' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from create" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -l name -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -l status -r -f -a "active\t''
paused\t''
terminated\t''
completed\t''
blocked\t''"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -l notification-email -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from update" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from delete" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from delete" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from delete" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from delete" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from delete" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from delete" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from delete" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from delete" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from delete" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from delete" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from delete" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from delete" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from delete" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from activate" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from activate" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from activate" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from activate" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from activate" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from activate" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from activate" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from activate" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from activate" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from activate" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from activate" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from activate" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from activate" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from activate" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from pause" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from pause" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from pause" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from pause" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from pause" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from pause" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from pause" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from pause" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from pause" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from pause" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from pause" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from pause" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from pause" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from pause" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -l network -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -l dataset -r -f -a "block\t''
block-with-receipts\t''
transactions\t''
logs\t''
receipts\t''
trace-blocks\t''
debug-traces\t''
block-with-receipts-debug-trace\t''
block-with-receipts-trace-block\t''
blob-sidecars\t''
programs-with-logs\t''
ledger\t''
events\t''
orders\t''
trades\t''
book-updates\t''
twap\t''
writer-actions\t''"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -l block -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -l filter -d 'Filter function source (raw text). Will be base64-encoded' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -l filter-file -r -F
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -l filter-language -r -f -a "javascript\t''
go\t''
wasm\t''"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from test-filter" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -l type -d 'Optional stream-type filter' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand stream; and __fish_seen_subcommand_from enabled-count" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "list" -d 'List streams on the account'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "ls" -d 'List streams on the account'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "create" -d 'Create a stream (webhook destination). For non-webhook destinations, use --stream-config-file'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "show" -d 'Show a stream\'s full configuration and current state'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "update" -d 'Update editable fields on a stream'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "delete" -d 'Delete a stream'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "activate" -d 'Activate (resume) a stream'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "pause" -d 'Pause a stream'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "test-filter" -d 'Run a filter against a block without creating a stream'
complete -c qn -n "__fish_qn_using_subcommand streams; and not __fish_seen_subcommand_from list ls create show update delete activate pause test-filter enabled-count" -f -a "enabled-count" -d 'Count of currently enabled streams'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -l limit -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -l offset -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -l order-by -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -l order-direction -r -f -a "asc\t''
desc\t''"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -l stream-type -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -l limit -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -l offset -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -l order-by -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -l order-direction -r -f -a "asc\t''
desc\t''"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -l stream-type -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l stream-config-file -d 'Load full `CreateStreamParams` from a JSON file. When supplied, all other --flags are ignored. (Distinct from the global `--config-file`, which selects the CLI\'s own config TOML.)' -r -F
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l name -d 'Stream name' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l network -d 'Network (e.g. `ethereum-mainnet`)' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l dataset -d 'Dataset (snake_case)' -r -f -a "block\t''
block-with-receipts\t''
transactions\t''
logs\t''
receipts\t''
trace-blocks\t''
debug-traces\t''
block-with-receipts-debug-trace\t''
block-with-receipts-trace-block\t''
blob-sidecars\t''
programs-with-logs\t''
ledger\t''
events\t''
orders\t''
trades\t''
book-updates\t''
twap\t''
writer-actions\t''"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l start -d 'Start block' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l end -d 'End block (`-1` for continuous)' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l region -d 'Region' -r -f -a "usa-east\t''
europe-central\t''
asia-east\t''"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l plan -d 'Billing plan slug (optional)' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l webhook -d 'Webhook URL for the primary destination (use `--stream-config-file` for other destination types)' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l webhook-security-token -d 'Webhook security token (32-byte minimum). Optional' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l compression -d 'Payload compression (`gzip` or `none`). Defaults to `none`' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l batch-size -d 'dataset_batch_size (defaults to 1)' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l fix-block-reorgs -d 'Fix block reorgs (true/false). Defaults to false (disabled)' -r -f -a "true\t''
false\t''"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l elastic-batch-enabled -d 'elastic_batch_enabled' -r -f -a "true\t''
false\t''"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l notification-email -d 'Notification email' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l status -d 'Initial status' -r -f -a "active\t''
paused\t''
terminated\t''
completed\t''
blocked\t''"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l filter -d 'Filter function source (raw text). Will be base64-encoded' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l filter-file -d 'Path to a filter function file (will be base64-encoded)' -r -F
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l filter-language -d 'Filter language' -r -f -a "javascript\t''
go\t''
wasm\t''"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l threshold-fetch-buffer -d 'Threshold fetch buffer (server default applies if omitted)' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l keep-distance-from-tip -d 'Keep distance from tip (server default applies if omitted)' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from create" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -l name -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -l status -r -f -a "active\t''
paused\t''
terminated\t''
completed\t''
blocked\t''"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -l notification-email -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from update" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from delete" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from delete" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from delete" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from delete" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from delete" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from delete" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from delete" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from delete" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from delete" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from delete" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from delete" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from delete" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from delete" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from activate" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from activate" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from activate" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from activate" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from activate" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from activate" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from activate" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from activate" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from activate" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from activate" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from activate" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from activate" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from activate" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from activate" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from pause" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from pause" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from pause" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from pause" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from pause" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from pause" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from pause" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from pause" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from pause" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from pause" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from pause" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from pause" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from pause" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from pause" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -l network -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -l dataset -r -f -a "block\t''
block-with-receipts\t''
transactions\t''
logs\t''
receipts\t''
trace-blocks\t''
debug-traces\t''
block-with-receipts-debug-trace\t''
block-with-receipts-trace-block\t''
blob-sidecars\t''
programs-with-logs\t''
ledger\t''
events\t''
orders\t''
trades\t''
book-updates\t''
twap\t''
writer-actions\t''"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -l block -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -l filter -d 'Filter function source (raw text). Will be base64-encoded' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -l filter-file -r -F
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -l filter-language -r -f -a "javascript\t''
go\t''
wasm\t''"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from test-filter" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -l type -d 'Optional stream-type filter' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand streams; and __fish_seen_subcommand_from enabled-count" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "list" -d 'List webhooks on the account'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "ls" -d 'List webhooks on the account'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "show" -d 'Show a single webhook'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "create" -d 'Create a webhook from a filter template'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "update" -d 'Update name/email/destination on a webhook (without changing the template)'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "update-template" -d 'Update the template arguments on a webhook (and optionally other fields)'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "delete" -d 'Delete a webhook'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "activate" -d 'Activate a webhook (resume delivery)'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "pause" -d 'Pause a webhook'
complete -c qn -n "__fish_qn_using_subcommand webhook; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "enabled-count" -d 'Count of currently enabled webhooks'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -l limit -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -l offset -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -l limit -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -l offset -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l name -d 'Webhook name' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l network -d 'Network (e.g. `ethereum-mainnet`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l url -d 'Destination URL' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l security-token -d 'Optional security token (server generates one if omitted)' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l compression -d 'Payload compression (`gzip` or `none`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l notification-email -d 'Optional notification email' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l template -d 'Filter template' -r -f -a "evm-wallet\t''
evm-contract-events\t''
evm-abi\t''
solana-wallet\t''
bitcoin-wallet\t''
xrpl-wallet\t''
hyperliquid-wallet-events\t''
stellar-wallet-transactions\t''"
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l wallet -d 'For wallet-style templates: wallet addresses (repeat)' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l account -d 'For Solana wallet template: account addresses (repeat)' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l contract -d 'For contract-events and abi templates: contract addresses (repeat)' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l event-hash -d 'For contract-events template: optional event topic hashes (repeat)' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l abi -d 'For abi template: contract ABI JSON inline' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l abi-file -d 'For abi template: path to a file with the contract ABI JSON' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l wallets-list-name -d 'For wallet-style templates: reference a saved wallets list by name (instead of `--wallet`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l accounts-list-name -d 'For Solana wallet template: reference a saved accounts list by name (instead of `--account`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l contracts-list-name -d 'For contract-events and abi templates: reference a saved contracts list by name (instead of `--contract`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l event-hashes-list-name -d 'For contract-events template: reference a saved event-hashes list by name' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from create" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -l name -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -l notification-email -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -l url -d 'New destination URL' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -l security-token -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -l compression -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l template -d 'New filter template (same flags as `create`)' -r -f -a "evm-wallet\t''
evm-contract-events\t''
evm-abi\t''
solana-wallet\t''
bitcoin-wallet\t''
xrpl-wallet\t''
hyperliquid-wallet-events\t''
stellar-wallet-transactions\t''"
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l wallet -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l account -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l contract -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l event-hash -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l abi -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l abi-file -r -F
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l wallets-list-name -d 'For wallet-style templates: reference a saved wallets list by name (instead of `--wallet`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l accounts-list-name -d 'For Solana wallet template: reference a saved accounts list by name (instead of `--account`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l contracts-list-name -d 'For contract-events and abi templates: reference a saved contracts list by name (instead of `--contract`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l event-hashes-list-name -d 'For contract-events template: reference a saved event-hashes list by name' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l name -d 'Optionally also rename' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l notification-email -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l url -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l security-token -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l compression -d 'Payload compression (`gzip` or `none`); required when `--url` is supplied' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from update-template" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from delete" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from delete" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from delete" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from delete" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from delete" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from delete" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from delete" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from delete" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from delete" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from delete" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from delete" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from delete" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from delete" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -l start-from -d 'Where to resume from' -r -f -a "last\t''
latest\t''"
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from activate" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from pause" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from pause" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from pause" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from pause" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from pause" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from pause" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from pause" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from pause" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from pause" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from pause" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from pause" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from pause" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from pause" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from pause" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from enabled-count" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from enabled-count" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from enabled-count" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from enabled-count" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from enabled-count" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from enabled-count" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from enabled-count" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from enabled-count" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from enabled-count" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from enabled-count" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from enabled-count" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from enabled-count" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from enabled-count" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhook; and __fish_seen_subcommand_from enabled-count" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "list" -d 'List webhooks on the account'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "ls" -d 'List webhooks on the account'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "show" -d 'Show a single webhook'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "create" -d 'Create a webhook from a filter template'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "update" -d 'Update name/email/destination on a webhook (without changing the template)'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "update-template" -d 'Update the template arguments on a webhook (and optionally other fields)'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "delete" -d 'Delete a webhook'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "activate" -d 'Activate a webhook (resume delivery)'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "pause" -d 'Pause a webhook'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and not __fish_seen_subcommand_from list ls show create update update-template delete activate pause enabled-count" -f -a "enabled-count" -d 'Count of currently enabled webhooks'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -l limit -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -l offset -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -l limit -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -l offset -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l name -d 'Webhook name' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l network -d 'Network (e.g. `ethereum-mainnet`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l url -d 'Destination URL' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l security-token -d 'Optional security token (server generates one if omitted)' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l compression -d 'Payload compression (`gzip` or `none`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l notification-email -d 'Optional notification email' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l template -d 'Filter template' -r -f -a "evm-wallet\t''
evm-contract-events\t''
evm-abi\t''
solana-wallet\t''
bitcoin-wallet\t''
xrpl-wallet\t''
hyperliquid-wallet-events\t''
stellar-wallet-transactions\t''"
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l wallet -d 'For wallet-style templates: wallet addresses (repeat)' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l account -d 'For Solana wallet template: account addresses (repeat)' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l contract -d 'For contract-events and abi templates: contract addresses (repeat)' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l event-hash -d 'For contract-events template: optional event topic hashes (repeat)' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l abi -d 'For abi template: contract ABI JSON inline' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l abi-file -d 'For abi template: path to a file with the contract ABI JSON' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l wallets-list-name -d 'For wallet-style templates: reference a saved wallets list by name (instead of `--wallet`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l accounts-list-name -d 'For Solana wallet template: reference a saved accounts list by name (instead of `--account`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l contracts-list-name -d 'For contract-events and abi templates: reference a saved contracts list by name (instead of `--contract`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l event-hashes-list-name -d 'For contract-events template: reference a saved event-hashes list by name' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from create" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -l name -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -l notification-email -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -l url -d 'New destination URL' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -l security-token -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -l compression -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l template -d 'New filter template (same flags as `create`)' -r -f -a "evm-wallet\t''
evm-contract-events\t''
evm-abi\t''
solana-wallet\t''
bitcoin-wallet\t''
xrpl-wallet\t''
hyperliquid-wallet-events\t''
stellar-wallet-transactions\t''"
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l wallet -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l account -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l contract -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l event-hash -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l abi -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l abi-file -r -F
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l wallets-list-name -d 'For wallet-style templates: reference a saved wallets list by name (instead of `--wallet`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l accounts-list-name -d 'For Solana wallet template: reference a saved accounts list by name (instead of `--account`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l contracts-list-name -d 'For contract-events and abi templates: reference a saved contracts list by name (instead of `--contract`)' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l event-hashes-list-name -d 'For contract-events template: reference a saved event-hashes list by name' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l name -d 'Optionally also rename' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l notification-email -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l url -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l security-token -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l compression -d 'Payload compression (`gzip` or `none`); required when `--url` is supplied' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from update-template" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from delete" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from delete" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from delete" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from delete" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from delete" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from delete" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from delete" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from delete" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from delete" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from delete" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from delete" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from delete" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from delete" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -l start-from -d 'Where to resume from' -r -f -a "last\t''
latest\t''"
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from activate" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from pause" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from pause" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from pause" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from pause" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from pause" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from pause" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from pause" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from pause" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from pause" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from pause" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from pause" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from pause" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from pause" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from pause" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from enabled-count" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from enabled-count" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from enabled-count" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from enabled-count" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from enabled-count" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from enabled-count" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from enabled-count" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from enabled-count" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from enabled-count" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from enabled-count" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from enabled-count" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from enabled-count" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from enabled-count" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand webhooks; and __fish_seen_subcommand_from enabled-count" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -f -a "set" -d 'Sets: a single string value under a key'
complete -c qn -n "__fish_qn_using_subcommand kv; and not __fish_seen_subcommand_from set list" -f -a "list" -d 'Lists: ordered string collections under a key'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -f -a "put" -d 'Store a value under a key. Pass `-` as VALUE to read from stdin'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -f -a "get" -d 'Get the value stored under a key'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -f -a "list" -d 'List all key/value entries'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -f -a "ls" -d 'List all key/value entries'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -f -a "delete" -d 'Delete a single set'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from set" -f -a "bulk" -d 'Add and/or delete multiple sets in one call'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -f -a "list" -d 'List all list keys'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -f -a "ls" -d 'List all list keys'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -f -a "get" -d 'Get items in a specific list (paginated)'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -f -a "create" -d 'Create a new list seeded with items'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -f -a "append" -d 'Append a single item to a list'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -f -a "contains" -d 'Check whether a list contains an item'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -f -a "remove-item" -d 'Remove a single item from a list'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -f -a "update" -d 'Add and/or remove items in a single call'
complete -c qn -n "__fish_qn_using_subcommand kv; and __fish_seen_subcommand_from list" -f -a "delete" -d 'Delete a list (and all its items)'
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -f -a "clusters" -d 'List the clusters you can query'
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -f -a "ls" -d 'List the clusters you can query'
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -f -a "query" -d 'Run a read-only SQL query against a cluster'
complete -c qn -n "__fish_qn_using_subcommand sql; and not __fish_seen_subcommand_from clusters ls query schema" -f -a "schema" -d 'Show a cluster\'s table schema (tables, engines, columns, types)'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from clusters" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from clusters" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from clusters" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from clusters" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from clusters" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from clusters" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from clusters" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from clusters" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from clusters" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from clusters" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from clusters" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from clusters" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from clusters" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from clusters" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -s f -l file -d 'Read the query from a file, or from stdin when the path is `-`' -r -F
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -l cluster-id -d 'The cluster to query (e.g. hyperliquid-core-mainnet)' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from query" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from schema" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from schema" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from schema" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from schema" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from schema" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from schema" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from schema" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from schema" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from schema" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from schema" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from schema" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from schema" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from schema" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand sql; and __fish_seen_subcommand_from schema" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -f -a "call" -d 'Make a JSON-RPC call'
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -f -a "list-networks" -d 'List the endpoint\'s available network keys'
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -f -a "ls" -d 'List the endpoint\'s available network keys'
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -f -a "x402" -d 'Manage x402 credit drawdown: buy prepaid credits, check the balance, or drip testnet credits. Pair with `qn rpc call --x402-drawdown`'
complete -c qn -n "__fish_qn_using_subcommand rpc; and not __fish_seen_subcommand_from call list-networks ls x402 mpp" -f -a "mpp" -d 'Manage an MPP payment channel: open, top-up, close, or check status. Pair with `qn rpc call --mpp-session`'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -s f -l params-file -d 'Read JSON params from a file, or from stdin when the path is `-`. Mutually exclusive with the positional params argument' -r -F
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l network -d 'Target network on the multichain endpoint, by its key (e.g. `solana-mainnet`, `polygon`, `btc`). Omit for the endpoint\'s default network. Run `qn rpc list-networks` to see available keys' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l endpoint-url -d 'Send the call to a fully-formed custom HTTP URL instead of the account\'s Tooling Access endpoint. The URL is self-authenticating: no session token is minted or attached. Overrides `[rpc] endpoint_url` in config. Mutually exclusive with `--network` (a custom URL is not multichain-routed)' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l payment-key-file -d 'File containing the raw payment private key (EVM/Tempo hex, Solana base58); pass `-` to read it from stdin. Never accepts the key itself. Precedence: this flag > --payment-wallet > `key_file` > `wallet` under [rpc.payment] in config' -r -F
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l payment-wallet -d 'Name of a stored wallet (from `qn wallet generate`) to pay with. Its key file under `<config-dir>/qn/wallets/` is used. Mutually exclusive with --payment-key-file' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l max-amount -d 'Spend ceiling per call, in integer base units of the asset (e.g. 10000 = 0.01 USDC). No built-in default: flag > `max_amount` under [rpc.payment]. Offered payments above the ceiling are never signed; among those at or under it, the cheapest is paid' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l payment-network -d 'Chain you PAY on — a network name (e.g. `base-sepolia`) or CAIP-2 id (e.g. `eip155:84532`) — independent of --network (the chain you query). Falls back to `payment_network` under [rpc.payment]' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l payment-asset -d 'Token to pay with: EVM contract address, Solana mint, or a symbol like USDC (resolved per network). Falls back to `payment_asset` under [rpc.payment]' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l svm-rpc-url -d 'Explicit Solana RPC URL for building x402/Solana payments. Falls back to `svm_rpc_url` under [rpc.payment], then a public Solana RPC (which rate-limits aggressively — set this at any real volume)' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l x402 -d 'Pay for this call per request with the x402 protocol (EVM or Solana stablecoin) instead of the account\'s API key. Moves real funds; use a dedicated, minimally funded wallet. Requires --network (the query chain, as the payment gateway\'s path slug — e.g. `base-sepolia`)'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l mpp -d 'Pay for this call per request with MPP (Tempo). Mutually exclusive with --x402; same rules otherwise'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l x402-drawdown -d 'Pay for this call from prepaid x402 credits (drawdown): no per-call signing, 1 credit per successful response. Buy credits first with `qn rpc x402 buy-credits`. Requires --network (the query chain). The session JWT is authenticated and refreshed automatically'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l mpp-session -d 'Pay for this call from an open MPP channel (session): a cumulative EIP-712 voucher, no on-chain tx per call. Open a channel first with `qn rpc mpp open`. Requires --network (the query chain)'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l receipt -d 'Wrap stdout as {"result": ..., "payment_receipt": ...}. The receipt is non-null only on MPP (the settlement transaction hash); null on x402. Payment happens either way — this only changes the output'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from call" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from list-networks" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from list-networks" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from list-networks" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from list-networks" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from list-networks" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from list-networks" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from list-networks" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from list-networks" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from list-networks" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from list-networks" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from list-networks" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from list-networks" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from list-networks" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from list-networks" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -f -a "buy-credits" -d 'Buy a block of prepaid credits, paying the gateway\'s offer with the configured wallet. Gated: names the spend ceiling before signing'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -f -a "balance" -d 'Show the account\'s current credit balance (prints the bare number; --format json for the full envelope)'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -f -a "credits" -d 'Show the account\'s current credit balance (prints the bare number; --format json for the full envelope)'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -f -a "drip" -d 'Request testnet credits from the faucet (Base Sepolia, once per account)'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -f -a "supported-networks" -d 'List the networks you can make x402-paid RPC calls to. Each slug is a valid --network for a paid call. No API key required'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -f -a "networks" -d 'List the networks you can make x402-paid RPC calls to. Each slug is a valid --network for a paid call. No API key required'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -f -a "supported-payments" -d 'List the payment options the x402 gateway accepts: the network you pay on, the token, and its contract address — ready --payment-network and --payment-asset values. No API key required'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from x402" -f -a "payments" -d 'List the payment options the x402 gateway accepts: the network you pay on, the token, and its contract address — ready --payment-network and --payment-asset values. No API key required'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -f -a "open" -d 'Open a payment channel by depositing into the escrow. Gated: names the deposit before signing'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -f -a "top-up" -d 'Add deposit to the open channel. Gated'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -f -a "close" -d 'Cooperatively close the channel (settle on-chain + refund unused deposit). Gated'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -f -a "status" -d 'Show the channel\'s deposit and remaining balance from the local record. Pass --verify to ask the gateway instead (spends one request unit)'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -f -a "supported-networks" -d 'List the networks you can make MPP-paid RPC calls to. Each slug is a valid --network for a paid call. No API key required'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -f -a "networks" -d 'List the networks you can make MPP-paid RPC calls to. Each slug is a valid --network for a paid call. No API key required'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -f -a "supported-payments" -d 'List the payment options the MPP gateway accepts: the network you pay on, the token, and its contract address — ready --payment-network and --payment-asset values. No API key required'
complete -c qn -n "__fish_qn_using_subcommand rpc; and __fish_seen_subcommand_from mpp" -f -a "payments" -d 'List the payment options the MPP gateway accepts: the network you pay on, the token, and its contract address — ready --payment-network and --payment-asset values. No API key required'
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -f -a "generate" -d 'Generate a new payment wallet and store it locally'
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -f -a "list" -d 'List stored wallets (names, VM family, address — never keys)'
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -f -a "ls" -d 'List stored wallets (names, VM family, address — never keys)'
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -f -a "show" -d 'Show a wallet\'s address, with a QR to fund it (on a terminal)'
complete -c qn -n "__fish_qn_using_subcommand wallet; and not __fish_seen_subcommand_from generate list ls show rm" -f -a "rm" -d 'Delete a stored wallet. The key is the only copy and cannot be recovered'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -l vm -d 'VM family: `evm` (x402/EVM, also MPP/Tempo) or `svm` (x402/Solana)' -r -f -a "evm\t'secp256k1 wallet for x402/EVM and MPP/Tempo (`0x…` hex key)'
svm\t'ed25519 wallet for x402/Solana (base58 key)'"
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -l name -d 'Wallet name (a-z, 0-9, `-`, `_`). Becomes the key file name and the `--payment-wallet` handle' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -l force -d 'Overwrite an existing wallet of the same name'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from generate" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from rm" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from rm" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from rm" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from rm" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from rm" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from rm" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from rm" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from rm" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from rm" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from rm" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from rm" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from rm" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from rm" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand wallet; and __fish_seen_subcommand_from rm" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -f -a "generate" -d 'Generate a new payment wallet and store it locally'
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -f -a "list" -d 'List stored wallets (names, VM family, address — never keys)'
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -f -a "ls" -d 'List stored wallets (names, VM family, address — never keys)'
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -f -a "show" -d 'Show a wallet\'s address, with a QR to fund it (on a terminal)'
complete -c qn -n "__fish_qn_using_subcommand wallets; and not __fish_seen_subcommand_from generate list ls show rm" -f -a "rm" -d 'Delete a stored wallet. The key is the only copy and cannot be recovered'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -l vm -d 'VM family: `evm` (x402/EVM, also MPP/Tempo) or `svm` (x402/Solana)' -r -f -a "evm\t'secp256k1 wallet for x402/EVM and MPP/Tempo (`0x…` hex key)'
svm\t'ed25519 wallet for x402/Solana (base58 key)'"
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -l name -d 'Wallet name (a-z, 0-9, `-`, `_`). Becomes the key file name and the `--payment-wallet` handle' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -l force -d 'Overwrite an existing wallet of the same name'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from generate" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from list" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from list" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from list" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from list" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from list" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from list" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from list" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from list" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from list" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from list" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from list" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from ls" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from ls" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from ls" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from ls" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from ls" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from ls" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from ls" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from ls" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from ls" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from ls" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from ls" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from ls" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from show" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from show" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from show" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from show" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from show" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from show" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from show" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from show" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from show" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from show" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from show" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from rm" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from rm" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from rm" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from rm" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from rm" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from rm" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from rm" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from rm" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from rm" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from rm" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from rm" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from rm" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from rm" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand wallets; and __fish_seen_subcommand_from rm" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -f -a "status" -d 'Show whether Tooling Access is enabled and the endpoint URL'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -f -a "enable" -d 'Enable (provision) Tooling Access. Idempotent; requires an admin role'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and not __fish_seen_subcommand_from status enable disable" -f -a "disable" -d 'Disable Tooling Access, cutting off blockchain access for all Quicknode developer tooling on this account. Idempotent'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from status" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from status" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from status" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from status" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from status" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from status" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from status" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from status" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from status" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from status" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from status" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from status" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from status" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from enable" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from enable" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from enable" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from enable" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from enable" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from enable" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from enable" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from enable" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from enable" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from enable" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from enable" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from enable" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from enable" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from enable" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from disable" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from disable" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from disable" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from disable" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from disable" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from disable" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from disable" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from disable" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from disable" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from disable" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from disable" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from disable" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from disable" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand tooling-access; and __fish_seen_subcommand_from disable" -s V -l version -d 'Print version'
complete -c qn -n "__fish_qn_using_subcommand completions" -l api-key -d 'API key. Overrides the config file' -r
complete -c qn -n "__fish_qn_using_subcommand completions" -l config-file -d 'Path to an alternate config file (default: ~/.config/qn/config.toml)' -r -F
complete -c qn -n "__fish_qn_using_subcommand completions" -s o -l format -d 'Output format. `table` is the human view; the others are pipeline-friendly serialized forms. If unset, falls back to the `[output] format = "…"` value in ~/.config/qn/config.toml, then the TTY-aware default: `table` when stdout is a terminal, `json` otherwise' -r -f -a "table\t'Pretty UTF-8 tables for humans'
json\t'Pretty-printed JSON'
yaml\t'YAML (same shape as JSON)'
md\t'GitHub-flavored markdown tables'
toon\t'Token-Oriented Object Notation'"
complete -c qn -n "__fish_qn_using_subcommand completions" -l retries -d 'Max automatic retries for read-only commands on transient failures (HTTP 429/500/502/503/504, timeouts). Uses exponential backoff with jitter. 0 disables retries. Commands that modify resources never retry' -r
complete -c qn -n "__fish_qn_using_subcommand completions" -l base-url -d 'Override the Quicknode API base URL (used for testing or on-prem mirrors). All four sub-clients (admin/streams/webhooks/kv) hang off this host' -r
complete -c qn -n "__fish_qn_using_subcommand completions" -l base-prefix -d 'Path prefix inserted between the host and each sub-client\'s path (e.g. `/console-api`). For reverse-proxy / gateway environments. Requires `--base-url`' -r
complete -c qn -n "__fish_qn_using_subcommand completions" -l no-color -d 'Disable ANSI colors. Also honored: NO_COLOR env var, TERM=dumb, non-TTY stdout'
complete -c qn -n "__fish_qn_using_subcommand completions" -s q -l quiet -d 'Suppress non-essential output (state-change confirmations on stderr)'
complete -c qn -n "__fish_qn_using_subcommand completions" -s w -l wide -d 'Show additional columns in list-style tables (e.g. URLs in `endpoint list`). Mirrors `kubectl get -o wide`. Only affects `table` and `md` formats — `json`/`yaml`/`toon` always include everything'
complete -c qn -n "__fish_qn_using_subcommand completions" -s v -l verbose -d 'Verbose output: include error bodies and other details'
complete -c qn -n "__fish_qn_using_subcommand completions" -l no-input -d 'Never prompt interactively; fail with a clear message if input is needed'
complete -c qn -n "__fish_qn_using_subcommand completions" -s y -l yes -d 'Skip confirmation prompts on destructive operations'
complete -c qn -n "__fish_qn_using_subcommand completions" -s h -l help -d 'Print help (see a summary with \'-h\')'
complete -c qn -n "__fish_qn_using_subcommand completions" -s V -l version -d 'Print version'
