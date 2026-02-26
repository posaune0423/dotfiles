# Lessons Learned

## 2026-02-26

- User correction pattern: when a theme JSON is provided, confirm target runtime (Cursor/VS Code vs shell/editor like fish/nvim) before implementation.
- Prevention rule: if scope is ambiguous, inspect current config targets and map the same palette to each explicitly requested tool.
- User correction pattern: when initial work solves only part of automation scope, promptly fold follow-up requirements (target naming + additional file types + CI wiring) into the same pass.
- Prevention rule: for formatter tasks, always check (1) target naming conventions, (2) file-type coverage, and (3) CI integration before reporting completion.
