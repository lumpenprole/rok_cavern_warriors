sub init()
    ?"MOB INIT()"
    m.tileHolder = m.top.findNode("tile_holder")
end sub

sub onClassSet()
    'TODO: set class/race tile lookup in it's own place
    class = m.top.class

    tile = createObject("roSGNode", "Poster")
    'TODO: Set tile size via settings for different tiles

    tile.uri = "pkg://locale/default/images/tmp_monster.jpg"
    m.tileHolder.appendChild(tile)
end sub

sub onRaceSet()
    ?"onRaceSet()"
end sub

