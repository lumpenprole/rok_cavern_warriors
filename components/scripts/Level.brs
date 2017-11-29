sub init()
    ?"Level: Init()"
    m.loadTxt = m.top.findNode("loading_text")
    m.roomHolder = m.top.findNode("room_holder")
    m.playerHolder = m.top.findNode("player_holder")
    m.mobHolder = m.top.findNode("mob_holder")
    m.mobs = []
end sub

sub setupLevel()
    settings = m.top.settings
    appSettings = m.global.settings
    
    grid = m.global.grid

    m.levelArr = []
    for x = 0 to grid[0][0] - 1
        m.levelArr[x] = []
        for y = 0 to grid[0][1] - 1
            m.levelArr[x][y] = "none:none"
        end for
    end for

    currentPos = [100,100]

    totalRooms = rnd(settings.maxRooms - settings.minRooms + 1) + (settings.minRooms - 1)
    m.rooms = []

    ?"**********************************************"
    ?"TOTAL ROOMS: ";totalRooms
    ?"**********************************************"

    'Currently this is arbitrary
    m.startRoom = 0

    for r = 0 to totalRooms - 1
        thisRoom = createRoom()

        'thisRoom.id = "room_" + r.toStr()
        'thisRoom.translation = currentPos
        '?"Holder: ";m.roomHolder
        'm.roomHolder.appendChild(thisRoom)
        'm.top.appendChild(thisRoom)
        m.rooms.push(thisRoom)
    end for

    placeRooms()
    createCorridors()

    draw()
    
    m.loadTxt.visible = false
end sub

function createRoom() as Object
    appSettings = m.global.settings
    width = rnd(appSettings.room_max_width - appSettings.room_min_width) + appSettings.room_min_width 
    height = rnd(appSettings.room_max_height - appSettings.room_min_height) + appSettings.room_min_height

    return [width, height]
end function 

sub onPlayerSet()
    tileSize = m.global.settings.tile_size
    m.player = m.playerHolder.findNode("current_player")
    m.playerHolder.translation = [m.upstairs[0] * tileSize, m.upstairs[1] * tileSize]
    m.player.location = m.upstairs

    'addMobs()
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

    ploc = m.player.location
    checkLoc = []
    if direction = "left"
        checkLoc = [ploc[0] - 1, ploc[1]]
    else if direction = "right"
        checkLoc = [ploc[0] + 1, ploc[1]]
    else if direction = "down"
        checkLoc = [ploc[0], ploc[1] + 1]
    else if direction = "up"
        checkLoc = [ploc[0], ploc[1] - 1]
    end if
    
    if m.levelArr[checkLoc[0], checkLoc[1]] <> invalid
        tileType = m.levelArr[checkLoc[0], checkLoc[1]].split(":")[0]
        if tileType = "floor"
            m.player.location = checkLoc
        end if
    end if
    
    setTile(m.player, m.playerHolder)

    'moveMobs() 
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
    horizDirection = "" 
    horizTotal = 0
    vertDirection = ""
    vertTotal = 0

    for y = 0 to m.mobs.count() - 1
        mob = m.mobs[y]
        mobLoc = mob.translation
        ?"MOBLOC: ";mobLoc
        ?"MOB: ";mob
        if mobLoc[0] < playerLoc[0]
            horizDirection = "right"
            horizTotal = playerLoc[0] - mobLoc[0]
        else
            horizDirection = "left"
            horizTotal = mobLoc[0] - playerLoc[0]
        end if
        
        if mobLoc[1] < playerLoc[1]
            vertDirection = "down"
            vertTotal = playerLoc[1] - mobLoc[1]
        else
            vertDirection = "up"
            vertTotal = mobLoc[1] - playerLoc[1]
        end if

        if vertTotal > horizTotal
            mobLoc = getNextTile(vertDirection, mobLoc)
        else
            mobLoc = getNextTile(horizDirection, mobLoc)
        end if
        
        ?"MOBLOC: ";mobLoc
        ?"MOB: ";mob

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
            if Int(newPosition[0]) = otherMob.translation[0] and Int(newPosition[1]) = otherMob.translation[1]
                return false
            end if
        end if
    end for

        return true
end function

sub placeRooms()
    appSettings = m.global.settings
    grid = m.global.grid
    tileSize = appSettings.tile_size

    horizMargin = 5
    vertMargin = 10

    for r = 0 to m.rooms.count() - 1
        roomUnplaced = true
        checkedRooms = 0
        rWidth = m.rooms[r][0]
        rHeight = m.rooms[r][1]

        while roomUnplaced
            'place room
            startX = rnd(m.levelArr.count() - rWidth)
            startY = rnd(m.levelArr[0].count() - rHeight)

            for c = r - 1 to 0 step -1
                    checkRoom = m.rooms[c]
                    if (startX > checkRoom[2] and startX < checkRoom[2] + checkRoom[0]) and (startY > checkRoom[3] and startY < checkRoom[3] + checkRoom[1])
                        ?"))))))))))))))))))))))))))))))))))))))))))))))))"
                        ?"))))))))))))))))))))))))))))))))))))))))))))))))"
                        ?"COLLIDED"
                        ?"))))))))))))))))))))))))))))))))))))))))))))))))"
                        ?"))))))))))))))))))))))))))))))))))))))))))))))))"
                        exit for
                    end if
                    checkedRooms++
                    ?"CHECKED ROOMS: " + checkedRooms.toStr()
            end for

            if checkedRooms = r
                roomUnplaced = false
                m.rooms[r].push(startX)
                m.rooms[r].push(startY)
                putRoomInGrid(m.rooms[r], r)
            end if
        end while
    end for


    'set up stairs arbitrairily in the start room
    sRoom = m.rooms[m.startRoom]
    upstairX = rnd(sRoom[0]) + sRoom[2]
    upstairY = rnd(sRoom[1]) + sRoom[3]
    m.levelArr[upstairX][upstairY] = "upstairs:none"
    m.upstairs = [upstairX, upstairY] 'This is so the player can grab the start location easily

end sub

sub createCorridors()
    'Make paths between rooms
end sub

sub draw()
    tileSize = m.global.settings.tile_size
    for x = 0 to m.levelArr.count() - 1
        for y = 0 to m.levelArr[x].count() - 1
            gridSquare = m.levelArr[x][y]
            'TODO Make this room aware, so that it draws a single rectangle for each room. Maybe.
            if(gridSquare <> invalid)
                gType = gridSquare.split(":")[0]

                if gType = "floor"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Rectangle")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.color = "0xEFEEBFFF"
                    tile.translation = [tileSize * x, tileSize * y]
                    m.roomHolder.appendChild(tile)
                end if
            end if
        end for
    end for
end sub

sub setTile(tile, holder)
    tileSize = m.global.settings.tile_size
    holder.translation = [tile.location[0] * tileSize, tile.location[1] * tileSize]
end sub

sub putRoomInGrid(room, id)
    for x = room[2] to room[2] + room[0]
        for y = room[3] to room[3] + room[1]
            m.levelArr[x][y] = "floor:room_" + id.toStr()
        end for
    end for
end sub
