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
alias ta="tmux a -t"
### overrides
# Colorize the ls output ##
alias ls='ls --color=auto'

### toolchains (each only if installed on this machine)
[ -d /opt/devkitpro ] && {
    export DEVKITPRO=/opt/devkitpro
    export DEVKITARM=/opt/devkitpro/devkitARM
    export DEVKITPPC=/opt/devkitpro/devkitPPC
}
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# .NET SDK (installed via dotnet-install.sh to ~/.dotnet)
if [ -d "$HOME/.dotnet" ]; then
    export DOTNET_ROOT="$HOME/.dotnet"
    case ":$PATH:" in
      *":$DOTNET_ROOT:"*) ;;
      *) export PATH="$DOTNET_ROOT:$DOTNET_ROOT/tools:$PATH" ;;
    esac
fi
[ "$(hostname)" = box ] && export CARGO_TARGET_DIR=/tmp/ct_zero-layers

### docker: your own rootless daemon where there is one; system services use sudo docker / claude-admin
[ -S "/run/user/$(id -u)/docker.sock" ] && export DOCKER_HOST="unix:///run/user/$(id -u)/docker.sock"

### claude: cl = plain; 2 = second account (~/.claude-2, login kept alive by /srv/infra/tools/creds-sync.py);
### dang*/dangeresque* = --dangerously-skip-permissions. All of them run as you; none of them has root.
alias cl='claude'
alias cl2='CLAUDE_CONFIG_DIR=$HOME/.claude-2 claude'
alias dang='claude --dangerously-skip-permissions'
alias dangeresque='dang'
alias dang2='CLAUDE_CONFIG_DIR=$HOME/.claude-2 claude --dangerously-skip-permissions'
alias dangeresque2='dang2'

### Root leases (/srv/infra/tools/lease.py): let one machine's sessions use root on other machines for a while.
###   lease il lenovo,desktop-ubuntu 12h      unlease il [lenovo]      leases
### Asks for your password once (sudo on box). While a lease is active, sessions on <from> run root commands
### with `ssh <to>-root ...`; it ends by itself. Without a lease, root anywhere needs your password.
_lease() {
    if [ "$(hostname)" = box ]; then sudo -u claude-admin -H /srv/infra/tools/lease.py "$@"
    else ssh -t box sudo -u claude-admin -H /srv/infra/tools/lease.py "$@"; fi
}
lease()   { _lease grant "$@"; }
unlease() { _lease revoke "$@"; }
leases()  { _lease list; }

### vpn on|off|status: the boot-time WireGuard (wg-quick@wg.service). Use this, not the desktop network menu:
### the menu only undoes NetworkManager's copy and leaves wg-quick's routing in place, which cuts all traffic.
### Only machines that have the service (il) do anything; over the VPN itself, `vpn off` ends your own session.
vpn() {
    systemctl is-enabled wg-quick@wg.service >/dev/null 2>&1 || { echo "no boot-time VPN (wg-quick@wg) on this machine"; return 1; }
    case "${1:-status}" in
        on)     sudo systemctl start wg-quick@wg && echo "vpn on" ;;
        off)    sudo systemctl stop wg-quick@wg && echo "vpn off" ;;
        status) systemctl is-active wg-quick@wg; sudo wg show wg latest-handshakes 2>/dev/null | awk -v n="$(date +%s)" '{printf "last handshake %d s ago\n", n-$2}' ;;
        *)      echo "usage: vpn on|off|status"; return 1 ;;
    esac
}
