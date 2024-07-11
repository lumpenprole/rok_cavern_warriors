sub init()
    m.raceSelector = m.top.findNode("raceSelector")
    m.races = m.top.findNode("raceSelectorContent")
    m.classSelector = m.top.findNode("classSelector")
    m.classes = m.top.findNode("classSelectorContent")
    m.selectedValues = m.top.findNode("selectedValues")
    m.selectionHolder = m.top.findNode("selectionHolder")
    m.playRow = m.top.findNode("play_row")
    m.playButton = m.top.findNode("play_button")

    deviceInfo = CreateObject("roDeviceInfo")
    screenRes = deviceInfo.getUIResolution()

    m.screenSize = [screenRes.height, screenRes.width] 

    m.selectedValues.width = m.screenSize[1]
    m.selectedValues.horizAlign = "center"

    ?"PLAY BUTTON WIDTH: "; m.playButton.width
    ?"PLAY BUTTON TRANSLATION: "; m.playButton.translation

    m.race = "None"
    m.class = "None"
    m.raceSelector.observeField("itemSelected", "updateRace")
    m.classSelector.observeField("itemSelected", "updateClass")
    m.playButton.observeField("buttonSelected", "startGame")
    
    m.raceSelector.setFocus(true)
    setSelectionLabel()
    alignElements()
end sub

function alignElements()
    selRect = m.selectionHolder.boundingRect()
    playRect = m.playButton.boundingRect()
    middle = m.screenSize[1] / 2
    m.selectionHolder.translation = [middle - selRect.width / 2, selRect.y]
    m.playButton.translation = [middle - playRect.width / 2, selRect.x + selRect.height + playRect.height + 10]
end function

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
            if m.playButton.isInFocusChain()
                m.raceSelector.setFocus(true)
                m.race = "None"
            end if
        else if key = "back"
            if m.playButton.isInFocusChain()
                m.classSelector.setFocus(true)
                m.class = "None"
            else if m.classSelector.hasFocus()
                m.raceSelector.setFocus(true)
                m.race = "None"
            end if
            handled = true
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
