function LevelCreator()
    if m.levelCreator = invalid
        m.levelCreator = {
            create: _create
        }
    end if
    return m.levelCreator
end function

function _create(settings as Dynamic, grid as Object) as Object
    levelArr = []
    for x = 0 to grid[0][0] - 1
        levelArr[x] = []
        for y = 0 to grid[0][1] - 1
            levelArr[x][y] = "none:none"
        end for
    end for

    currentPos = [100,100]

    totalRooms = getRandomRange(settings.minRooms, settings.maxRooms)
    rooms = []

    'Currently this is arbitrary
    m.startRoom = 0

    for r = 0 to totalRooms - 1
        ?"TOTAL ROOMS ";totalRooms;" THIS IS ROOM # ";r
        thisRoom = createRoom()
        rooms.push(thisRoom)
    end for
    returnObj = {rooms:rooms,levelArr:levelArr}

    returnObj = placeRooms(returnObj)
    returnObj = createCorridoors(returnObj)

    return returnObj
end function

'Rooms end up being [width, height, x, y]
function createRoom() as Object
    'TODO: Move the room settings into level settings
    appSettings = m.global.settings
    width = getRandomRange(appSettings.room_min_width, appSettings.room_max_width)
    height = getRandomRange(appSettings.room_min_height, appSettings.room_max_height)

    return [width, height]
end function 

function placeRooms(holder as Object) as Object
    rooms = holder.rooms
    levelArr = holder.levelArr
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

    for r = 0 to rooms.count() - 1
        thisRoom = rooms[r]
        rWidth = thisRoom[0]
        rHeight = thisRoom[1]
        roomId = "room_" + r.toStr()

        leftEdge = rnd(horizMargin) + leftSide
        'Check if room runs off screen and move down if so       
        if leftEdge + rWidth > levelArr.count()
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

        while topEdge + rHeight >= levelArr[0].count()
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
        rooms[r].push(leftEdge)
        rooms[r].push(topEdge)
        newRooms.push(rooms[r])
        
        'process room into level array
        for w = leftEdge to rightEdge - 1
            for h = topEdge to bottomEdge - 1
                levelArr[w][h] = "floor:" + roomId
                'Add walls 
                if w = leftEdge
                    levelArr[w - 1][h] = "wall:none"
                else if w = rightEdge - 1
                    levelArr[w + 1][h] = "wall:none"
                end if

                if h = topEdge
                    levelArr[w][h - 1] = "wall:none"
                else if h = bottomEdge - 1
                    levelArr[w][h + 1] = "wall:none"
                end if
            end for

            'do corners
            levelArr[leftEdge - 1][topEdge - 1] = "wall:none"
            levelArr[leftEdge - 1][bottomEdge] = "wall:none"
            levelArr[rightEdge][topEdge - 1] = "wall:none"
            levelArr[rightEdge][bottomEdge] = "wall:none"
        end for
    end for
    
    'rooms array should only contain rooms that were processed
    rooms = newRooms

    'set up stairs arbitrairily in the start room
    upRoomNum = rnd(rooms.count() - 1)
    uRoom = rooms[upRoomNum]
    upstairX = getRandomRange(uRoom[2], uRoom[2] + uRoom[0])
    upstairY = getRandomRange(uRoom[3], uRoom[3] + uRoom[1])
    levelArr[upstairX][upstairY] = "upstairs:none"
    m.upstairs = [upstairX, upstairY] 'This is so the player can grab the start location easily
    downRoomNum = upRoomNum

    'TODO: Fix level placement so that this situation never arises. But sometimes I end up with
    'two rooms, and the while loops really hard and sometimes crashes. Also, I don't think you 
    'should ever have only two rooms, but that's an issue to resolve when I redo levels. 
    if rooms.count() = 2
        if upRoomNum = 1
            downRoomNum = 2
        else
            downRoomNum = 1
        end if
    else
        while downRoomNum = upRoomNum
            downRoomNum = rnd(rooms.count() - 1)
        end while
    end if

    dRoom = rooms[downRoomNum]
    downstairX = getRandomRange(dRoom[2], dRoom[2] + dRoom[0])
    downstairY = getRandomRange(dRoom[3], dRoom[3] + dRoom[1])
    levelArr[downstairX][downstairY] = "downstairs:none"
    m.downstairs = [downstairX, downstairY] 'This is so the player can grab the start location easily

    return {rooms:rooms, levelArr:levelArr}
end function

function createCorridoors(holder as Object) as Object
    rooms = holder.rooms
    levelArr = holder.levelArr
    m.connections = [] 'this is going to be so I can test that you can get out
    connectedDoors = []
    
    for x = 0 to rooms.count() - 1
        connectArray = []
        for y = 0 to rooms.count() - 1
            if y <> x
                connectArray.push(rooms[y])
            end if
        end for
        connections = rnd(2)
        startRoom = rooms[x]
        startCenter = getRoomCenter(startRoom)

        for z = 0 to connections
            if connectArray.count() > 0
                endRoom = connectArray[rnd(connectArray.count() - 1)]
                endCenter = getRoomCenter(endRoom)
                levelArr = pathFind(startCenter, endCenter, levelArr)
                connectArray.delete(z)
            end if
        end for
    end for
    return {rooms:rooms, levelArr:levelArr}
end function

function pathFind(startLoc, endLoc, levelArr) as Object
    startX = startLoc[0]
    startY = startLoc[1]
    currentDraw = [startX,startY]

    levelArr[currentDraw[0]][currentDraw[1]] = "floor:none"
    
    if currentDraw[0] < endLoc[0]
        while currentDraw[0] < endLoc[0]
            currentDraw[0] = currentDraw[0] + 1
            levelArr = addCorridorFloor(currentDraw[0], currentDraw[1], levelArr)
        end while
    else 
        while currentDraw[0] > endLoc[0]
            currentDraw[0] = currentDraw[0] - 1
            levelArr = addCorridorFloor(currentDraw[0], currentDraw[1], levelArr)
        end while
    end if
    
    if currentDraw[1] < endLoc[1]
        while currentDraw[1] < endLoc[1]
            currentDraw[1] = currentDraw[1] + 1
            levelArr = addCorridorFloor(currentDraw[0], currentDraw[1], levelArr)
        end while
    else 
        while currentDraw[1] > endLoc[1]
            currentDraw[1] = currentDraw[1] - 1
            levelArr = addCorridorFloor(currentDraw[0], currentDraw[1], levelArr)
        end while
    end if

    return levelArr
end function

sub addCorridorFloor(x, y, levelArr) as Object
    tileType = levelArr[x, y].split(":")[0]
    if tileType <> "upstairs"
        levelArr[x, y] = "floor:none"
    end if
    return levelArr
end sub

