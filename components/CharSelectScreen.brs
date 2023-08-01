sub init()
    m.raceSelector = m.top.findNode("raceSelector")
    m.races = m.top.findNode("raceSelectorContent")
    m.classSelector = m.top.findNode("classSelector")
    m.classes = m.top.findNode("classSelectorContent")
    m.selectedValues = m.top.findNode("selectedValues")
    m.selectorsRow = m.top.findNode("selectors_row")
    m.playRow = m.top.findNode("play_row")
    m.playButton = m.top.findNode("play_button")

    deviceInfo = CreateObject("roDeviceInfo")
    screenRes = deviceInfo.getUIResolution()

    m.screenSize = [screenRes.height, screenRes.width] 

    m.selectedValues.width = m.screenSize[1]
    m.selectedValues.horizAlign = "center"

    m.race = "None"
    m.class = "None"
    m.raceSelector.observeField("itemSelected", "updateRace")
    m.classSelector.observeField("itemSelected", "updateClass")
    m.playButton.observeField("buttonSelected", "startGame")
    
    m.raceSelector.setFocus(true)
    setSelectionLabel()
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press then
        if key = "right"
            if m.raceSelector.hasFocus()
                m.classSelector.setFocus(true)
                m.class = "None"
            end if
        else if key = "left"
            if m.classSelector.hasFocus()
                m.raceSelector.setFocus(true)
                m.race = "None"
            end if
        else if key = "up"
            if m.playRow.isInFocusChain()
                m.raceSelector.setFocus(true)
                m.race = "None"
            end if
        end if
    end if
    return handled
end function

sub updateRace(msg)
    m.race = m.races.getChild(msg.getData()).description
    setSelectionLabel()
    m.classSelector.setFocus(true)
end sub

sub updateClass(msg)
    m.class = m.classes.getChild(msg.getData()).description
    setSelectionLabel()
    m.playButton.setFocus(true)
end sub

sub setSelectionLabel()
    selectedText ="Race: " + m.race + " Class: " + m.class
    m.selectedValues.text = selectedText
end sub

sub startGame()
    fireEvent("startGame", {race:m.race, class:m.class}) 
end sub
