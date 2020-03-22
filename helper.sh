PROGRAMS_DIR_DEFAULT="$HOME/Programs"
export PROGRAMS_DIR="${PROGRAMS_DIR:-$PROGRAMS_DIR_DEFAULT}"

EDITOR_DEFAULT="vi"
export EDITOR="${EDITOR:-$EDITOR_DEFAULT}"

function sortinput ()
{
	printf "\n=====================\n\n"
	echo "$@" | LC_COLLATE=C sort -u
}

function cx ()
{
	[ -f "$1" ] && {
		builtin cd "$(dirname "$1")";
	} || {
		builtin cd "$1";
	};
}

function vim ()
{
    # osx users, use stty -g
    local STTYOPTS="$(stty --save)"
    stty stop '' -ixoff
    command vim "$@"
    stty "$STTYOPTS"
}

function n ()
{
    code -g "$@" &> /dev/null
}

function note ()
{
    n -g "$@" &> /dev/null
}

function notepad ()
{
    n -g "$@" &> /dev/null
}

function gitk ()
{
    (/usr/bin/gitk "$@" &) > /dev/null
}

### utility
alias cgrep="grep -rIn"
alias ffind="find -iname"
alias sai="sudo apt-get install"
alias sbash="source ~/.bashrc"

### overrides
# Colorize the ls output ##
alias ls='ls --color=auto'

## Use a long listing format ##
alias cd=cd_func

### cds
alias cdwin="cd $WINHOME"
alias cdlin="cd $HOME"

function wcd
{
    echo $1 | sed 's/\\/\\\\/g' | xargs wslpath -u | xargs cd
}

