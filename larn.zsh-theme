# Title: Larn
# Description: Custom oh my zsh theme with Git integration and colored prompt
# Copyright (c) 2025 Bin Hua <https://tourcoder.com>

# Color configuration (for dark terminal)
local BLUE='%F{75}'       # Path, brackets, and arrow
local ORANGE='%F{214}'    # Default Git branch
local YELLOW='%F{226}'    # Git status and dev branch
local WHITE='%F{255}'     # Separator ::
local MAIN_GREEN='%F{40}' # Main/master branch
local RESET='%f'

# Get current Git branch
parse_git_branch() {
  git symbolic-ref --short HEAD 2>/dev/null
}

# Get Git status (+ modified, * staged, ! conflict)
parse_git_status() {
  git rev-parse --is-inside-work-tree &>/dev/null || return
  local changes=$(git status --porcelain 2>/dev/null)
  local git_state=""
  [[ "$changes" == *M* || "$changes" == *A* || "$changes" == *D* ]] && git_state+="*"
  [[ "$changes" == *\?* ]] && git_state+="+"
  [[ "$changes" == *U* ]] && git_state+="!"
  echo "$git_state"
}

# Set branch color based on branch name
get_branch_color() {
  local branch=$(parse_git_branch)
  case $branch in
    main|master) echo "${MAIN_GREEN}" ;;
    dev) echo "${YELLOW}" ;;
    feature-*) echo "${BLUE}" ;;
    *) echo "${ORANGE}" ;;
  esac
}

# Check if in Git repository
is_git_repo() {
  git rev-parse --is-inside-work-tree &>/dev/null
}

# Set prompt
set_prompt() {
  if is_git_repo; then
    PROMPT='${BLUE}[%~${WHITE} :: ${RESET}$(get_branch_color)$(parse_git_branch)${YELLOW}$(parse_git_status)${BLUE}] ${BLUE}➜ ${RESET}'
  else
    PROMPT='${BLUE}[%~] ${BLUE}➜ ${RESET}'
  fi
}

# Call set_prompt before each prompt
precmd() { set_prompt }

# Disable right prompt
RPROMPT=''

# Enable color support
autoload -U colors && colors

# Set ls colors
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  export CLICOLOR=1
  export LSCOLORS="ExFxCxDxBxegedabagacad"
  alias ls='ls -G'
else
  # Linux
  export LS_COLORS='di=1;34:ln=36:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:fi=0'
  alias ls='ls --color=auto'
fi
