sub init()
    ?"Inventory Screen"
    m.top.id = "InvScreen"
end sub

sub handleData()
    textBox = m.top.findNode("INVENTORY")
    txt = ""
    invData = m.top.screenData.playerData.inv
    for each key in invData
        if key <> "sack"
            ?"inv ";key;": ";invData[key]
            txt = txt + key + ": " + invData[key] + chr(10)
        end if
    end for

    txt = chr(10) + "SACK: " + chr(10)

    sack = invData.sack
    for s = 0 to sack.count() - 1
        for each sackKey in sack[s]
            ?"sack ";key;": ";sack[s][sackKey]
            txt = txt + sackKey + ": " + sack[s][sackKey] + chr(10)
        end for
    end for

    ?"DATA IN TEXT FORM: ";txt
    textBox.text = txt
end sub
