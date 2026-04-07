: "${RC_REPO:?Error: RC_REPO environment variable is not defined}"

function fts {
    sudo apt update -y
    sudo apt full-upgrade -y
    sudo apt install -y gcc-arm-none-eabi
    sudo apt install -y gcc g++ cmake make bison git git-cola gitk vim tree tmux dtrx scrcpy adb
    sudo apt install -y wine
    sudo apt install -y wireguard
    sudo apt install -y chromium-browser

    # codium https://vscodium.com/
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
    echo -e 'Types: deb\nURIs: https://download.vscodium.com/debs\nSuites: vscodium\nComponents: main\nArchitectures: amd64 arm64\nSigned-by: /usr/share/keyrings/vscodium-archive-keyring.gpg' \ | sudo tee /etc/apt/sources.list.d/vscodium.sources
    sudo apt update -y
    sudo apt install -y codium
    
    # cursor
    sudo $RC_REPO/bin/install_cursor.sh

    # gamin
    sudo add-apt-repository -y ppa:libretro/testing
    sudo apt update
    sudo apt install -y retroarch
    sudo apt install -y steam-installer lutris 

    sudo snap install discord
    sudo apt autoremove -y
}
