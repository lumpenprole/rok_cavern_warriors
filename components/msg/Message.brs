sub init()
    ?"BASE MESSAGE CLASS"
    m.messageHolder = m.top.findNode("message_holder")
end sub

sub handleText()
    'TODO: set width and height by text length
    bg = CreateObject("roSGNode", "Rectangle")
    bg.color = "0xA0A0A0FF"
    txtBox = CreateObject("roSGNode", "Label")
    txtBox.horizAlign = "center"
    txtBox.vertAlign = "center"
    txtBox.color = "0xFFFFFFFF"
    txtBox.text = m.top.messageText
    txtBox.width = 700
    txtBox.height = 300
    'TODO: Set location by width and height of text box and screen size
    bg.width = "720"
    bg.height = "320"
    m.messageHolder.translation = [500, 270]
    m.messageHolder.appendChild(bg)
    m.messageHolder.appendChild(txtBox)
end sub

function onKeyEvent(key)
    ?"FIRING KEY EVENT IN MESSAGE"
    handled = false
    if key = "OK"
        fireEvent("removeMessage")
    end if
    return handled
end function

