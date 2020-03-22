# to be sourced only by ~/.bashrc
if [[ -z $BASHRC_CONFIG_DIR ]]; then
    echo "Please export BASHRC_CONFIG_DIR=\"$DIR\" in your main bashrc"
    return 1
fi

source $BASHRC_CONFIG_DIR/helper.sh
source $BASHRC_CONFIG_DIR/cdfunc.sh
source $BASHRC_CONFIG_DIR/switch.sh
