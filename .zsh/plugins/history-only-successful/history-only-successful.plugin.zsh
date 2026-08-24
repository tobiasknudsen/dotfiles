# history-only-successful.plugin.zsh
#
# Only save successful commands to $HISTFILE.
# Failed commands stay in the CURRENT session's in-memory history
# (so up-arrow still recalls them for fixing), but disappear when
# the session ends. New shells only see commands that exited 0.

autoload -Uz add-zsh-hook
zmodload zsh/datetime 2>/dev/null

# Don't let zsh auto-append every command to $HISTFILE.
# We persist manually in precmd, only on success.
unsetopt INC_APPEND_HISTORY 2>/dev/null
unsetopt INC_APPEND_HISTORY_TIME 2>/dev/null
unsetopt SHARE_HISTORY 2>/dev/null

# Commands whose non-zero exit shouldn't count as "failed".
# grep/rg/ag/diff/cmp legitimately return non-zero on "no match".
typeset -ga _HIST_ALWAYS_SAVE_CMDS=(
  grep egrep fgrep rg ag ack
  diff cmp
  test '['
)

_hist_pending_command=""

# Runs BEFORE the command executes.
# return 2 = add to in-memory history but do NOT write to $HISTFILE.
zshaddhistory() {
  _hist_pending_command="${1%$'\n'}"
  return 2
}

# Runs AFTER the command finishes, before the next prompt.
_hist_persist_if_successful() {
  local exit_code=$?
  local cmd="$_hist_pending_command"
  _hist_pending_command=""

  [[ -z "$cmd" ]] && return

  if (( exit_code != 0 )); then
    local first_word="${${(z)cmd}[1]}"
    if [[ ${_HIST_ALWAYS_SAVE_CMDS[(Ie)$first_word]} -eq 0 ]]; then
      return
    fi
  fi

  # Encode embedded newlines the way zsh does for multi-line entries.
  local encoded="${cmd//$'\n'/\\$'\n'}"
  if [[ -o EXTENDED_HISTORY ]]; then
    print -r -- ": ${EPOCHSECONDS}:0;${encoded}" >> "$HISTFILE"
  else
    print -r -- "$encoded" >> "$HISTFILE"
  fi
}
add-zsh-hook precmd _hist_persist_if_successful
