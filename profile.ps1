# PowerShell twin of helper.sh's Claude commands. Loaded from $PROFILE (install.ps1 adds the line).
# cl = plain; a = elevated; 2 = second account (~\.claude-2, login kept in sync by /srv/infra/tools/creds-sync.py);
# dang*/dangeresque* = elevated + --dangerously-skip-permissions.
# Windows has no claude-admin account: "elevated" means UAC consent instead of the sudo password.
# Already elevated (admin terminal, ssh): runs in place.

function cl { claude @args }

function cl2 {
    $old = $env:CLAUDE_CONFIG_DIR
    $env:CLAUDE_CONFIG_DIR = Join-Path $HOME '.claude-2'
    try { claude @args } finally { $env:CLAUDE_CONFIG_DIR = $old }
}

function Start-ClaudeAdmin([string]$ConfigDir, [string[]]$ClaudeArgs) {
    $elevated = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole('Administrators')
    if ($elevated) {
        $old = $env:CLAUDE_CONFIG_DIR
        if ($ConfigDir) { $env:CLAUDE_CONFIG_DIR = $ConfigDir }
        try { claude @ClaudeArgs } finally { $env:CLAUDE_CONFIG_DIR = $old }
    } else {
        $cmd = if ($ConfigDir) { "`$env:CLAUDE_CONFIG_DIR='$ConfigDir'; claude $ClaudeArgs" } else { "claude $ClaudeArgs" }
        Start-Process (Get-Process -Id $PID).Path -Verb RunAs -ArgumentList '-NoExit', '-Command', $cmd
    }
}
$claude2dir = Join-Path $HOME '.claude-2'
function cla { Start-ClaudeAdmin $null $args }
function dang { Start-ClaudeAdmin $null (@('--dangerously-skip-permissions') + $args) }
function dangeresque { dang @args }
function cl2a { Start-ClaudeAdmin $claude2dir $args }
function dang2 { Start-ClaudeAdmin $claude2dir (@('--dangerously-skip-permissions') + $args) }
function dangeresque2 { dang2 @args }
