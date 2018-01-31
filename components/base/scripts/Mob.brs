sub init()
    ?"MOB INIT()"
    m.tileSize = m.global.settings.tile_size
    m.bgHolder = m.top.findNode("bg_holder")
    m.tileHolder = m.top.findNode("tile_holder")
    m.bodyArmorHolder = m.top.findNode("body_armor_holder")
    rect = CreateObject("roSGNode", "Rectangle")
    rect.width = m.tileSize
    rect.height = m.tileSize
    rect.color = "0x276CDBFF"
    rect.opacity = 0.0
    m.classSettings = CreateObject("roSGNode", "ClassSettingsNode")
    m.raceSettings = CreateObject("roSGNode", "RaceSettingsNode")
    m.bgHolder.appendChild(rect)
    m.mind = rollStat()
    m.strength = rollStat()
    m.dexterity = rollStat()
end sub

sub onClassSet()
    class = m.top.class
    m.top.hitPoints = rnd(m.classSettings.getField(class + "_hit_dice"))
    ?"HIT POINTS FOR ";class;": ";m.top.hitPoints

    'TODO: Fire post setup after class and race are set.
    postSetup()
end sub

sub onRaceSet()
    ?"onRaceSet()"
    postSetup()
end sub

sub postSetup()
    ?"POST SETUP IN ROOT CLASS, OVERRIDE!"
end sub

sub onSeenSet()
    ?"ON SEEN SET FOR: ";m.top.id
    m.tileHolder.visible = m.top.seen
    m.bgHolder.visible = m.top.seen
end sub

sub addTile(path)
    tile = createObject("roSGNode", "Poster")
    tile.loadDisplayMode = "scaleToFill"
    tile.loadWidth = m.tileSize
    tile.loadHeight = m.tileSize
    tile.uri = path
    m.tileHolder.appendChild(tile)
end sub

sub onDamageTaken()
    ?"*********************************************"
    ?"*********************************************"
    ?m.top.id;" TAKES ";m.top.damageTaken;" DAMAGE"
    m.top.hitPoints = m.top.hitPoints - m.top.damageTaken
    ?"HIT POINTS ARE NOW: ";m.top.hitPoints
    ?"*********************************************"
    ?"*********************************************"
    if m.top.hitPoints <= 0
        death()
    end if
end sub

sub death()
    ?"????????????????????????????????????????????"
    ?m.top.id;" HAS DIED"
    ?"????????????????????????????????????????????"
end sub

function getTilePath(tileType as String, tileRace as String, tileSex = "none" as String) as String
    tiles = m.global.settings.tilemap[tileType]
    tilePath = "pkg:/locale/default/tiles/" + m.global.settings.tileset + "/"
    if tileSex <> "none"
        tileRace = tileRace + "_" + tileSex
    end if
    tilePath = tilePath + tiles[tilerace]
    return tilePath
end function

function getStats() as Object
    return [m.mind, m.strength, m.dexterity]
end function

function rollStat() as Integer
    stats = []
    for r = 0 to 4
        stats.push(rnd(6))
    end for
    
    lowest = stats[0]
    remove = 0

    for d = 1 to 4
        if stats[d] < lowest
            lowest = stats[d]
            remove = d
        end if
    end for
    
    stats.delete(remove)

    stat = 0

    for s = 0 to 3
        stat = stat + stats[s]
    end for

    return stat
end function

