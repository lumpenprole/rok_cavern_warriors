sub init()
    ?"Game Modal Tab: Init()"
    m.top.id = "GameModalTab"
    m.label = m.top.findNode("tabLabel")
end sub

sub handleLabel()
    m.label.text = m.top.labelTxt
end sub

sub handleSelected()
    if m.top.handleSelected
        ?m.lable.text;" IS TRUE"
    else
        ?m.lable.text;" IS FALSE"
    end if
end sub
