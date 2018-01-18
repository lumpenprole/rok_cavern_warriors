sub init()
    m.raceSelector = m.top.findNode("raceSelector")
    m.races = m.top.findNode("raceSelectorContent")
    m.classSelector = m.top.findNode("classSelector")
    m.classes = m.top.findNode("classSelectorContent")

    m.race = m.races.getChild(0).description
    m.class = m.classes.getChild(0).description
    m.raceSelector.observeField("itemFocused", "updateRace")
    m.classSelector.observeField("itemFocused", "updateClass")
    
    m.raceSelector.setFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press then
        if key = "OK"
            fireEvent("startGame", {race:m.race, class:m.class}) 
            handled = true
        else if key = "right"
            if m.raceSelector.hasFocus()
                m.classSelector.setFocus(true)
            end if
        else if key = "left"
            if m.classSelector.hasFocus()
                m.raceSelector.setFocus(true)
            end if
        end if
    end if
    return handled
end function

sub updateRace(msg)
    m.race = m.races.getChild(msg.getData()).description
end sub

sub updateClass(msg)
    m.class = m.classes.getChild(msg.getData()).description
end sub
