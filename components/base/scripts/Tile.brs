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

        m.img = m.top.findNode("img")
end sub


sub typeChanged()
    'This is probably going to need to be constants and something
    'more generic here. I'd like to have a list of types and a 
    'table of params associated with them and it just gets
    'joined here

    'There's also going to have to be some kind of clever way
    'of associating types with tile art. Later. 

    if m.top.tileType = "floor"
        m.top.canOccupy = true
        m.img.uri = "pkg://locale/default/images/tmp_floor.jpg"
    else if m.top.tileType = "wall"
        m.top.canOccupy = false
        m.img.uri = "pkg://locale/default/images/tmp_wall.jpg"
    end if
end sub
