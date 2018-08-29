sub init()
    ?"Options Screen"
    m.top.id = "OptScreen"
end sub

sub handleData()
    textBox = m.top.findNode("OPTIONS")
    txt = "GAME OPTIONS TBD"
    textBox.text = txt
end sub
