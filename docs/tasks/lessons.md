# Lessons Learned

## 2026-02-26

- User correction pattern: when a theme JSON is provided, confirm target runtime (Cursor/VS Code vs shell/editor like fish/nvim) before implementation.
- Prevention rule: if scope is ambiguous, inspect current config targets and map the same palette to each explicitly requested tool.
- User correction pattern: when initial work solves only part of automation scope, promptly fold follow-up requirements (target naming + additional file types + CI wiring) into the same pass.
- Prevention rule: for formatter tasks, always check (1) target naming conventions, (2) file-type coverage, and (3) CI integration before reporting completion.
- User correction pattern: CI naming clarity matters; use generic workflow names (`ci.yml`, `CI`) when scope exceeds a single tool.
- Prevention rule: after expanding CI scope, always rename workflow file/title/job names to match current responsibilities before finishing.
- User correction pattern: when CI/workflow naming is unclear, prioritize explicit, generic naming (`ci.yml`, `CI`) that reflects the full scope.
- Prevention rule: before finishing CI edits, verify workflow filename/title and job names are semantically aligned with all executed tasks.
- User correction pattern: GitHub Actions tool installers can silently fall back to different install paths with incompatible package semantics (e.g., cargo-binstall for non-Rust tools).
- Prevention rule: when using `taiki-e/install-action`, verify each tool is actually supported; install unsupported tools (like `jq`) via OS package manager explicitly.
