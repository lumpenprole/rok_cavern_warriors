sub init()
    ?"MONSTER INIT()"
end sub

sub postSetup()
    tilePath = getTilePath("monster", "orc")
    addTile(tilePath)
end sub
