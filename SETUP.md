# Set up foreman from your history

Instructions for a coding assistant (Claude Code, Codex, Cursor, Gemini CLI, ...). Run from this repo, before `./install.sh`:

```sh
claude "Follow SETUP.md"      # or: codex "Follow SETUP.md"
```

## Goal

Build the user's own `foreman/` from `foreman.example/`: every file filled with real content about how this user works, learned from their local assistant history. Each example file says what goes in it and shows one example.

## 1. Start

Copy `foreman.example/` to `foreman/`, skipping files that already exist. `foreman/` is git-ignored; it is the only place you write.

## 2. Read (read-only, skip what doesn't exist)

| Source | Where |
|---|---|
| Claude Code | `~/.claude/CLAUDE.md`, `~/.claude/projects/*/memory/*.md`, `~/.claude/skills/*/SKILL.md`, user prompts in `~/.claude/projects/*/*.jsonl` |
| Codex | `~/.codex/AGENTS.md`, user prompts in `~/.codex/sessions/**/*.jsonl` |
| Others | `~/.gemini/GEMINI.md`, `~/.cursor/rules/`, `.cursorrules` |
| Projects | `CLAUDE.md`, `AGENTS.md`, `.github/copilot-instructions.md`, README setup and check commands in repos the sessions worked in |
| Git | `git remote -v`, the user's own recent commits and PR titles in those repos |

Use the last ~3 months. Read what the user typed, not assistant output.

## 3. Fill every file

| File | From |
|---|---|
| `context.md` | GitHub org, ticket tracker and URL pattern, chat workspace and channels, observability tool, repos with what they own and their setup and check commands |
| `me/rules.md` | corrections and bans: "never", "don't", "stop", "always", things they rejected |
| `me/tone.md` | complaints about length, format, wording; how they write themselves |
| `me/style.md` | code review remarks, conventions repeated across repos |
| `me/learned.md` | empty: just `# Learned` and `last learn: never` |
| `modes/*.md` | how they actually do each job in past sessions: what they read first on a new ticket, how they review, what they check before a PR, how they want messages drafted, what a handoff needs |
| `modes/pr.md` | branch, commit and PR patterns from git history |
| `templates/TASK.md` | the sections their task notes and plans keep using |
| `SKILL.md` | keep the frontmatter (`name: foreman`); route `$ARGUMENTS` to the modes; say which files to load first |

Replace the two placeholder lines in each file. Keep only what shows up more than once or was said strongly. Short lines, each with its why. Nothing found: keep a plain, generic version and say so.

## 4. Hand over for review

- Never edit `foreman.example/`, never commit or push.
- Leave out secrets, tokens, customer names and personal data. When unsure, ask.
- End with a table: file, what it now says in one line, source it came from, confidence. Then tell the user to review the files and run `./install.sh`.
