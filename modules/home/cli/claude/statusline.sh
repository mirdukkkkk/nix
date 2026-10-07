input=$(cat)
NOW=$EPOCHSECONDS

eval "$(jq -r '@sh "
  DIR=\(.workspace.current_dir)
  ADDED=\(.cost.total_lines_added // 0)
  REMOVED=\(.cost.total_lines_removed // 0)
  CTX_RAW=\(.context_window.used_percentage // 0)
  RAW_RATE_PCT=\(.rate_limits.five_hour.used_percentage // "")
  RAW_RATE_RESETS=\(.rate_limits.five_hour.resets_at // "")
"' <<<"$input")"
CTX_PCT=${CTX_RAW%%.*}

# rate_limits is absent until the first API response of the session
# (account-wide, not per-session) — cache the last known value so the
# bar doesn't flash 0% at every session start.
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/claude-statusline"
CACHE_FILE="$CACHE_DIR/rate_limit"
if [ -n "$RAW_RATE_PCT" ]; then
    RATE_PCT=${RAW_RATE_PCT%%.*}
    RATE_RESETS_AT="$RAW_RATE_RESETS"
    mkdir -p "$CACHE_DIR"
    printf '%s %s\n' "$RATE_PCT" "$RATE_RESETS_AT" > "$CACHE_FILE"
elif [ -f "$CACHE_FILE" ]; then
    read -r RATE_PCT RATE_RESETS_AT < "$CACHE_FILE"
    # Cached window already reset — stale % no longer valid, and the
    # new window's reset time is unknown until fresh data arrives.
    if [ -n "$RATE_RESETS_AT" ] && [ "$RATE_RESETS_AT" -le "$NOW" ]; then
        RATE_PCT=0
        RATE_RESETS_AT=""
        rm -f "$CACHE_FILE"
    fi
else
    RATE_PCT=0
    RATE_RESETS_AT=""
fi

GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; DIM='\033[2m'; RESET='\033[0m'
WHITE='\033[97m'; BRIGHT_BLUE='\033[94m'

# Green under 70%, yellow 70-89%, red 90%+ — used for both bar fills.
bar_color() {
    local pct=$1
    if [ "$pct" -ge 90 ]; then printf '%s' "$RED"
    elif [ "$pct" -ge 70 ]; then printf '%s' "$YELLOW"
    else printf '%s' "$GREEN"; fi
}

make_bar() {
    local pct=$1 width=${2:-10}
    local scaled=$((pct * width))
    local filled=$((scaled / 100))
    local rem=$((scaled % 100))
    local half=0
    # Boundary half-block when the fill lands mid-cell, for finer
    # resolution than one block per width step.
    [ "$rem" -ge 50 ] && [ "$filled" -lt "$width" ] && half=1
    local empty=$((width - filled - half))
    local fill="" pad="" half_char=""
    [ "$filled" -gt 0 ] && printf -v fill '%*s' "$filled" ""
    [ "$empty" -gt 0 ] && printf -v pad '%*s' "$empty" ""
    [ "$half" -eq 1 ] && half_char="▒"
    printf '%s%s%s' "${fill// /▓}" "$half_char" "${pad// /░}"
}

# White below 80%, orange 80-89%, red 90%+.
# Claude Code's statusline renderer doesn't support 24-bit truecolor
# (washes out to gray) — use 256-color codes instead.
rate_pct_color() {
    local pct=$1
    if [ "$pct" -lt 80 ]; then
        printf '%s' "$WHITE"
    elif [ "$pct" -lt 90 ]; then
        printf '\033[38;5;208m'
    else
        printf '\033[38;5;196m'
    fi
}

if [ -n "$RATE_RESETS_AT" ]; then
    REMAIN=$((RATE_RESETS_AT - NOW))
    [ "$REMAIN" -lt 0 ] && REMAIN=0
    RESETS_TEXT="resets $((REMAIN / 3600))h $(((REMAIN % 3600) / 60))m"
else
    RESETS_TEXT="time to code"
fi

DIR_DISPLAY=$DIR
case "$DIR" in
    "$HOME"/*) DIR_DISPLAY="~${DIR#"$HOME"}" ;;
    "$HOME") DIR_DISPLAY="~" ;;
esac

# Empty outside a repo; falls back to the short hash on a detached HEAD.
BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null || true)
if [ -z "$BRANCH" ]; then
    BRANCH=$(git -C "$DIR" rev-parse --short HEAD 2>/dev/null || true)
fi

LINE="${WHITE}[${RESET}$(bar_color "$RATE_PCT")$(make_bar "$RATE_PCT")${RESET}${WHITE}]${RESET} $(rate_pct_color "$RATE_PCT")${RATE_PCT}%${RESET} ${DIM}-${RESET} ${WHITE}${RESETS_TEXT}${RESET}"
LINE="$LINE ${DIM}|${RESET} $(bar_color "$CTX_PCT")$(make_bar "$CTX_PCT" 12)${RESET} ${WHITE}${CTX_PCT}%${RESET}"
LINE="$LINE ${DIM}|${RESET} ${YELLOW}${DIR_DISPLAY}${RESET}"
[ -n "$BRANCH" ] && LINE="$LINE ${BRIGHT_BLUE}($BRANCH)${RESET}"
LINE="$LINE ${DIM}|${RESET} ${GREEN}+${ADDED}${RESET}/${RED}-${REMOVED}${RESET}"

echo -e "$LINE"
