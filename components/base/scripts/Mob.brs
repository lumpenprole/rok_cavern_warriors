sub init()
    ?"MOB INIT()"
    m.tileSize = m.global.settings.tile_size
    m.bgHolder = m.top.findNode("bg_holder")
    m.tileHolder = m.top.findNode("tile_holder")
    m.bodyArmorHolder = m.top.findNode("body_armor_holder")
    m.pantsHolder = m.top.findNode("pants_holder")
    m.helmetHolder = m.top.findNode("helmet_holder")
    m.glovesHolder = m.top.findNode("gloves_holder")
    m.bootsHolder = m.top.findNode("boots_holder")
    m.mobHolder = m.top.findNode("mob_holder")
    m.hitHolder = m.top.findNode("hit_holder")
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
    m.combatAnimation = m.top.findNode("combat_animation")
    m.combatVector = m.top.findNode("combat_vector")

    'Set up hit graphic
    m.hitHolder.opacity = 0
    hitPath = "pkg:/locale/default/tiles/" + m.global.settings.tileset + "/" + m.global.settings.tilemap.effects.mob_hit
    hitGraphic = createObject("roSGNode", "Poster")
    hitGraphic.loadDisplayMode = "scaleToFill"
    hitGraphic.loadWidth = m.tileSize
    hitGraphic.loadHeight = m.tileSize
    hitGraphic.uri = hitPath
    m.hitHolder.appendChild(hitGraphic)

    m.hitTimer = CreateObject("roSGNode", "Timer")
    m.hitTimer.id = "hitTimer"
    m.hitTimer.repeat = "false"
    m.hitTimer.duration = 0.5
    m.hitTimer.observeField("fire", "killHitGraphic")
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
    m.hitHolder.opacity = 1
    m.hitTimer.control = "start"
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

sub handleCombatAnim()
    dir = m.top.fireCombatAnim
    moveChange = 10

    aX = m.mobHolder.translation[0]
    aY = m.mobHolder.translation[1]

    if dir = "left"
        kV = [[aX, aY], [aX - moveChange, aY], [aX, aY]]
    else if dir = "right"
        kV = [[aX, aY], [aX + moveChange, aY], [aX, aY]]
    else if dir = "up"
        kV = [[aX, aY], [aX, aY - moveChange], [aX, aY]]
    else if dir = "down"
        kV = [[aX, aY], [aX, aY + moveChange], [aX, aY]]
    end if

    m.combatVector.keyValue = kV
    m.combatAnimation.control = "start"
end sub    

sub killHitGraphic()
    m.hitHolder.opacity = 0
    if m.top.class = "monster"
        fireEvent("endTurn", {turnType: "player"})
    else
        fireEvent("endTurn", {turnType: "monster"})
    end if
end sub
