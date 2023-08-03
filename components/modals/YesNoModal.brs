sub init()
    m.top.id = "YesNoModal"
    m.top.visible = false
    m.msg = m.top.findNode("message_text")
    m.yesButton = m.top.findNode("yes_button")
    m.noButton = m.top.findNode("no_button")
    m.yesButton.observeField("buttonSelected", "exitGame")
    m.noButton.observeField("buttonSelected", "exitModal")
end sub

sub handleData(dataObj)
    stop
end sub

sub onEventCallback()
    ev = m.top.eventCallBack
    et = ev.evType
    if et = "handleYesNoModalOnOff"
        handleYesNoOnOff(ev.data)
    end if
end sub

sub handleYesNoOnOff(data as object)
    if m.top.visible = false
        m.msg.text = data.messageText
        m.yesButton.setFocus(true)
        m.top.visible = true
    else 
        exitModal()
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press
        if key = "right"
            if m.yesButton.hasFocus()
                m.noButton.setFocus(true)
            end if
            handled = true
        else if key = "left"
            if m.noButton.hasFocus()
                m.yesButton.setFocus(true)
            end if
            handled = true
        else if key = "back"
            exitModal()
            handled = true
        end if
    end if
    return handled
end function

sub exitModal()
    m.top.visible = false
    m.msg.text = "no text"
    fireEvent("returnFocusToLevel", {})
end sub

sub exitGame()
    fireEvent("exitApp", {})
end sub
