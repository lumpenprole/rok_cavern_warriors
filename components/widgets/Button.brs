sub init()
    m.buttonText = "not set"
    m.textColor = "#FFFFFF00"
    m.focusedTextColor = "#808080FF"
    m.selectedTextColor = "#964B00FF"
    m.unfocusedBgColor = "#FFFFFF22"
    m.focusedBgColor = "#FFFFFFFF"

    m.buttonLabel = m.top.findNode("button_label")
    m.buttonBg = m.top.findNode("button_background")

    m.top.width = m.buttonBg.width
    
    m.top.observeField("focusedChild", "handleFocusEvent")
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press
        if key = "OK"
            if m.top.isInFocusChain()
                m.top.buttonSelected = true
                handled = true
            end if
        end if
    end if
    return handled
end function


sub handleButtonText()
    m.buttonLabel.text = m.top.buttonText
end sub

sub handleTextColor()
    m.textColor = m.top.textColor
    m.buttonLabel.color = m.textColor
end sub

sub handleFocusedTextColor()
    m.focusedTextColor = m.top.focusedTextColor
end sub

sub handleSelectedTextColor()
    m.selectedTextColor = m.top.selectedTextColor
end sub

sub handleUnfocusedBgColor()
    m.unfocusedBgColor = m.top.unfocusedBgColor
end sub

sub handleFocusedBgColor()
    m.focusedBgColor = m.top.focusedBgColor
end sub

sub handleFocusEvent(ev)
    evData = ev.getData()
    if evData = invalid
        m.buttonLabel.color = m.textColor
        m.buttonBg.color = m.unfocusedBgColor
    else
        if m.top.isInFocusChain()
            m.buttonLabel.color = m.focusedTextColor
            m.buttonBg.color = m.focusedBgColor
        end if
    end if
end sub

sub handleWidthChange()
    m.buttonBg.width = m.top.width
    m.buttonLabel.width = m.top.width
end sub