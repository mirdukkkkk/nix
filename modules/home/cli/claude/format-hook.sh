# PostToolUse hook: format the file Claude just edited.
# .nix files go through nixfmt; anything else goes through the project's
# own prettier, but only when a package.json above it declares prettier
# (the nearest one wins, so monorepo roots work too).
file=$(jq -r '.tool_input.file_path // empty')
[ -f "$file" ] || exit 0

case "$file" in
  *.nix)
    nixfmt "$file" >/dev/null 2>&1 || true
    exit 0
    ;;
esac

dir=$(dirname "$file")
while [ "$dir" != "/" ]; do
  if [ -f "$dir/package.json" ]; then
    if jq -e '.prettier or .dependencies.prettier or .devDependencies.prettier' "$dir/package.json" >/dev/null 2>&1 \
      && [ -x "$dir/node_modules/.bin/prettier" ]; then
      (cd "$dir" && node_modules/.bin/prettier --write --ignore-unknown "$file" >/dev/null 2>&1) || true
      exit 0
    fi
  fi
  dir=$(dirname "$dir")
done
exit 0
