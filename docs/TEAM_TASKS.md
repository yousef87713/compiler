# Phase 1 - Team task split (5 members)

All grammar work happens in `src/main/antlr4/com/compilers/js/JSLexer.g4`.
Each section of the file has an owner, so everyone edits a different part.

| # | Owner area | Grammar section | Also responsible for |
|---|-----------|-----------------|----------------------|
| 1 | Project setup & integration | 8 - Whitespace | `Main.java`, build/run scripts, README, merging PRs, final integration |
| 2 | Keywords, operators, identifiers | 2, 3, 6, 7 | Tests in `LexerTest` for keywords/operators/identifiers |
| 3 | Numbers | 4 - Numbers | INTEGER, FLOAT, HEX, OCTAL, BINARY, BIGINT, numeric separators + tests |
| 4 | Strings & templates | 5 - Strings/Templates | Escapes, line continuation, template literal with nested `${ }` (lexer modes) + tests |
| 5 | Comments & errors | 1, 9 | `LexicalAnalyzer`, `LexErrorListener`, `TokenPrinter` (output format) + tests |

## Open questions to confirm with the lab instructors
- Exact output format: `[Text] - <Type: X> (Line:Column)` and the order Line:Column.
- Should comments be printed as tokens? (currently yes)
- Are columns 0-based or 1-based? (currently 1-based)
- Are regex literals (`/abc/g`) required? (currently not supported)

## Ideas for improvement (after the basics work)
- Template literals with nested `${ ... }` using `pushMode` / `popMode`.
- Regex literals (needs context: `/` after an identifier is division, after `=` or `(` is a regex).
- Unicode escapes inside identifiers (`\u0061bc`).
- Contextual keywords (`get`, `set`, `of`, `async`...) - decide how the parser will treat them in phase 2.
