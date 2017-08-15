sub init()
    ?"Level: Init()"
    m.loadTxt = m.top.findNode("loading_text")
    m.roomHolder = m.top.findNode("room_holder")
    m.playerHolder = m.top.findNode("player_holder")
    m.mobHolder = m.top.findNode("mob_holder")
    m.mobs = []

    'TODO: Rewrite this so that it designs the map, then draws it. 
end sub

sub setupLevel()
    settings = m.top.settings

    size = [500,500]
    
    roomStartX = cInt((1920 / 2) - (size[0] / 2))
    roomStartY = cInt((1080 / 2) - (size[1] / 2))

    currentPos = [roomStartX,roomStartY]

    for r = 0 to settings.rooms - 1
        thisRoom = createRoom(size)

        if r = 0 'Currently this is arbitrary
            m.startRoom = thisRoom
        end if

        thisRoom.id = "room_" + r.toStr()
        thisRoom.translation = [roomStartX,roomStartY]
        ?"Holder: ";m.roomHolder
        m.roomHolder.appendChild(thisRoom)
        'm.top.appendChild(thisRoom)
    end for

    m.loadTxt.visible = false
end sub

function createRoom(size as Object) as Object
    'TODO: I need a room object
    room = createObject("roSGNode", "Rectangle")
    room.width = size[0]
    room.height = size[1]
    room.color = "0xABAD96FF"

    return room
end function 

sub onPlayerSet()

    'TODO: Set up tile system and pick a tile
    ?"Room x: ";m.startRoom.translation[0]
    playerStartX = cInt(m.startRoom.translation[0] + (m.startRoom.width / 2))
    ?"player x: ";playerStartX 
    playerStartY = cInt(m.startRoom.translation[1] + (m.startRoom.height / 2))

    m.playerHolder.translation = [playerStartX, playerStartY]

    addMobs()
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    '?"CHAR SELECT KEY: ";key;" PRESS: ";press
    if press then
        if key = "OK"
            handled = true
        else if key = "left" or key = "right" or key = "up" or key = "down"
            playerMove(key)
        end if
    end if
    return handled
end function

sub playerMove(direction as String)
    playerLoc = m.playerHolder.translation
    tileSize = m.global.settings.tile_size

    if direction = "left"
        playerx = playerLoc[0] - tileSize
        playery = playerLoc[1]
    else if direction = "right"
        playerx = playerLoc[0] + tileSize
        playery = playerLoc[1]
    else if direction = "up"
        playerx = playerLoc[0]
        playery = playerLoc[1] - tileSize
    else if direction = "down"
        playerx = playerLoc[0]
        playery = playerLoc[1] + tileSize
    end if
    m.playerHolder.translation = [playerx, playery]
    moveMobs() 
end sub 

sub addMobs()
    totalMobs = 1
    for x = 0 to totalMobs - 1
        ?"Creating Monster #";x.toStr()
        mob = CreateObject("roSGNode", "rcw_Mob")
        mob.id = "monster_ " + x.toStr()
        m.mobs.push(mob)
        playerLoc = m.playerHolder.translation 'Temp to place monster
        mob.translation = [playerLoc[0] + 70, playerLoc[1] + 70]
        m.mobHolder.appendChild(mob)
    end for
end sub

sub moveMobs()
    playerLoc = m.playerHolder.translation 'Temp to place monster
    tileSize = m.global.settings.tile_size
    for y = 0 to m.mobs.count() - 1
        mob = m.mobs[y]
        mobLoc = mob.translation
        if mobLoc[0] < playerLoc[0]
            mobLoc[0] += tileSize
        else
            mobLoc[0] -= tileSize
        end if
        
        if mobLoc[1] < playerLoc[1]
            mobLoc[1] += tileSize
        else
            mobLoc[1] -= tileSize
        end if

        mob.translation = mobLoc
    end for
end sub

