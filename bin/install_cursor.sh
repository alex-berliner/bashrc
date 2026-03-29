#!/bin/bash

# 1. Create the keyrings folder if it doesn't exist
sudo mkdir -p /etc/apt/keyrings

# 2. Download and import Cursor's official GPG security key
curl -fsSL https://downloads.cursor.com/keys/anysphere.asc | \
gpg --dearmor | \
sudo tee /etc/apt/keyrings/anysphere.gpg > /dev/null

# 3. Create the DEB822 repository file using the parameters you found
sudo tee /etc/apt/sources.list.d/cursor.sources << 'EOF'
Types: deb
URIs: https://downloads.cursor.com/aptrepo
Suites: stable
Components: main
Architectures: amd64 arm64
Signed-By: /etc/apt/keyrings/anysphere.gpg
EOF

# 4. Update package lists and install the app
sudo apt update
sudo apt install cursor -y
