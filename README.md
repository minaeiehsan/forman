<p align="center"><img src="assets/logo.svg" alt="foreman" width="560"></p>

# foreman

Paste a work item, get a task dir, a plan, and drafts. Nothing runs until you say `go`.

```
set up once:   clone → assistant fills foreman/ → you review → ./install.sh
every task:    fmz <link> → plan → go → design / review / msg → pr → learn
```

The repo ships `foreman.example/`: a skeleton where each file says what belongs in it. Your own copy lives in `foreman/`, which git ignores, so your rules, context and internal work never get pushed.

## Set up (once)

### What to install

| Need | What | Get it |
|---|---|---|
| required | Claude Code (`claude`) | [Quickstart](https://code.claude.com/docs/en/quickstart) · [Skills](https://code.claude.com/docs/en/skills) |
| required | zsh (default on macOS) | [macOS: make zsh default](https://support.apple.com/en-us/102360) · [Linux: install zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH) |
| recommended | GitHub CLI (`gh`), then `gh auth login` | [Install](https://cli.github.com/manual/installation) · [auth login](https://cli.github.com/manual/gh_auth_login) |
| recommended | Connectors for the tools you use (MCP) | [In Claude Code](https://code.claude.com/docs/en/mcp) · [Claude connectors](https://support.claude.com/en/articles/11175166-getting-started-with-custom-connectors-using-remote-mcp) |
| | ↳ Linear · Slack · Datadog · Notion · Figma · Miro | [Linear](https://linear.app/docs/mcp) · [Slack](https://docs.slack.dev/ai/mcp-server) · [Datadog](https://docs.datadoghq.com/mcp_server/setup/) · [Notion](https://developers.notion.com/docs/mcp) · [Figma](https://help.figma.com/hc/en-us/articles/32132100833559) · [Miro](https://developers.miro.com/docs/miro-mcp) |
| optional | Codex, to run `SETUP.md` with it instead | [openai/codex](https://github.com/openai/codex) |
| optional | An editor with a shell command, for `fmz` / `fmc` / `fmv` / `fm -e` | [Zed](https://zed.dev) · [Cursor](https://cursor.com) · [VS Code `code`](https://code.visualstudio.com/docs/configure/command-line) · Claude inside it: [VS Code](https://code.claude.com/docs/en/vs-code), [JetBrains](https://code.claude.com/docs/en/jetbrains), [Zed](https://zed.dev/docs/ai/external-agents) |
| optional | Docker Sandboxes (`sbx`), for `fm -s` | [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/) |

A missing connector is reported in the task, never guessed.

### Steps

1. **Clone** where it will stay. The install links to this folder, so moving it later breaks the link.
   ```sh
   git clone https://github.com/minaeiehsan/forman.git ~/foreman && cd ~/foreman
   ```
2. **Fill.** Your coding assistant (Claude Code or Codex) copies `foreman.example/` to `foreman/`, reads your local history (sessions, memory, CLAUDE.md / AGENTS.md, git) and fills every file: context, rules, tone, style, modes, task template. It writes only inside `foreman/` and never commits.
   ```sh
   claude "Follow SETUP.md"      # or: codex "Follow SETUP.md"
   ```
3. **Review** the files in `foreman/`. The assistant ends with a table of what each file says and where it came from. Edit anything; see [Change it](#change-it).
4. **Install**, then open a new terminal.
   ```sh
   ./install.sh
   ```
   Links `foreman/` into `~/.claude/skills`, adds one `source` line to `~/.zshrc` (that gives you `fm`, `fmz`, `fmc`, `fmv`), and imports the skill into Docker Sandboxes if `sbx` is installed. Safe to re-run; it never overwrites your files. Skipped step 2? It copies `foreman.example/` first so you can fill it by hand.

## Work a task

1. **Start** with one command:
   ```sh
   fmz https://linear.app/<workspace>/issue/ABC-123
   ```
   Creates `~/Desktop/abc-123/`, opens it in Zed, starts Claude in your terminal with `/foreman <link>`. Claude reads the link and one hop out (linked PRs, threads, errors), writes `TASK.md`, and replies with the task type and a numbered plan. Nothing else runs.

   | Launcher | Opens |
   |---|---|
   | `fm <link>` | Claude only |
   | `fmz <link>` / `fmc <link>` / `fmv <link>` | Zed / Cursor / VS Code + Claude |
   | `fm -e <editor> <link>` | any other editor with a shell command + Claude |
   | `fm -s <link>` | Claude in a Docker Sandbox ([optional](#sandbox-optional)); combines: `fmz -s <link>` |
   | `/foreman <link>` | inside a Claude session that is already open |

   Slugs come from the link: Linear ID, `<repo>-pr-<n>`, Datadog issue; anything else asks for a name. Always want an editor: `export FOREMAN_EDITOR=zed` in `~/.zshrc`. Tasks somewhere else than `~/Desktop`: `export FOREMAN_TASKS=~/tasks`.

2. **Steer** in the same session:

   | Command | Does |
   |---|---|
   | `/foreman go 1 3` · `go all` | run those plan steps; local changes only, then checks |
   | `/foreman design` | 2 or 3 options, pick one, implementation steps into TASK.md |
   | `/foreman review [pr]` | review a PR, or weigh the comments on yours; never posts |
   | `/foreman msg <what>` | draft `slack-<topic>.txt`; never sends |
   | `/foreman pr` | branch, commit, push, open the PR to your spec |
   | `/foreman handoff` | a prompt so a fresh session can continue |

   Plain requests work too; foreman keeps TASK.md current either way.

3. **Leave and come back**: `fm` (or `fmz`) inside `~/Desktop/<slug>/` reads TASK.md and gives you state and next step.

4. **Correct it** when it's wrong ("too long", "never do X"). Each correction becomes a line in `foreman/me/learned.md`. Run `/foreman learn` now and then to move stable ones into your rules, tone or style.

Every task lives in `~/Desktop/<slug>/TASK.md`: deliverable on top, plan and handoff below.

## Change it

| To change | Edit |
|---|---|
| a behaviour | `foreman/modes/<mode>.md` |
| a new behaviour | add `foreman/modes/<name>.md` + one row in `foreman/SKILL.md` |
| hard rules | `foreman/me/rules.md` |
| writing voice | `foreman/me/tone.md` |
| code / review conventions | `foreman/me/style.md` |
| repos, tools, links | `foreman/context.md` |
| task doc shape | `foreman/templates/TASK.md` |

Edits are live in the next Claude session (the skill is a symlink). `foreman.example/` stays a two-line skeleton per file.

## Update and remove

- **Update**: `git pull`, then `./install.sh` to pick up new example files. Your files are never overwritten.
- **Remove**: `./uninstall.sh` takes out the symlink, the `source` line and the sandbox skill. The repo and your `foreman/` stay.

## Sandbox (optional)

Run a task inside a Docker Sandbox with `fm -s <link>`. Skip this if you don't use sandboxes.

Needs only `sbx` (the Docker Sandboxes CLI) on the PATH. With it installed:
- `./install.sh` imports foreman into sandboxes. Check with `sbx skills ls`. Installed `sbx` later? Re-run `./install.sh`.
- `fm.zsh` gives you `sclaude`: Claude in a sandbox named `claude-<dir>`, reused when it exists, with the GitHub SSH and commit-signing kits. If you already have your own `sclaude`, yours is used.

`fm -s` re-imports skills on every start, so edits to `foreman/` reach new sandboxes. Inside a sandbox `me/learned.md` is read-only: corrections go under `## Learned` in TASK.md, and `/foreman learn` collects them later.

## Repo layout

| Path | What | In git |
|---|---|---|
| `foreman.example/` | skeleton: each file says what goes in it | yes |
| `foreman/` | your filled copy, linked into Claude | no |
| `SETUP.md` | instructions for the coding assistant (Claude Code or Codex) that fills `foreman/` | yes |
| `bin/fm.zsh` | `fm`, `fmz`, `fmc`, `fmv`, `sclaude` | yes |
| `install.sh` · `uninstall.sh` | wire up / undo | yes |
| `assets/logo.svg` | logo | yes |
