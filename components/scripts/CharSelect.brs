sub init()
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    ?"CHAR SELECT KEY: ";key;" PRESS: ";press
    if press then
        if key = "OK"
            ?"CHAR OK!"
            fireEvent("startGame", {})
            handled = true
        end if
    end if
    return handled
end function
