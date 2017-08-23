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
    appSettings = m.global.settings
    ?"SETTINGS: ";appSettings

    size = [500,500]
    
    grid = m.global.grid

    currentPos = [100,100]

    totalRooms = rnd(settings.maxRooms - settings.minRooms + 1) + (settings.minRooms - 1)
    unplacedRooms = []
    m.placedRooms = []
    ?"**********************************************"
    ?"TOTAL ROOMS: ";totalRooms
    ?"**********************************************"

    for r = 0 to totalRooms - 1
        thisRoom = createRoom()

        if r = 0 'Currently this is arbitrary
            m.startRoom = thisRoom
        end if

        thisRoom.id = "room_" + r.toStr()
        thisRoom.translation = currentPos
        '?"Holder: ";m.roomHolder
        m.roomHolder.appendChild(thisRoom)
        'm.top.appendChild(thisRoom)
        unplacedRooms.push(thisRoom)
    end for

    placeRooms(unplacedRooms)
    
    m.loadTxt.visible = false
end sub

function createRoom() as Object
    'TODO: I need a room object
    appSettings = m.global.settings
    room = createObject("roSGNode", "Rectangle")
    width = (rnd(appSettings.room_max_width - appSettings.room_min_width) + appSettings.room_min_width) * appSettings.tile_size
    room.width = width
    height = (rnd(appSettings.room_max_height - appSettings.room_min_height) + appSettings.room_min_height) * appSettings.tile_size
    room.height = height
    room.color = "0xABAD96FF"

    return room
end function 

sub onPlayerSet()

    'TODO: Set up tile system and pick a tile
    '?"Room x: ";m.startRoom.translation[0]
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

    if collisionCheck(m.playerHolder, [playerx, playery])
        m.playerHolder.translation = [playerx, playery]
    end if

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
        
        if collisionCheck(mob, mobLoc)
            mob.translation = mobLoc
        end if
    end for
end sub

function collisionCheck(mob, newPosition)
    if mob.id <> m.playerHolder.id
        if m.playerHolder.translation[0] = newPosition[0] and m.playerHolder.translation[1] = newPosition[1]
            return false
        end if
    end if

    for z = 0 to m.mobs.count() - 1
        otherMob = m.mobs[z]
        if mob.id <> otherMob.id
            if newPosition[0] = otherMob.translation[0] and newPosition[1] = otherMob.translation[1]
                return false
            end if
        end if
    end for

        return true
end function

sub placeRooms(rooms)
    appSettings = m.global.settings
    grid = m.global.grid

    while rooms.count() > 0
        thisRoom = rooms[0]
        col = rnd(grid[0][0]) - 1
        row = rnd(grid[0][1]) - 1
        margin = m.top.settings.roomMargin
        tileSize = appSettings.tile_size
        currentPos = getTileXY(grid, [col, row], tileSize)
        if currentPos[0] + thisRoom.width > (grid[0][0] * tileSize) - (margin * tileSize)
            currentPos[0] = currentPos[0] - (tileSize * margin)
        end if

        if currentPos[1] + thisRoom.height > (grid[0][1] * tileSize) - (margin * tileSize)
            currentPos[1] = currentPos[1] - (tileSize * margin)
        end if

        'Do collision check
        
        thisRoom.translation = currentPos
        m.placedRooms.push(rooms.shift())
    end while
    
end sub

