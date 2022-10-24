sub init()
    ?"Character Screen"
    m.top.id = "CharScreen"
end sub

sub handleData()
    textBox = m.top.findNode("CHARACTER")
    txt = ""
    m.playerData = m.top.screenData.playerData
    txt = "Armor Class: " + m.playerData.ac.toStr() + chr(10)
    txt = txt + "Class: " + m.playerData.class + chr(10)
    txt = txt + "Hit Points: " + m.playerData.class.toStr() + chr(10)
    txt = txt + "Level: " + m.playerData.level.toStr() + chr(10)
    txt = txt + "Race: " + m.playerData.race + chr(10)
    txt = txt + "Experience: " + m.playerData.xp.toStr() + chr(10)
    ?"DATA IN TEXT FORM: ";txt
    textBox.text = txt
end sub
