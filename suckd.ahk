#Requires AutoHotKey v2
#Warn

suspendKey := "F1"
disabledKeys := ["LWin"]
upKeys := ["w", "h"]
leftKeys := ["a", "n"]
downKeys := ["s", "."]
rightKeys := ["d", "m"]
upButton := "w"
leftButton := "a"
downButton := "s"
rightButton := "d"

InstallKeybdHook()

callback(hotkeyName) {
    ; get raw direction key presses
    up := 0
    Loop upKeys.length {
        If (GetKeyState(upKeys[A_Index], "p")) {
            up := 1
            Break
        }
    }
    left := 0
    Loop leftKeys.length {
        If (GetKeyState(leftKeys[A_Index], "p")) {
            left := 1
            Break
        }
    }
    down := 0
    Loop downKeys.length {
        If (GetKeyState(downKeys[A_Index], "p")) {
            down := 1
            Break
        }
    }
    right := 0
    Loop rightKeys.length {
        If (GetKeyState(rightKeys[A_Index], "p")) {
            right := 1
            Break
        }
    }
    ; clean simultaneous opposite cardinal directions
    If (left && right) {
        left := 0
        right := 0
    }
    If (up && down) {
        down := 0
    }
    ; get output key states
    upState := GetKeyState(upButton)
    leftState := GetKeyState(leftButton)
    downState := GetKeyState(downButton)
    rightState := GetKeyState(rightButton)
    ; change output key states if necessary
    If (up != upState) {
        If (up) {
            SendInput("{" . upButton . " Down}")
        } Else {
            SendInput("{" . upButton . " Up}")
        }
    }
    If (left != leftState) {
        If (left) {
            SendInput("{" . leftButton . " Down}")
        } Else {
            SendInput("{" . leftButton . " Up}")
        }
    }
    If (down != downState) {
        If (down) {
            SendInput("{" . downButton . " Down}")
        } Else {
            SendInput("{" . downButton . " Up}")
        }
    }
    If (right != rightState) {
        If (right) {
            SendInput("{" . rightButton . " Down}")
        } Else {
            SendInput("{" . rightButton . " Up}")
        }
    }
}
keys := []
keys.Push(upKeys*)
keys.Push(leftKeys*)
keys.Push(downKeys*)
keys.Push(rightKeys*)
registeredKeys := Map()
Loop keys.Length {
    If (!registeredKeys.has(keys[A_Index])) {
        registeredKeys[keys[A_Index]] := 1
        Hotkey("*" . keys[A_Index], callback)
        Hotkey("*" . keys[A_Index] . " Up", callback)
    }
}

disabledCallback(hotkeyName) {
    return
}
Loop disabledKeys.Length {
    Hotkey(disabledKeys[A_Index], disabledCallback)
}

suspendCallback(hotkeyName) {
    Suspend(-1)
    SoundPlay(A_IsSuspended ? "*16" : "*64")
}
Hotkey(suspendKey, suspendCallback, "S")
