# PowerShell twin of helper.sh's Claude commands. Loaded from $PROFILE (install.ps1 adds the line).
# cl = plain; 2 = second account (~\.claude-2, login kept alive by /srv/infra/tools/creds-sync.py);
# dang*/dangeresque* = --dangerously-skip-permissions. All run as you, not elevated.

function cl { claude @args }

function cl2 {
    $old = $env:CLAUDE_CONFIG_DIR
    $env:CLAUDE_CONFIG_DIR = Join-Path $HOME '.claude-2'
    try { claude @args } finally { $env:CLAUDE_CONFIG_DIR = $old }
}
function dang { claude --dangerously-skip-permissions @args }
function dangeresque { dang @args }
function dang2 { cl2 --dangerously-skip-permissions @args }
function dangeresque2 { dang2 @args }

# Root leases on the Linux/WSL machines (/srv/infra/tools/lease.py on box); asks for your password once.
#   lease desktop lenovo,desktop-ubuntu 12h     unlease desktop [lenovo]     leases
function lease   { ssh -t box sudo -u claude-admin -H /srv/infra/tools/lease.py grant @args }
function unlease { ssh -t box sudo -u claude-admin -H /srv/infra/tools/lease.py revoke @args }
function leases  { ssh -t box sudo -u claude-admin -H /srv/infra/tools/lease.py list }
