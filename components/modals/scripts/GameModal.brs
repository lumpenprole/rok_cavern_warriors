sub init()
    ?"Game Modal: Init()"
    m.top.id = "GameModal"
    m.top.visible = false
    'TODO: Set the size of this from the root and make it relative
    setupTabs()
end sub

sub onEventCallback()
    ev = m.top.eventCallBack
    et = ev.evType
    
    if et = "handleGameModalOnOff"
        handleGameModalOnOff(ev.data)
    else if et = "modalKeyEvent"
        handleModalKeyEvent(ev.data)
    end if
end sub

sub handleGameModalOnOff(data as object)
    if m.top.visible
        ?"TURNING GAME MODAL OFF!"
        m.top.visible = false
    else
        ?"TURNING GAME MODAL ON!"
        m.top.visible = true
        for each key in data.playerData
            ?key;": ";data.playerData[key]
        end for
        updateData()
    end if
end sub

sub handleModalKeyEvent(keyHolder as object)
    key = keyHolder.key
    press = keyHolder.press
    if press
        if key = "play"
            ?"GOT PLAY"
            fireEvent("handleGameModalOnOff", {})
        end if
    end if
end sub

sub updateData()
end sub

sub setupTabs()
    txts = ["Char", "Inv", "Game"]
    for t = 0 to 2
        tb = m.top.findNode("tab_" + t.toStr())
        tb.labelTxt = txts[t]
    end for
end sub
