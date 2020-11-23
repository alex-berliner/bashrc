# export BASHRC_CONFIG_DIR=$HOME/Documents/bashrc
# . $BASHRC_CONFIG_DIR/main.sh

# to be sourced only by ~/.bashrc
if [[ -z $BASHRC_CONFIG_DIR ]]; then
    echo "Please export BASHRC_CONFIG_DIR=<bashrc git dir> in your main bashrc"
    return 1
fi

source $BASHRC_CONFIG_DIR/helper.sh
source $BASHRC_CONFIG_DIR/cdfunc.sh
source $BASHRC_CONFIG_DIR/switch.sh
