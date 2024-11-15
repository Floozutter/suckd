#Requires AutoHotKey v2
#Warn


; inputs
suspendKey := "F1"
disabledKeys := ["LWin"]
leftKeys := ["a", "n"]
rightKeys := ["d", "m"]
upKeys := ["Space", "h"]
downKeys := ["s", "."]

; outputs
leftButton := "a"
rightButton := "d"
upButton := "Space"
downButton := "s"

; SOCD cleaning modes
MODE := {NEUTRAL: 0, LAST_INPUT_PRIORITY: 1, UP_PRIORITY: 2}
modeX := MODE.LAST_INPUT_PRIORITY
modeY := MODE.UP_PRIORITY


InstallKeybdHook()

anyPressed(keys) {
    pressed := 0
    Loop keys.length {
        If (GetKeyState(keys[A_Index], "p")) {
            pressed := 1
            Break
        }
    }
    return pressed
}

updateX(left, right) {
    leftState := GetKeyState(leftButton)
    rightState := GetKeyState(rightButton)
    If (left != leftState) {
        If (left) {
            SendInput("{" . leftButton . " Down}")
        } Else {
            SendInput("{" . leftButton . " Up}")
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

updateY(up, down) {
    upState := GetKeyState(upButton)
    downState := GetKeyState(downButton)
    If (up != upState) {
        If (up) {
            SendInput("{" . upButton . " Down}")
        } Else {
            SendInput("{" . upButton . " Up}")
        }
    }
    If (down != downState) {
        If (down) {
            SendInput("{" . downButton . " Down}")
        } Else {
            SendInput("{" . downButton . " Up}")
        }
    }
}

onLeft(_hotkeyName) {
    left := anyPressed(leftKeys)
    right := anyPressed(rightKeys)
    If (left && right) {
        If (modeX == MODE.LAST_INPUT_PRIORITY) {
            right := 0
        } Else {
            left := 0
            right := 0
        }
    }
    updateX(left, right)
}
Loop leftKeys.Length {
    Hotkey("*" . leftKeys[A_Index], onLeft)
    Hotkey("*" . leftKeys[A_Index] . " Up", onLeft)
}

onRight(_hotkeyName) {
    left := anyPressed(leftKeys)
    right := anyPressed(rightKeys)
    If (left && right) {
        If (modeX == MODE.LAST_INPUT_PRIORITY) {
            left := 0
        } Else {
            left := 0
            right := 0
        }
    }
    updateX(left, right)
}
Loop rightKeys.Length {
    Hotkey("*" . rightKeys[A_Index], onRight)
    Hotkey("*" . rightKeys[A_Index] . " Up", onRight)
}

onUp(_hotkeyName) {
    up := anyPressed(upKeys)
    down := anyPressed(downKeys)
    If (up && down) {
        If (modeY == MODE.LAST_INPUT_PRIORITY) {
            down := 0
        } Else If (modeY == MODE.UP_PRIORITY) {
            down := 0
        } Else {
            up := 0
            down := 0
        }
    }
    updateY(up, down)
}
Loop upKeys.Length {
    Hotkey("*" . upKeys[A_Index], onUp)
    Hotkey("*" . upKeys[A_Index] . " Up", onUp)
}

onDown(_hotkeyName) {
    up := anyPressed(upKeys)
    down := anyPressed(downKeys)
    If (up && down) {
        If (modeY == MODE.LAST_INPUT_PRIORITY) {
            up := 0
        } Else If (modeY == MODE.UP_PRIORITY) {
            down := 0
        } Else {
            up := 0
            down := 0
        }
    }
    updateY(up, down)
}
Loop downKeys.Length {
    Hotkey("*" . downKeys[A_Index], onDown)
    Hotkey("*" . downKeys[A_Index] . " Up", onDown)
}

onSuspend(_hotkeyName) {
    Suspend(-1)
    SoundPlay(A_IsSuspended ? "*16" : "*64")
}
Hotkey(suspendKey, onSuspend, "S")

onDisabled(_hotkeyName) {
    return
}
Loop disabledKeys.Length {
    Hotkey(disabledKeys[A_Index], onDisabled)
}
