# Git workflow (keep it simple)

1. `main` always builds and passes tests. Nobody pushes directly to it.
2. Each member works on their own branch: `feature/numbers`, `feature/strings`, ...
3. Before opening a Pull Request:
   ```
   git pull origin main --rebase
   Regenerate the lexer (Ctrl+Shift+G) and run TestRunner from IntelliJ
   ```
4. Another member reviews the PR, then it is merged.
5. Small commits with clear messages: `numbers: add octal and binary literals`.

## Avoiding grammar conflicts
- Edit only the grammar section you own (see `TEAM_TASKS.md`).
- Need a change in someone else's section? Message them or open an Issue.
- Rule ORDER matters in ANTLR: keywords before IDENTIFIER, error rules last.
