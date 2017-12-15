sub init()
    ?"MOB INIT()"
    m.tileSize = m.global.settings.tile_size
    m.bgHolder = m.top.findNode("bg_holder")
    m.tileHolder = m.top.findNode("tile_holder")
    rect = CreateObject("roSGNode", "Rectangle")
    rect.width = m.tileSize
    rect.height = m.tileSize
    rect.color = "0x276CDBFF"
    m.bgHolder.appendChild(rect)
end sub

sub onClassSet()
    'TODO: set class/race tile lookup in it's own place
    class = m.top.class
    tile = createObject("roSGNode", "Poster")
    'TODO: Set tile size via settings for different tiles
    tile.loadDisplayMode = "scaleToFill"
    tile.loadWidth = m.tileSize
    tile.loadHeight = m.tileSize
    tile.uri = "pkg://locale/default/images/tmp_monster.png"
    m.tileHolder.appendChild(tile)
end sub

sub onRaceSet()
    ?"onRaceSet()"
end sub

