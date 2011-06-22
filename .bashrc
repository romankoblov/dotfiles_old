# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# MySQL stuff
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib/
export PATH=$PATH:/usr/local/mysql/bin

# ls colors
#export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export LSCOLORS=fxfxcxdxbxegedabagacad
if [ "$OS" = "linux" ] ; then
# For linux, etc
  alias ls='ls --color=auto -F'
  alias ll='ls --color=auto -lhF'
else
# OS-X SPECIFIC - the -G command in OS-X is for colors, in Linux it's no groups
  alias ls='ls -FG'
  alias ll="ls -lhFG"   
fi

# HISTORY
export HISTCONTROL=ignoreboth
export HISTSIZE=1000

# Aliases
alias reload='source ~/.bashrc'
alias exit='history -a && exit'

# Env variables
export EDITOR=nano
export PAGER=less

# Virtual Env
WORKON_HOME=$HOME/environments
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
	source /usr/local/bin/virtualenvwrapper.sh
fi
# MacOS
if [ -f /opt/local/etc/bash_completion ]; then
	source /opt/local/etc/bash_completion
fi
# Linux
if [ -f /etc/bash_completion ]; then
	source /etc/bash_completion
fi

# Promt
# Colors
if [ -f ~/dotfiles/colors ]; then
	source ~/dotfiles/colors
fi

# Branch
parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}


# Different color for each host
host_color=`~/dotfiles/host_color.py`


# Append last command to history
#PROMPT_COMMAND='history -a;'
_update_prompt () {
    #history -a
    local exit="$?"
    `history -a`
    ## Color based on exit code
    local bul=">" # bullet character
    case "$exit" in
      "0" )  ex="$txtgrn$bul$txtrst " ;;
      *   )  ex="$txtred$bul$txtrst "  ;;
    esac
    # Branch text generating
    branch="$(parse_git_branch)"
    if [ -n "$branch" ] ; then
        ## Assumes that untracked files are always listed after modified ones
        ## True for all git versions I could find
        git status --porcelain | perl -ne 'exit(1) if /^ /; exit(2) if /^[?]/'
        case "$?" in
            "0" )  branch=" $txtgrn($branch)$txtrst"   ;; 
            "1" )  branch=" $bldred($branch)$txtrst"    ;; 
            "2" )  branch=" $bldylw($branch)$txtrst" ;;
            "130" ) branch=" $txtwht($branch)$txtrst" ; _dumb_prompt=1 ;; 
        esac
    fi
    # User
    local user=""
    if [[ "$USER" != "penpen" ]]; then
        if [ "$UID" = "0" ]; then
            local user="$txtred\u$txtrst@"
        else
            local user="$txtgrn\u$txtrst@"
        fi
    fi
    local host="$host_color\h$txtrst"
    # Virtual env
    local virtual=""
    if [ -n "$VIRTUAL_ENV" ] ; then
        local venv="`basename \"$VIRTUAL_ENV\"`"
        local virtual=" $bldwht[$venv]$txtrst"
    fi
    export PS1="$user$host:$txtblu\W$txtrst$branch$virtual $ex";
}
PROMPT_COMMAND='_update_prompt'
