# 管理者権限で実行してください

# 1. リンク元のパス (dotfiles内のスクリプト)
$SourceFile = "$HOME\dotfiles\windows\keyremap.ahk"

# 2. リンク先のパス (Windowsのスタートアップフォルダ)
$StartupDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$LinkPath = "$StartupDir\keyremap.ahk"

# 3. シンボリックリンクの作成 (すでに存在する場合は削除して再作成)
if (Test-Path $LinkPath) {
    Remove-Item $LinkPath
}

# 管理者権限が必要な場合があります
New-Item -ItemType SymbolicLink -Path $LinkPath -Target $SourceFile
Write-Host "Symlink created: $LinkPath -> $SourceFile"
