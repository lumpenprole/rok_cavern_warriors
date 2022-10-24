sub init()
    m.top.id = "PickupModal"
    m.top.visible = false
    m.pickupSelector = m.top.findNode("pickupSelector")
    m.itemData = []
end sub

sub onEventCallback()
    ev = m.top.eventCallBack
    et = ev.evType

    if et = "pickupModalOnOff"
        handlePickupModalOnOff(ev.data)
    else if et = "pickupKeyEvent"
        handlePickupKeyEvent(ev.data)
    end if
end sub

sub handlePickupModalOnOff(data)
    m.itemData = []
    if m.top.visible
        m.top.visible = false
    else
        if data <> invalid
            updateItemList(data.items)
        end if
    end if
end sub

sub handlePickupKeyEvent(keyholder as object)
    key = keyHolder.key
    if key = "OK" then
        pickupItem(m.pickupSelector.itemSelected)
    else if key = "back"
        handlePickupModalOnOff({})
    end if
end sub

sub updateItemList(items)
    m.itemData = items
    thisRootNode = CreateObject("roSGNode", "ContentNode")
    for x = 0 to items.count() - 1
        thisItem = items[x]
        thisContentNode = CreateObject("roSGNode", "ContentNode")
        thisContentNode.title = thisItem.title
        thisContentNode.description = x
        thisRootNode.appendChild(thisContentNode)
    end for
    m.pickupSelector.content = thisRootNode
    'm.pickupSelector.setFocus(true)
    m.pickupSelector.itemSelected = 0
    m.top.visible = true
end sub

sub pickupItem(indexNum)
    fireEvent("pickupItem", {"item": m.itemData[indexNum]})

    m.itemData.delete(indexNum)
    if m.itemData.count() < 1
        handlePickupModalOnOff({})
    end if
end sub
