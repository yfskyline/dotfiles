# ==============================================================================
# Windows Setup Script
# 実行方法: 管理者権限のPowerShellで実行 (例: sudo .\setup_windows.ps1)
# ==============================================================================

# 0. 管理者権限チェック
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "【エラー】このスクリプトは管理者権限で実行する必要があります。"
    Write-Warning "sudo .\setup_windows.ps1 または、PowerShellを「管理者として実行」してから実行してください。"
    exit 1
}

$ErrorActionPreference = "Stop"

try {
    # --------------------------------------------------------------------------
    # 1. AutoHotkey v2 のインストール (winget)
    # --------------------------------------------------------------------------
    Write-Host "`n[1/3] AutoHotkey v2 のインストール確認..." -ForegroundColor Cyan
    try {
        winget install AutoHotkey.AutoHotkey --accept-source-agreements --accept-package-agreements
    } catch {
        Write-Host "   -> 既にインストールされているか、インストールに失敗しました (続行します)" -ForegroundColor Gray
    }

    # --------------------------------------------------------------------------
    # 2. keyremap.ahk のスタートアップ登録 (シンボリックリンク)
    # --------------------------------------------------------------------------
    Write-Host "`n[2/3] AutoHotkeyスクリプトのリンク作成..." -ForegroundColor Cyan

    # スクリプト自身の場所を取得 (dotfiles/windows/ を想定)
    $ScriptDir = $PSScriptRoot
    if (-not $ScriptDir) { $ScriptDir = Get-Location }

    $SourceFile = "$ScriptDir\keyremap.ahk"
    $StartupDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    $LinkPath = "$StartupDir\keyremap.ahk"

    if (Test-Path $SourceFile) {
        if (Test-Path $LinkPath) {
            Remove-Item $LinkPath -Force
            Write-Host "   既存のリンクを削除しました。" -ForegroundColor Gray
        }
        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $SourceFile | Out-Null
        Write-Host "   [OK] シンボリックリンクを作成しました:" -ForegroundColor Green
        Write-Host "        $LinkPath -> $SourceFile"
    } else {
        throw "【エラー】ソースファイル ($SourceFile) が見つかりません。"
    }

    # --------------------------------------------------------------------------
    # 3. レジストリ設定 (CapsLock -> Ctrl)
    # --------------------------------------------------------------------------
    Write-Host "`n[3/3] CapsLockをCtrlに変更 (レジストリ設定)..." -ForegroundColor Cyan

    $RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
    # バイナリデータ: 0x1d(LCtrl) を 0x3a(CapsLock) に割り当て
    $RegValue = [byte[]](0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x02,0x00,0x00,0x00, 0x1d,0x00,0x3a,0x00, 0x00,0x00,0x00,0x00)

    Set-ItemProperty -Path $RegPath -Name "Scancode Map" -Value $RegValue
    Write-Host "   [OK] レジストリを設定しました。" -ForegroundColor Green

    # --------------------------------------------------------------------------
    # 完了
    # --------------------------------------------------------------------------
    Write-Host "`n==========================================" -ForegroundColor Cyan
    Write-Host "   セットアップ完了！" -ForegroundColor Cyan
    Write-Host "   設定を反映するため、Windowsを【再起動】してください。" -ForegroundColor Yellow
    Write-Host "==========================================" -ForegroundColor Cyan

} catch {
    Write-Error "`n[失敗] エラーが発生しました: $_"
}

