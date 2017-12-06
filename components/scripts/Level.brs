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

    'Dim level[grid[0][0], grid[0][1]]
    'm.levelArr = level

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
        m.rooms.push(thisRoom)
    end for

    placeRooms()
    createCorridors()

    draw()
    
    m.loadTxt.visible = false
end sub

function createRoom() as Object
    'TODO: Move the room settings into level settings
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

    leftSide = 0
    topSide = 0
    tallestRoomHeight = 0

    'Right now the room placing algo starts at top left and places them left to right, top to bottom. 
    'I might look into something better later. 
    
    row = 1
    newRooms = []

    for r = 0 to m.rooms.count() - 1
        thisRoom = m.rooms[r]
        rWidth = thisRoom[0]
        rHeight = thisRoom[1]
        roomId = "room_" + r.toStr()

        leftEdge = rnd(horizMargin) + leftSide
        'Check if room runs off screen and move down if so       
        if leftEdge + rWidth > m.levelArr.count()
            row++
            if row < 3
                leftEdge = rnd(horizMargin)
                topSide = tallestRoomHeight + 5
            else
                'room is not processed or added to new rooms
                exit for
            end if
        end if

        topEdge = rnd(vertMargin) + topSide

        while topEdge + rHeight >= m.levelArr[0].count()
            topEdge -= 5
        end while

        leftSide = leftEdge + rWidth + rnd(horizMargin) + 5

        rightEdge = leftEdge + rWidth
        bottomEdge = topEdge + rHeight

        if bottomEdge > tallestRoomHeight
            tallestRoomHeight = bottomEdge
        end if
        
        'leftEdge is the left of the room, leftSide is the leftmost placement of the next room
        'Same with topEdge and topSide
        'TODO: Rewrite all these variables so this is clearer and maybe change room to be
        '[x,y,w,h]
        'instead of how it is now, which is:
        '[w,h,x,y]
        
        'Push x,y of room start for later use
        m.rooms[r].push(leftEdge)
        m.rooms[r].push(topEdge)
        newRooms.push(m.rooms[r])
        
        'process room into level array
        for w = leftEdge to rightEdge - 1
            for h = topEdge to bottomEdge - 1
                m.levelArr[w][h] = "floor:" + roomId
                'Add walls 
                if w = leftEdge
                    m.levelArr[w - 1][h] = "wall:none"
                else if w = rightEdge - 1
                    m.levelArr[w + 1][h] = "wall:none"
                end if

                if h = topEdge
                    m.levelArr[w][h - 1] = "wall:none"
                else if h = bottomEdge - 1
                    m.levelArr[w][h + 1] = "wall:none"
                end if
            end for

            'do corners
            m.levelArr[leftEdge - 1][topEdge - 1] = "wall:none"
            m.levelArr[leftEdge - 1][bottomEdge] = "wall:none"
            m.levelArr[rightEdge][topEdge - 1] = "wall:none"
            m.levelArr[rightEdge][bottomEdge] = "wall:none"
        end for
    end for
    
    'rooms array should only contain rooms that were processed
    m.rooms = newRooms

    'set up stairs arbitrairily in the start room
    roomNum = rnd(m.rooms.count() - 1)
    sRoom = m.rooms[roomNum]
    ?"START ROOM ";roomNum;": ";sRoom
    upstairX = rnd(sRoom[0] + 1) + (sRoom[2] - 1)
    upstairY = rnd(sRoom[1] + 1) + (sRoom[3] - 1)
    ?"UPSTAIRS: ";upstairX.toStr();", ";upstairY.toStr()
    m.levelArr[upstairX][upstairY] = "upstairs:none"
    m.upstairs = [upstairX, upstairY] 'This is so the player can grab the start location easily
end sub

sub createCorridors()
    'Make paths between rooms
    for x = 0 to m.rooms.count() - 1
        'TODO: Set door max/min in level settings. 1-3 at the moment
        numOfDoors = rnd(3)
    end for
end sub

sub draw()
    tileSize = m.global.settings.tile_size
    for x = 0 to m.levelArr.count() - 1
    ?"WIDTH: ";m.levelArr.count()
    ?"HEIGHT: ";m.levelArr[x].count()
        for y = 0 to m.levelArr[x].count() - 1
            gridSquare = m.levelArr[x][y]
            'TODO Make this room aware, so that it draws a single rectangle for each room. Maybe.
            if(gridSquare <> invalid)
                gType = gridSquare.split(":")[0]

                if gType = "floor"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    '?"floor: ";name
                    tile = CreateObject("roSGNode", "Rectangle")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.color = "0xEFEEBFFF"
                    tile.translation = [tileSize * x, tileSize * y]
                    m.roomHolder.appendChild(tile)
                else if gType = "wall"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Rectangle")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.color = "0x767B84FF"
                    tile.translation = [tileSize * x, tileSize * y]
                    m.roomHolder.appendChild(tile)
                else if gType = "upstairs"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    '?"STAIRS ARE HERE: ";name
                    tile = CreateObject("roSGNode", "Rectangle")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.color = "0xFaFF05FF"
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
