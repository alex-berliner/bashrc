#!/bin/bash
# Safe to re-run: every step checks before it changes anything.

DIR_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
grep -q "^export RC_REPO=" ~/.bashrc || echo "export RC_REPO=\"$DIR_PATH\"" >> ~/.bashrc
grep -q 'RC_REPO/main.sh' ~/.bashrc || echo ". \"\$RC_REPO/main.sh\"" >> ~/.bashrc

# claude-admin: a separate account with passwordless root, for Claude sessions that need it.
# Your own user keeps password sudo. Enter it with `claude-admin` (alias in helper.sh) or
# `sudo -u claude-admin -i`. It has no password and no SSH key of its own.
setup_claude_admin() {
    local me sudoers=/etc/sudoers.d/50-claude-admin tmp
    me=$(id -un)
    [ "$me" = claude-admin ] && return
    command -v sudo >/dev/null || { echo "no sudo: skipping claude-admin"; return; }

    id claude-admin &>/dev/null || sudo useradd --create-home --shell /bin/bash claude-admin
    sudo usermod --lock claude-admin                 # no password login
    id -nG claude-admin | grep -qw "$me" || sudo usermod -aG "$me" claude-admin   # can use your group-writable files

    if ! sudo test -f "$sudoers"; then
        tmp=$(mktemp)
        printf '# Entered with: sudo -u claude-admin -i (asks for your password)\nclaude-admin ALL=(ALL) NOPASSWD: ALL\n' > "$tmp"
        sudo visudo -cf "$tmp" >/dev/null && sudo install -m 0440 -o root -g root "$tmp" "$sudoers"
        rm -f "$tmp"
    fi

    # its own Claude Code install (log in once on first use)
    sudo -u claude-admin -i bash -c '
        [ -x ~/.local/bin/claude ] || curl -fsSL https://claude.ai/install.sh | bash
        grep -qF "export PATH=\"\$HOME/.local/bin:\$PATH\"" ~/.bashrc 2>/dev/null ||
            echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> ~/.bashrc'

    [ "$(sudo -u claude-admin sudo -n id -u 2>/dev/null)" = 0 ] && echo "claude-admin ready" || echo "claude-admin: root check FAILED"
}
setup_claude_admin
