#MaxThreads 1
SetBatchLines, -1

global ups := 0
global lefts := 0
global downs := 0
global rights := 0

global prevUp := 0
global prevLeft := 0
global prevDown := 0
global prevRight := 0

update() {
    currUp := ups != 0
    currLeft := lefts != 0 && rights == 0
    currDown := downs != 0 && ups == 0
    currRight := rights != 0 && lefts == 0
    if (currUp != prevUp) {
        if (currUp) {
            SendInput {1 Down}
        } else {
            SendInput {1 Up}
        }
    }
    if (currLeft != prevLeft) {
        if (currLeft) {
            SendInput {2 Down}
        } else {
            SendInput {2 Up}
        }
    }
    if (currDown != prevDown) {
        if (currDown) {
            SendInput {3 Down}
        } else {
            SendInput {3 Up}
        }
    }
    if (currRight != prevRight) {
        if (currRight) {
            SendInput {4 Down}
        } else {
            SendInput {4 Up}
        }
    }
    prevUp := currUp
    prevLeft := currLeft
    prevDown := currDown
    prevRight := currRight
}

upPress() {
    ++ups
    update()
}
upRelease() {
    ups := Max(ups - 1, 0)
    update()
}

leftPress() {
    ++lefts
    update()
}
leftRelease() {
    lefts := Max(lefts - 1, 0)
    update()
}

downPress() {
    ++downs
    update()
}
downRelease() {
    downs := Max(downs - 1, 0)
    update()
}

rightPress() {
    ++rights
    update()
}
rightRelease() {
    rights := Max(rights - 1, 0)
    update()
}

downLeftPress() {
    ++downs
    ++lefts
    update()
}
downLeftRelease() {
    downs := Max(downs - 1, 0)
    lefts := Max(lefts - 1, 0)
    update()
}

downRightPress() {
    ++downs
    ++rights
    update()
}
downRightRelease() {
    downs := Max(downs - 1, 0)
    rights := Max(rights - 1, 0)
    update()
}

~w::upPress()
~w Up::upRelease()
~a::leftPress()
~a Up::leftRelease()
~s::downPress()
~s Up::downRelease()
~d::rightPress()
~d Up::rightRelease()

q::
    MsgBox %ups%, %lefts%, %downs%, %rights%
return
