sub init()
    ?"Inventory Screen"
    m.top.id = "InvScreen"
    m.textBox = m.top.findNode("INVENTORY")
    m.wornItemsList = m.top.findNode("worn_items_list")
end sub

sub handleData()
    wornItems = CreateObject("roSGNode", "WornItemsNode")
    invData = m.top.screenData.playerData.inv
    armor = invData.armor
    titleHolder = []
    titleHolder.push("Main Hand: " + invData.mainHand)
    titleHolder.push("Off Hand: " + invData.offHand)
    titleHolder.push("Head: " + armor.head )
    titleHolder.push("Torso: " + armor.torso)
    titleHolder.push("Legs: " + armor.legs)
    titleHolder.push("Gloves: " + armor.gloves)
    titleHolder.push("Boots: " + armor.boots)
    ?"TITLEHOLDER YEAH: "; titleHolder
    wornItems.data = titleHolder
    m.wornItemsList.content = wornItems

    sack = invData.sack
    for s = 0 to sack.count() - 1
        ?"sack ";s;": ";sack[s].title
    end for
end sub

sub handleModalKeyPress()
    key = m.top.keyPress
    if key = "down" then
        if not m.wornItemsList.isInFocusChain()
            m.wornItemsList.setFocus(true)
        end if
    end if
end sub