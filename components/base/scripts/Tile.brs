sub init()
    setup()
end sub

sub setup()
    fields = {
        tileType: "floor",
        canOccupy: true,
        mob: false,
        effect: "none"
        }
        m.top.addFields(fields)
        m.top.observeField("tileType", "typeChanged")
end sub


sub typeChanged()
    'This is probably going to need to be constants and something
    'more generic here. I'd like to have a list of types and a 
    'table of params associated with them and it just gets
    'joined here

    if m.top.tileType = "floor"
        m.top.canOccupy = true
    else if m.top.tileType = "wall"
        m.top.canOccupy = false
    end if
end sub
