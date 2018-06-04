sub init()
    ?"Character Screen"
    m.top.id = "CharScreen"
    m.testLabel = m.top.findNode("testLabel")
end sub

sub handleData()
    'm.label.text = m.top.screenData
    m.label.text = "BOBOBOBOB"
end sub
