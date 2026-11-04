#!/bin/bash
input=$(cat)

model=$(printf '%s' "$input" | jq -r '.model.display_name')
dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir')
folder=$(basename "$dir")
branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null)

ctx_used=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
five_pct=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
effort=$(printf '%s' "$input" | jq -r '.effort.level // empty')
cache_warm=$(printf '%s' "$input" | jq -r '.prompt_cache.warm // empty')
cache_expires=$(printf '%s' "$input" | jq -r '.prompt_cache.expires_at // empty')

time_left() {
  local reset_epoch now diff days hours minutes
  reset_epoch="${1%.*}"
  now=$(date +%s)
  diff=$(( reset_epoch - now ))
  [ "$diff" -lt 0 ] && diff=0
  days=$(( diff / 86400 ))
  hours=$(( (diff % 86400) / 3600 ))
  minutes=$(( (diff % 3600) / 60 ))
  if [ "$days" -gt 0 ]; then printf '%dd%dh' "$days" "$hours"; else printf '%dh%dm' "$hours" "$minutes"; fi
}

CYAN='\033[96m'; MAGENTA='\033[95m'; GRAY='\033[90m'; RESET='\033[0m'

line1="${CYAN}${folder}${RESET}"
[ -n "$branch" ] && line1="$line1 ${MAGENTA}(${branch})${RESET}"

line2="${GRAY}${model}"
[ -n "$effort" ] && line2="$line2 (${effort})"
if [ -n "$ctx_used" ]; then
  filled=$(awk -v p="$ctx_used" 'BEGIN{n=int(p/10+0.5); if(n>10)n=10; if(n<0)n=0; print n}')
  bar=""
  for ((i = 0; i < filled; i++)); do bar+="█"; done
  for ((i = filled; i < 10; i++)); do bar+="░"; done
  line2="$line2  ${bar} $(printf '%.0f' "$ctx_used")%"
fi
if [ "$cache_warm" = "true" ] && [ -n "$cache_expires" ]; then
  line2="$line2  cache $(time_left "$cache_expires")"
fi
if [ -n "$five_pct" ] && [ -n "$five_reset" ]; then
  five_left=$(awk -v p="$five_pct" 'BEGIN{printf "%.0f", 100-p}')
  line2="$line2  5h: ${five_left}% ($(time_left "$five_reset"))"
fi
if [ -n "$week_pct" ] && [ -n "$week_reset" ]; then
  week_left=$(awk -v p="$week_pct" 'BEGIN{printf "%.0f", 100-p}')
  line2="$line2  7d: ${week_left}% ($(time_left "$week_reset"))"
fi
line2="$line2${RESET}"

printf '%b\n%b\n' "$line1" "$line2"
