# Windows twin of install.sh: clone/update this repo at ~\bin\bashrc and load profile.ps1 from both PowerShells. Idempotent.
$repo = "$HOME\bin\bashrc"
if (Test-Path "$repo\.git") { git -C $repo pull -q --ff-only }
else { New-Item -ItemType Directory -Force "$HOME\bin" | Out-Null; git clone -q https://github.com/alex-berliner/bashrc $repo }
$line = '. "$HOME\bin\bashrc\profile.ps1"'
$docs = [Environment]::GetFolderPath('MyDocuments')
foreach ($d in 'PowerShell', 'WindowsPowerShell') {
    New-Item -ItemType Directory -Force "$docs\$d" | Out-Null
    $p = "$docs\$d\profile.ps1"
    if (-not (Test-Path $p) -or -not (Select-String -Path $p -SimpleMatch 'bashrc\profile.ps1' -Quiet)) { Add-Content $p $line }
}
