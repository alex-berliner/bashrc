#!/bin/bash

DIR_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
echo "export RC_REPO=\"$DIR_PATH\"" >> ~/.bashrc
echo ". \"\$RC_REPO/main.sh\"" >> ~/.bashrc

