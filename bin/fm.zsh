# foreman launcher
#   fm <link|text>      new task dir on ~/Desktop, start claude with /foreman
#   fm -s <link|text>   same, inside a Docker sandbox (sclaude)
#   fm                  resume in the current task dir
#   fm -e zed <link>    also open the task dir in an editor (zed, cursor, code); default: $FOREMAN_EDITOR
#   fmz / fmc / fmv     shortcuts for -e zed / -e cursor / -e code

FOREMAN_TASKS="${FOREMAN_TASKS:-$HOME/Desktop}"

# Claude in a Docker Sandbox named after cwd; reuse it if it exists. Your own sclaude wins.
if (( ! $+functions[sclaude] )); then
  sclaude() {
    local name="claude-$(basename "$PWD")"
    if sbx ls 2>/dev/null | grep -q "^${name}\b"; then
      sbx run --name "$name" "$@"
    else
      sbx run --kit "git+https://github.com/docker/sbx-kits-contrib.git#dir=git-ssh-sign" \
              --kit "git+https://github.com/docker/sbx-kits-contrib.git#dir=github-ssh" claude "$@"
    fi
  }
fi

_fm_slug() {
  local in="$1"
  if [[ "$in" =~ 'linear\.app/[^/]+/issue/([A-Za-z]+-[0-9]+)' ]]; then print -r -- "${(L)match[1]}"
  elif [[ "$in" =~ 'github\.com/[^/]+/([^/]+)/pull/([0-9]+)' ]]; then print -r -- "${match[1]}-pr-${match[2]}"
  elif [[ "$in" =~ 'error-tracking/issue/([0-9a-f]{8})' ]]; then print -r -- "dd-${match[1]}"
  elif [[ "$in" =~ '^([A-Za-z]+-[0-9]+)$' ]]; then print -r -- "${(L)match[1]}"
  fi
}

fm() {
  local sandbox=0 editor="$FOREMAN_EDITOR" prompt="/foreman" slug fallback
  while [[ "$1" == -[se] ]]; do
    case "$1" in
      -s) (( $+commands[sbx] )) || { print -u2 "fm -s needs sbx (Docker Sandboxes CLI)"; return 1; }
          sandbox=1; shift ;;
      -e) editor="$2"; shift 2 ;;
    esac
  done

  if [[ -n "$*" ]]; then
    slug="$(_fm_slug "$*")"
    if [[ -z "$slug" ]]; then
      fallback="task-$(date +%m%d-%H%M)"
      read "slug?dir name [$fallback]: "
      slug="${${slug:-$fallback}// /-}"
    fi
    mkdir -p "$FOREMAN_TASKS/$slug" && cd "$FOREMAN_TASKS/$slug" || return
    prompt="/foreman $*"
  fi

  if [[ -n "$editor" ]]; then
    if (( $+commands[$editor] )); then "$editor" .; else print -u2 "fm: editor '$editor' not found, skipping"; fi
  fi

  if (( sandbox )); then
    sbx skills import --force >/dev/null 2>&1
    sclaude -- "$prompt"
  else
    claude "$prompt"
  fi
}

fmz() { fm -e zed "$@" }
fmc() { fm -e cursor "$@" }
fmv() { fm -e code "$@" }
