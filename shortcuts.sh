#!/usr/bin/env bash

# Python venv activator / creator
vvv () {
  local venv_dir="${1:-venv}"
  if [[ ! -d "$venv_dir" && -d ".venv" && "$venv_dir" == "venv" ]]; then
    venv_dir=".venv"
  fi

  if [[ ! -d "$venv_dir" ]]; then
    python3 -m venv "$venv_dir"
  fi

  if [[ -f "${venv_dir}/bin/activate" ]]; then
    # shellcheck disable=SC1090
    source "${venv_dir}/bin/activate"
  else
    echo "Error: ${venv_dir}/bin/activate not found" >&2
    return 1
  fi
}

textbanner () {
  local text="$1"
  if [[ -d "$HOME/git/pppppprint/" ]]; then
    echo "[=]$text" | python3 "$HOME/git/pppppprint/print.py" "$(tput cols 2>/dev/null || echo 80)"
  elif command -v toilet >/dev/null 2>&1; then
    toilet -f pagga "$text"
  elif command -v figlet >/dev/null 2>&1; then
    figlet "$text"
  else
    echo "=== $text ==="
  fi
}

# Search with ripgrep if available, otherwise fallback to grep with ignored folders
ggg () {
  local search="$1"
  if [[ -z "$search" ]]; then
    echo "Usage: ggg <search-term>" >&2
    return 1
  fi
  textbanner "gggrep: $search"
  if command -v rg >/dev/null 2>&1; then
    rg -i "$search"
  else
    grep -RliI --exclude-dir={.git,node_modules,.next,.sass-cache,build,public,__pycache__,tmp,db,test,.gems,spec,vendor,log,coverage,data,cache} "$search" . 2>/dev/null | xargs -I {} grep -ioH ".\{0,10\}${search}.\{0,10\}" {} 2>/dev/null
  fi
}

# Generates n lines of pseudo-text, defaults to 20 lines
lorem () {
  local lines="${1:-20}"
  LC_CTYPE=C tr -dc 'a-z1-4' </dev/urandom 2>/dev/null | tr '1-2' ' \n' | awk 'length==0 || length>50' | tr '3-4' ' ' | sed 's/^ *//' | cat -s | fmt | head -n "$lines"
}

# Flush DNS cache (macOS)
flushdns () {
  if sudo killall -HUP mDNSResponder; then
    textbanner "DNS: done"
  fi
}
alias cleardns='flushdns'

# Navigate to git repository root
gitroot () {
  local root
  root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Error: Not inside a git repository" >&2
    return 1
  }
  cd "$root" || return 1
}

# Delete local branches that have been removed on remote (gone)
gitprune () {
  git fetch -p
  local branches
  branches="$(git branch -vv | awk '/: gone]/ {print $1}')"
  if [[ -n "$branches" ]]; then
    echo "$branches" | xargs git branch -d
  else
    echo "No pruned branches to delete."
  fi
}

# Delete local branches that are already merged
cleanbranches () {
  local branches
  branches="$(git branch --merged | grep -v '^\*' | grep -v -E '^(main|master|stage)$' | awk '{$1=$1};1')"
  if [[ -n "$branches" ]]; then
    echo "$branches" | xargs git branch -d
  else
    echo "No merged local branches to delete."
  fi
}

# Pull latest current branch and merge master/main
uu () {
  local default_branch
  default_branch="$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')"
  default_branch="${default_branch:-master}"

  git fetch -p && git pull && git pull origin "$default_branch"
}

# Show commit age for remote branches using fast git plumbing
remotecommitsage () {
  textbanner "$(basename "$PWD") remotes @ $(date)"
  git for-each-ref --sort=-committerdate --format="%(committerdate:relative)%09%(refname:short)" refs/remotes/origin/
}

# Show diff for copied commit hash and its parent
viewlastdiff () {
  if ! command -v pbpaste >/dev/null 2>&1; then
    echo "Error: pbpaste not found" >&2
    return 1
  fi
  local comhash
  comhash="$(pbpaste | tr -d '[:space:]')"
  if [[ -n "$comhash" ]]; then
    git diff "${comhash}~1" "$comhash"
  else
    echo "Error: Clipboard does not contain a commit hash" >&2
    return 1
  fi
}

# CPU core count helper (if nproc is not built-in)
if ! command -v nproc >/dev/null 2>&1; then
  nproc () {
    sysctl -n hw.logicalcpu 2>/dev/null || sysctl -n hw.physicalcpu 2>/dev/null || echo 1
  }
fi

dearkitty () {
  if [[ -x "$HOME/git/kitty/dearkitty" ]]; then
    KITTY_BASE="$HOME/git/kitty" "$HOME/git/kitty/dearkitty" "$@"
  else
    echo "Error: ~/git/kitty/dearkitty not found" >&2
    return 1
  fi
}

alias ts='date +"%A %Y-%m-%d @ %H:%M"'
