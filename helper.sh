EDITOR_WHAT_IM_USIN_2DAY=codium

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

function c ()
{
    $EDITOR_WHAT_IM_USIN_2DAY "$@" &> /dev/null
}

function n ()
{
    $EDITOR_WHAT_IM_USIN_2DAY "$@" &> /dev/null
}

function note ()
{
    $EDITOR_WHAT_IM_USIN_2DAY "$@" &> /dev/null
}

function notepad ()
{
    $EDITOR_WHAT_IM_USIN_2DAY "$@" &> /dev/null
}

function gitk ()
{
    (/usr/bin/gitk "$@" &) > /dev/null
}

### utility
alias cgrep="grep -rIn"
alias ffind="find -iname"
alias sai="sudo apt-get install"
alias s="source ~/.bashrc"
alias t="tmux"

### overrides
# Colorize the ls output ##
alias ls='ls --color=auto'
