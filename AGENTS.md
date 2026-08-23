# AGENTS.md

## Repository scope

This is the public source repository for personal macOS dotfiles. `install.sh` links tracked files
into the user's home directory, so editing a tracked config may affect the live shell or app
immediately when that link is already installed.

These instructions apply at the repository root. `dotagents/` is a Git submodule with its own
`AGENTS.md`; follow the submodule instructions for work inside it.

## Sources of truth

- `install.sh` owns clone/update, backup, and symlink behavior. Keep the install table in
  `README.md` synchronized with it.
- `.config/mise/config.toml` owns runtime and CLI versions. Keep the mise inventory in `README.md`
  synchronized with it.
- Fish reads `.config/fish/conf.d/*.fish` in lexical order before `config.fish` for interactive and
  non-interactive shells. Guard interactive-only work with `status is-interactive`.
- `.zshenv`, `.zprofile`, `.zshrc`, and `.config/zsh/` jointly define Zsh startup. Preserve their
  login, interactive, and environment-only boundaries.
- `.config/macos/network/` and `scripts/macos-network.sh` jointly define the network-profile
  contract.
- `Makefile`, `scripts/format/`, and `.github/workflows/ci.yml` define repository validation. Use
  the existing Make targets; do not introduce a second task runner for ordinary changes.
- Edit `AGENTS.md`, not `CLAUDE.md`. `CLAUDE.md` must remain a symlink to `AGENTS.md`.

There is no `docs/` steering tree in this repository. Local task notes under ignored
`.agents/memory/` are not repository documentation or a source of truth and must never be
committed.

## Ownership and generated state

- `.config/karabiner/karabiner.json`, `.config/nvim/lazy-lock.json`, and
  `.config/nvim/lazyvim.json` are app-managed state. Include them only for an intentional app
  change, inspect the semantic diff, and do not reformat them.
- `.config/fish/completions/*.fish` is vendored or generated upstream output. Replace a completion
  from its owning tool; do not hand-format it.
- `.config/fish/completions.local/`, Fish variable files, `.nvimlog`, and `.agents/memory/` are
  machine-local and ignored. Never force-add them.
- Never add `.config/karabiner/automatic_backups/` snapshots.
- A generated or app-managed file becoming dirty is not evidence that it belongs in a commit.
  Tie it to the requested behavior before staging it.

## Privacy and portability

Treat every tracked file, commit, PR body, and review comment as public.

- Do not place credentials, tokens, real SSIDs, non-public account or machine identifiers, private
  repository or client names, private URLs, machine-specific workspace paths, or conditional Git
  identities in tracked files, commits, PR bodies, or review comments. Intentionally public Git
  author identity and explicitly public, non-sensitive tool metadata are allowed.
- Keep repository-specific Git paths and identities in `~/.gitconfig.local`. Tracked `.gitconfig`
  may include that optional file but must not contain repository-specific `includeIf` rules.
- Prefer `$HOME`, XDG variables, and command lookup over new `/Users/...` paths or
  version-specific binary paths.
- Before staging, inspect the full diff for private identifiers. Run
  `sh scripts/verify_gitconfig_privacy.sh` whenever Git configuration changes.

## Safe change workflow

1. Start with `git status --short --branch`, `git diff`, and `git submodule status`. Preserve
   unrelated local changes; never clean, reset, reformat, or stage them as collateral work.
2. Make the smallest change for one observable behavior. If a source of truth changes, update its
   derived README section in the same change.
3. For shell routing, installer, or privacy regressions, add or update an isolated verification
   script under `scripts/`. Use a temporary `HOME` or `ZDOTDIR` and assert command resolution,
   output, or exit status rather than source-text strings.
4. Treat installer and network actions as stateful. Do not run `install.sh` without `--dry-run`, or
   run `./scripts/macos-network.sh` with the `use`, `apply`, or `export-defaults` subcommand,
   without explicit user authorization. Prefer dry-run or read-only commands.
5. Before committing, recheck `git status`, `git diff --check`, and the staged diff. Exclude
   app-generated churn and unrelated live-config edits.

## Validation

Run commands from the repository root. `make lint` includes the format check.

```sh
make lint
git diff --check
```

For Git privacy or shell command-routing changes, also run:

```sh
sh scripts/verify_gitconfig_privacy.sh
fish scripts/verify_fish_tool_routing.fish
sh scripts/verify_zsh_mise_path.sh
```

Use the relevant additional check when changing its surface:

```sh
sh scripts/verify_fish_completions.sh
sh ./install.sh --dry-run --yes --no-update
./scripts/macos-network.sh validate --all
```

The network validation command is macOS-only. A green Linux CI run does not replace a macOS
login-shell or affected-app smoke test. Report local checks, CI, and live shell/app verification as
separate evidence.

## Submodule contract

- Initialize missing content with `git submodule update --init --recursive`.
- The parent repository owns only `.gitmodules` and the `dotagents` gitlink. Make content changes in
  the `dotagents` repository, commit and review them there, then update the parent pointer
  intentionally.
- Before committing a pointer bump, run `git -C dotagents status --short --branch`,
  `git submodule status`, and inspect `git diff --submodule=log`.
- Never absorb nested uncommitted `dotagents` work into an unrelated parent-repository PR.

## Branches and pull requests

- Branch from `main`. Use the established `feat/<name>`, `fix/<name>`, or `chore/<name>` prefixes;
  never use an agent or tool prefix.
- Do not push directly to `main`. Keep each PR scoped to one concern and keep submodule work
  separate unless a pointer update is the stated purpose.
- Write PR bodies in Japanese with context, changes, user-visible effect, validation, and caveats.
  Preserve existing CodeRabbit-managed sections when updating a PR.
- Do not merge unless the user explicitly requests it.

## Code review rules

- Flag credentials, private identifiers, absolute machine paths, or repository-specific Git
  identities. Safe path: move them to an untracked local include or environment variable.
- Flag changes that can replace live home-directory targets without preserving installer backup and
  dry-run behavior. Safe path: keep replacement recoverable and prove it with dry-run output.
- Flag Fish/Zsh startup-order changes that shadow mise-managed tools or diverge between login and
  interactive shells. Safe path: test observable command resolution in an isolated environment.
- Flag app-generated formatting churn and accidental `dotagents` gitlink changes. Safe path: keep
  only the semantic, explicitly requested change.
- Do not accept formatting or CI success as behavioral proof by itself. Require a focused regression
  check and state any macOS or app-level verification that was not performed.
