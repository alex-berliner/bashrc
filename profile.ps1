# PowerShell twin of helper.sh's Claude commands. Loaded from $PROFILE (install.ps1 adds the line).

function dangeresque { claude --dangerously-skip-permissions @args }

# second Claude account (login kept in sync by /srv/infra/tools/creds-sync.py)
function claude2 {
    $old = $env:CLAUDE_CONFIG_DIR
    $env:CLAUDE_CONFIG_DIR = Join-Path $HOME '.claude-2'
    try { claude --dangerously-skip-permissions @args } finally { $env:CLAUDE_CONFIG_DIR = $old }
}

# claude-admin / claude2-admin: Windows has no separate admin account; these run Claude elevated
# (UAC consent instead of the sudo password). Already elevated (admin terminal, ssh): run in place.
function Start-ClaudeAdmin([string]$ConfigDir, [string[]]$ClaudeArgs) {
    $elevated = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole('Administrators')
    if ($elevated) {
        $old = $env:CLAUDE_CONFIG_DIR
        if ($ConfigDir) { $env:CLAUDE_CONFIG_DIR = $ConfigDir }
        try { claude @ClaudeArgs } finally { $env:CLAUDE_CONFIG_DIR = $old }
    } else {
        $cmd = if ($ConfigDir) { "`$env:CLAUDE_CONFIG_DIR='$ConfigDir'; claude" } else { 'claude' }
        Start-Process (Get-Process -Id $PID).Path -Verb RunAs -ArgumentList '-NoExit', '-Command', $cmd
    }
}
function claude-admin { Start-ClaudeAdmin $null $args }
function claude2-admin { Start-ClaudeAdmin (Join-Path $HOME '.claude-2') $args }
