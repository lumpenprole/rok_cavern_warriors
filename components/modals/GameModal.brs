sub init()
    ?"Game Modal: Init()"
    m.top.id = "GameModal"
    m.top.visible = false
    m.data = {}
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
        m.top.visible = false
    else
        m.top.visible = true
        m.data = data
        selectPage(0)
    end if
end sub

sub handleModalKeyEvent(keyHolder as object)
    key = keyHolder.key
    press = keyHolder.press
    if press
        if key = "play"
            fireEvent("handleGameModalOnOff", {})
        else if key = "up" or key = "down" or key = "left" or key = "right"
            navigation(key)
        end if
    end if
end sub

sub setupTabs()
    txts = ["Char", "Inv", "Game"]
    for t = 0 to 2
        tb = m.top.findNode("tab_" + t.toStr())
        tb.labelTxt = txts[t]
    end for

    m.currentTab = 0
end sub

sub navigation(direction as string)
    if direction = "left" or direction = "right"
        changeTab(direction)
    else if direction = "down"
        focusCurrentPage()
    end if
end sub

sub focusCurrentPage()
    'This will pass the key off to the current page
end sub

sub changeTab(direction as string)
    if direction = "left"
        if m.currentTab = 0
            m.currentTab = 2
        else
            m.currentTab = m.currentTab - 1
        end if
    else if direction = "right"
        if m.currentTab = 2
            m.currentTab = 0
        else
            m.currentTab = m.currentTab + 1
        end if
    end if
    
    selectPage(m.currentTab)
end sub

sub selectPage(pageNum as integer)
    pages = ["char", "inv", "opt"]
    for x = 0 to 2
        tb = m.top.findNode("tab_" + x.toStr())
        thisPage = m.top.findNode(pages[x] + "_screen")
        if x = pageNum
            thisPage.visible = true
            thisPage.screenData = m.data
            tb.selected = true
        else
            thisPage.visible = false
            tb.selected = false
        end if
    end for
end sub

