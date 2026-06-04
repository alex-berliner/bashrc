: "${RC_REPO:?Error: RC_REPO environment variable is not defined}"
# add to bashrc, run from bashrc root
# echo export RC_REPO="`pwd`" >> ~/.bashrc
# echo . $RC_REPO/main.sh >> ~/.bashrc

. $RC_REPO/helper.sh
. $RC_REPO/fts.sh

# deploy tmux config (idempotent symlink to XDG location)
mkdir -p ~/.config/tmux
ln -sf "$RC_REPO/conf/tmux.conf" ~/.config/tmux/tmux.conf
command -v tmux >/dev/null && tmux info &>/dev/null && tmux source-file ~/.config/tmux/tmux.conf
