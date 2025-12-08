#Requires AutoHotkey v2.0
; ==============================================================================
; 設定：除外するアプリケーション（ここで指定したアプリではEmacsキーが無効になります）
; ==============================================================================
GroupAdd "EmacsDisabledApps", "ahk_exe WindowsTerminal.exe" ; Windows Terminal
GroupAdd "EmacsDisabledApps", "ahk_exe Code.exe"            ; VS Code
GroupAdd "EmacsDisabledApps", "ahk_exe mstsc.exe"           ; Remote Desktop
GroupAdd "EmacsDisabledApps", "ahk_exe wsl.exe"             ; WSL GUI
GroupAdd "EmacsDisabledApps", "ahk_exe mintty.exe"          ; Git Bash

; ==============================================================================
; 1. CapsLock を Ctrl として扱う (物理的な入替え)
; ==============================================================================
CapsLock::LCtrl

; ==============================================================================
; 2. Mac風ショートカット (左Win + key -> Ctrl + key)
;    ※ SendInputを使うことで、後述のEmacsキーバインドと干渉せず「Windowsの機能」を呼び出せます
; ==============================================================================
<#x::SendInput "^x"  ; Cut
<#c::SendInput "^c"  ; Copy
<#v::SendInput "^v"  ; Paste
<#z::SendInput "^z"  ; Undo
<#a::SendInput "^a"  ; Select All (EmacsのHomeと区別されます)
<#s::SendInput "^s"  ; Save
<#f::SendInput "^f"  ; Find (EmacsのRightと区別されます)
<#w::SendInput "^w"  ; Close tab/window
<#n::SendInput "^n"  ; New window (EmacsのDownと区別されます)

; ==============================================================================
; 3. Emacsキーバインド (Ctrl + key -> カーソル移動など)
;    ※ 除外アプリ以外でのみ有効
; ==============================================================================
#HotIf not WinActive("ahk_group EmacsDisabledApps")

    ^p::Send "{Up}"             ; Previous line
    ^n::Send "{Down}"           ; Next line
    ^b::Send "{Left}"           ; Backward char
    ^f::Send "{Right}"          ; Forward char
    
    ^a::Send "{Home}"           ; Beginning of line
    ^e::Send "{End}"            ; End of line
    
    ^d::Send "{Del}"            ; Delete char
    ^h::Send "{BS}"             ; Backspace
    
    ; Kill line (カーソル位置から行末まで削除)
    ; Shift+Endで行末まで選択し、Ctrl+Xで切り取る(クリップボードに入る)挙動にしています
    ^k::
    {
        Send "{ShiftDown}{End}{ShiftUp}"
        Sleep 10 ; 安定性のためわずかに待機
        Send "^x"
    }
    
    ; Ctrl+m を Enter として扱う
    ^m::Send "{Enter}"

#HotIf ; これ以降はすべてのアプリで有効

; ==============================================================================
; 4. 左Command (LWin) の空打ち判定 (IME OFF)
; ==============================================================================
~LWin::Send "{Blind}{vkE8}"
LWin up::
{
    if (A_PriorKey = "LWin") {
        Send "{vk1Dsc07B}" ; 無変換 (IME OFF)
    }
}

; ==============================================================================
; 5. 右Command (RWin) の空打ち判定 (IME ON)
; ==============================================================================
~RWin::Send "{Blind}{vkE8}"
RWin up::
{
    if (A_PriorKey = "RWin") {
        Send "{vk1Csc079}" ; 変換 (IME ON)
    }
}

