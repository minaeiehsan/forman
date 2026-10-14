#!/bin/sh
# Wire foreman into this machine. Safe to re-run.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"

# foreman/ is yours and git-ignored: fill in what is missing from foreman.example/, never overwrite.
(cd "$HERE/foreman.example" && find . -type f) | while read -r f; do
  [ -e "$HERE/foreman/$f" ] && continue
  mkdir -p "$(dirname "$HERE/foreman/$f")" && cp "$HERE/foreman.example/$f" "$HERE/foreman/$f"
done

mkdir -p "$HOME/.claude/skills"
if [ -e "$HOME/.claude/skills/foreman" ] && [ ! -L "$HOME/.claude/skills/foreman" ]; then
  echo "~/.claude/skills/foreman exists and is not a symlink; move it away and re-run." >&2; exit 1
fi
ln -sfn "$HERE/foreman" "$HOME/.claude/skills/foreman"

LINE="source \"$HERE/bin/fm.zsh\""
grep -qxF "$LINE" "$HOME/.zshrc" || printf '\n%s\n' "$LINE" >> "$HOME/.zshrc"

if command -v sbx >/dev/null 2>&1; then sbx skills import --force >/dev/null 2>&1 || true; fi

echo "foreman installed. Open a new terminal or run: source ~/.zshrc"
