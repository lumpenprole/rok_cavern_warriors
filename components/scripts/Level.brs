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

    totalRooms = getRandomRange(settings.minRooms, settings.maxRooms)
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
    createCorridoors()

    draw()
    
    m.loadTxt.visible = false
end sub

'Rooms end up being [width, height, x, y]
function createRoom() as Object
    'TODO: Move the room settings into level settings
    appSettings = m.global.settings
    width = getRandomRange(appSettings.room_min_width, appSettings.room_max_width)
    height = getRandomRange(appSettings.room_min_height, appSettings.room_max_height)

    return [width, height]
end function 

sub onPlayerSet()
    tileSize = m.global.settings.tile_size
    m.player = m.playerHolder.findNode("current_player")
    m.playerHolder.translation = [m.upstairs[0] * tileSize, m.upstairs[1] * tileSize]
    m.player.location = m.upstairs

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
        'tileType = m.levelArr[checkLoc[0], checkLoc[1]].split(":")[0]
        'if tileType = "floor"
        if canOccupy(m.levelArr[checkLoc[0], checkLoc[1]])
            m.player.location = checkLoc
        end if
    end if
    
    setTile(m.player, m.playerHolder)

    moveMobs() 
end sub 

sub addMobs()
    totalMobs = 1
    for x = 0 to totalMobs - 1
        ?"Creating Monster #";x.toStr()
        mob = CreateObject("roSGNode", "rcw_Mob")
        mob.id = "monster_ " + x.toStr()
        mob.race = "orc"
        mob.class = "warrior"
        m.mobs.push(mob)
        mRoom = m.sRoom 'Right now it's start room. Change it later
        mobX = getRandomRange(mRoom[2], mRoom[2] + mRoom[0])
        mobY = getRandomRange(mRoom[3], mRoom[3] + mRoom[1])
        mob.location = [mobX, mobY]
        m.mobHolder.appendChild(mob)
        setTile(mob, m.mobHolder)
    end for
end sub

sub moveMobs()
    playerLoc = m.player.location
    
    for y = 0 to m.mobs.count() - 1
        mob = m.mobs[y]
        mobLoc = mob.location
        ?"PLAYERLOC: ";playerLoc
        ?"MOBLOC: ";mobLoc

        if mobLoc[0] < playerLoc[0]
            mobLoc[0] = mobLoc[0] + 1
        else if mobLoc[0] > playerLoc[0]
            mobLoc[0] = mobLoc[0] - 1
        end if

        if mobLoc[1] < playerLoc[1]
            mobLoc[1] = mobLoc[1] + 1
        else if mobLoc[1] > playerLoc[1]
            mobLoc[1] = mobLoc[1] - 1
        end if

        if collisionCheck(mob, mobLoc) <> true
            mob.location = mobLoc
            setTile(mob, m.mobHolder)
        end if
    end for
end sub

function collisionCheck(mob, newPosition)
    if mob.id <> m.player.id 'mob is monster
        if newPosition[0] = m.player.location[0] and newPosition[1] = m.player.location[1]
            fight(mob)
        else
            return false
        end if
    end if
    return true

end function

sub fight(monster)
    ?m.player.class;" FIGHTS ";monster.race;" ";monster.class
end sub

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
    m.sRoom = m.rooms[roomNum]
    upstairX = getRandomRange(m.sRoom[2], m.sRoom[2] + m.sRoom[0])
    upstairY = getRandomRange(m.sRoom[3], m.sRoom[3] + m.sRoom[1])
    ?"UPSTAIRS: ";upstairX.toStr();", ";upstairY.toStr()
    m.levelArr[upstairX][upstairY] = "upstairs:none"
    m.upstairs = [upstairX, upstairY] 'This is so the player can grab the start location easily
end sub

sub createCorridoors()
    m.connections = [] 'this is going to be so I can test that you can get out
    connectedDoors = []
    
    for x = 0 to m.rooms.count() - 1
        connectArray = []
        for y = 0 to m.rooms.count() - 1
            if y <> x
                connectArray.push(m.rooms[y])
            end if
        end for
        connections = rnd(2)
        startRoom = m.rooms[x]
        startCenter = getRoomCenter(startRoom)

        for z = 0 to connections
            if connectArray.count() > 0
                endRoom = connectArray[rnd(connectArray.count() - 1)]
                endCenter = getRoomCenter(endRoom)
                pathFind(startCenter, endCenter)
                connectArray.delete(z)
            end if
        end for

    end for

end sub

sub pathFind(startLoc, endLoc)
    startX = startLoc[0]
    startY = startLoc[1]
    currentDraw = [startX,startY]

    m.levelArr[currentDraw[0]][currentDraw[1]] = "floor:none"
    
    if currentDraw[0] < endLoc[0]
        while currentDraw[0] < endLoc[0]
            currentDraw[0] = currentDraw[0] + 1
            addCorridorFloor(currentDraw[0], currentDraw[1])
        end while
    else 
        while currentDraw[0] > endLoc[0]
            currentDraw[0] = currentDraw[0] - 1
            addCorridorFloor(currentDraw[0], currentDraw[1])
        end while
    end if
    
    if currentDraw[1] < endLoc[1]
        while currentDraw[1] < endLoc[1]
            currentDraw[1] = currentDraw[1] + 1
            addCorridorFloor(currentDraw[0], currentDraw[1])
        end while
    else 
        while currentDraw[1] > endLoc[1]
            currentDraw[1] = currentDraw[1] - 1
            addCorridorFloor(currentDraw[0], currentDraw[1])
        end while
    end if
end sub

sub addCorridorFloor(x, y)
    tileType = m.levelArr[x, y].split(":")[0]
    if tileType <> "upstairs"
        m.levelArr[x, y] = "floor:none"
    end if
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
                    tile = CreateObject("roSGNode", "Rectangle")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.color = "0xFaFF05FF"
                    tile.translation = [tileSize * x, tileSize * y]
                    m.roomHolder.appendChild(tile)
                else if gType = "door"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Rectangle")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.color = "0x28E014FF"
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

function canOccupy(tile)
    arr = tile.split(":")
    tileType = arr[0]
    tileData = arr[1]

    if tileType = "floor" or tileType = "upstairs"
        return true
    else if tileType = "door"
        if tileData = "open"
            return true
        else
            return false
        end if
    else
        return false
    end if
end function 

function contains(item, arr)
    for x = 0 to arr.count() - 1
        if arr[x] = item
            return true
        end if
    end for
    return false
end function

function getRoomCenter(room)
    centerX = cInt(room[0] / 2) + room[2]
    centerY = cInt(room[1] / 2) + room[3]
    return [centerX, centerY]
end function
