#Requires AutoHotkey v2.0
; ==============================================================================
; ★安全版 (Registry併用)
; CapsLockのCtrl化はレジストリで行っている前提のスクリプトです。
; AHKは純粋なショートカット機能のみを担当するため、スタック等のバグ起きません。
; ==============================================================================
InstallKeybdHook
A_MaxHotkeysPerInterval := 200

; 除外アプリ設定
GroupAdd "EmacsDisabledApps", "ahk_exe WindowsTerminal.exe"
GroupAdd "EmacsDisabledApps", "ahk_exe Code.exe"
GroupAdd "EmacsDisabledApps", "ahk_exe mstsc.exe"
GroupAdd "EmacsDisabledApps", "ahk_exe wsl.exe"
GroupAdd "EmacsDisabledApps", "ahk_exe mintty.exe"

; ==============================================================================
; 関数：IME直接制御
; ==============================================================================
IME_SET(SetSts, WinTitle := "A") {
    try {
        hWnd := WinGetID(WinTitle)
        ImeMode := DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hWnd, "Uint")
        DetectSave := A_DetectHiddenWindows
        DetectHiddenWindows True
        SendMessage 0x0283, 0x0006, SetSts, ImeMode
        DetectHiddenWindows DetectSave
    }
}

; ==============================================================================
; Emacsキーバインド
; CapsLockはすでに物理的に「Ctrl」になっているため、単純な「^key」で動作します。
; ==============================================================================
#HotIf not WinActive("ahk_group EmacsDisabledApps")

    ; 単純なリマップであれば、スタック問題は発生しません
    ^p::Up
    ^n::Down
    ^b::Left
    ^f::Right
    ^a::Home
    ^e::End
    ^d::Del
    ^h::BS
    ^m::Enter

    ; Kill Line
    ^k::
    {
        SendInput "{ShiftDown}{End}{ShiftUp}"
        Sleep 10
        SendInput "^x"
    }

#HotIf

; ==============================================================================
; Mac風ショートカット (左Win + Key -> Ctrl + Key)
; ==============================================================================
<#x::Send "^x"
<#c::Send "^c"
<#v::Send "^v"
<#z::Send "^z"
<#a::Send "^a"
<#s::Send "^s"
<#f::Send "^f"
<#w::Send "^w"
<#n::Send "^n"

; ==============================================================================
; Winキー空打ちでIME切り替え
; ==============================================================================
~LWin::SendInput "{Blind}{vkE8}"
LWin up::
{
    if (A_PriorKey = "LWin") {
        IME_SET(0)
    }
}

~RWin::SendInput "{Blind}{vkE8}"
RWin up::
{
    if (A_PriorKey = "RWin") {
        IME_SET(1)
    }
}

