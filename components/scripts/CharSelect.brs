sub init()
    selector = m.top.findNode("charSelector")
    selector.setFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    ?"CHAR SELECT KEY: ";key;" PRESS: ";press
    if press then
        if key = "OK"
            selector = m.top.findNode("charSelector")
            content = m.top.findNode("charSelectorContent")
            'This should probably be the place where we make the player object and pass it to
            'the startGame function. For the time being, just passing the class string to 
            'get to to the part where we can make a playable level
            selectedData = content.getChild(selector.itemSelected).description

            ?"SELECTED CLASS: ";selectedData
            fireEvent("startGame", {class:selectedData}) 
            handled = true
        end if
    end if
    return handled
end function
