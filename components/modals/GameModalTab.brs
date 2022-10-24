sub init()
    ?"Game Modal Tab: Init()"
    m.top.id = "GameModalTab"
    m.label = m.top.findNode("tabLabel")
    m.normalFont = CreateObject("roSGNode", "Font")
    m.boldFont = CreateObject("roSGNode", "Font")
    m.normalFont.uri = "pkg:/locale/default/fonts/Roboto-Regular.ttf"
    m.boldFont.uri = "pkg:/locale/default/fonts/Roboto-Bold.ttf"
    m.normalFont.size = 24
    m.boldFont.size = 24
end sub

sub handleLabel()
    m.label.font = m.normalFont
    m.label.text = m.top.labelTxt
end sub

sub handleSelected()
    if m.top.selected
        m.label.font = m.boldFont
        m.label.text = m.top.labelTxt
    else
        m.label.font = m.normalFont
        m.label.text = m.top.labelTxt
    end if
end sub
