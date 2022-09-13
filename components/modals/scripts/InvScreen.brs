sub init()
    ?"Inventory Screen"
    m.top.id = "InvScreen"
end sub

sub handleData()
    textBox = m.top.findNode("INVENTORY")
    txt = ""
    invData = m.top.screenData.playerData.inv
    armor = invData.armor
    txt = txt + "Main Hand: " + invData.mainHand + chr(10)
    txt = txt + "Off Hand: " + invData.offHand + chr(10)
    txt = txt + "Armor: " + chr(10)
    txt = txt + chr(9) + "Head: " + armor.head + chr(10) 
    txt = txt + chr(9) + "Torso: " + armor.torso + chr(10)
    txt = txt + chr(9) + "Legs: " + armor.legs + chr(10)
    txt = txt + chr(9) + "Gloves: " + armor.gloves + chr(10)
    txt = txt + chr(9) + "Boots: " + armor.boots + chr(10)
    txt = txt + chr(10) + "SACK: " + chr(10)

    sack = invData.sack
    for s = 0 to sack.count() - 1
        for each sackKey in sack[s]
            ?"sack ";sackkey;": ";sack[s][sackKey]
            txt = txt + sackKey + ": " + sack[s][sackKey] + chr(10)
        end for
    end for

    ?"DATA IN TEXT FORM: ";txt
    textBox.text = txt
end sub
