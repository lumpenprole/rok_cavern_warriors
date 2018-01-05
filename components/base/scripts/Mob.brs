sub init()
    ?"MOB INIT()"
    m.tileSize = m.global.settings.tile_size
    m.bgHolder = m.top.findNode("bg_holder")
    m.tileHolder = m.top.findNode("tile_holder")
    rect = CreateObject("roSGNode", "Rectangle")
    rect.width = m.tileSize
    rect.height = m.tileSize
    rect.color = "0x276CDBFF"
    m.classSettings = CreateObject("roSGNode", "ClassSettingsNode")
    m.raceSettings = CreateObject("roSGNode", "RaceSettingsNode")
    m.hitPoints = 0
    m.bgHolder.appendChild(rect)
end sub

sub onClassSet()
    class = m.top.class
    m.hitPoints = rnd(m.classSettings.getField(class + "_hit_dice"))
    ?"HIT POINTS FOR ";class;": ";m.hitPoints

    tile = createObject("roSGNode", "Poster")
    tile.loadDisplayMode = "scaleToFill"
    tile.loadWidth = m.tileSize
    tile.loadHeight = m.tileSize
    tile.uri = m.tilePath
    m.tileHolder.appendChild(tile)
    'TODO: Fire post setup after class and race are set.
    postSetup()
end sub

sub onRaceSet()
    ?"onRaceSet()"
end sub

sub postSetup()
    ?"POST SETUP IN ROOT CLASS, OVERRIDE!"
end sub

sub onSeenSet()
    ?"ON SEEN SET FOR: ";m.top.id
    m.tileHolder.visible = m.top.seen
    m.bgHolder.visible = m.top.seen
end sub
