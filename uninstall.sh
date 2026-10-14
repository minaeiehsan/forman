#!/bin/sh
# Undo install.sh. Leaves this repo and your foreman/ folder untouched. Safe to re-run.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"

LINK="$HOME/.claude/skills/foreman"
if [ -L "$LINK" ] && [ "$(readlink "$LINK")" = "$HERE/foreman" ]; then rm "$LINK"
elif [ -e "$LINK" ]; then echo "skipped $LINK: not our symlink"
fi

LINE="source \"$HERE/bin/fm.zsh\""
if [ -f "$HOME/.zshrc" ] && grep -qxF "$LINE" "$HOME/.zshrc"; then
  TMP="$(mktemp)"
  grep -vxF "$LINE" "$HOME/.zshrc" > "$TMP" || true
  cat "$TMP" > "$HOME/.zshrc" && rm "$TMP"
fi

if command -v sbx >/dev/null 2>&1 && sbx skills ls 2>/dev/null | grep -q '^foreman '; then
  sbx skills rm --force foreman >/dev/null 2>&1 || true
fi

echo "foreman uninstalled. Open a new terminal or run: unfunction fm fmz fmc fmv _fm_slug"
