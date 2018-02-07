function BSP_LevelCreator()
    if m.bsp_levelCreator = invalid
        m.bsp_levelCreator = {
            BSPCreate: BSP_create
        }
    end if
    return m.bsp_levelCreator
end function

function BSP_create(settings as Dynamic, grid as Object) as Object
    returnObj = {rooms:[],levelArr:[]}

    levelArr = []
    for x = 0 to grid[0][0] - 1
        levelArr[x] = []
        for y = 0 to grid[0][1] - 1
            levelArr[x][y] = "none:none"
        end for
    end for

    returnObj = walkTree(levelArr, settings)

    return returnObj
end function

function walkTree(levelArr as Object, settings as Object) as Object
    'tree consists of of an array of arrays describing squares
    'each square is an array describing [startX, startY, height, width]
    tree = []
    'depth = settings.maxTreeDepth
    depth = 4

    for x = 0 to depth - 1
        tree.push(forkTree(tree, levelArr))
    end for


    returnObj = createRooms(tree, levelArr, settings)
    'levelArr = placeRooms(levelArr, rooms)
    'levelArr = createCorridors(levelArr, rooms)

    return returnObj
end function

function forkTree(tree as Object, levelArr as Object) as Object
    newTree = []
    if tree.count() = 0
        'create first division
        square = [0, 0, levelArr[0].count(), levelArr.count()]
        dObj = getRandomDivider(square)
        divider = dObj.divider

        if dObj.direction = "horizontal"
            newTree = [[0, 0, divider[1], levelArr.count()], [0, divider[1], (square[2] - divider[1]), square[3]]]
        else if dObj.direction = "vertical"
            newTree = [[0, 0, square[3], divider[0]], [divider[0], 0, square[2], square[3] - divider[0]]]
        end if
    else
        currentTree = tree[tree.count() - 1]
        for d = 0 to currentTree.count() - 1
            'randomly split each box
            thisBox = currentTree[d]
            dObj = getRandomDivider(thisBox)
            divider = dObj.divider
            if dObj.direction = "horizontal"
                newTree.push([thisBox[0], thisBox[1], divider[1] - thisBox[1], divider[2] - thisbox[0]])
                newTree.push([divider[0], divider[1] + 1, thisBox[2] - divider[1], divider[2] - thisbox[0] ])
            else if dObj.direction = "vertical"
                newTree.push([thisBox[0], thisBox[1], thisBox[2], divider[0] - thisBox[0]])
                newTree.push([divider[0] + 1, divider[1], thisBox[2], thisBox[3] - divider[0]])
            end if
        end for
    end if

    return newTree
end function

function getRandomDivider(square as Object) as Object
    'The divider is described by four integers representing the beginning and end point
    horiz = rnd(2)
    height = square[2]
    width = square[3]
    bound1 = .35
    bound2 = .65
    direction = "none"
    if horiz = 1 
        direction = "horizontal"
        x = square[0]
        y = getRandomRange(cInt(height * bound1), cInt(height * bound2))
        divider = [x, y, x + width, y]
    else
        direction = "vertical"
        y = square[1]
        x = getRandomRange(cInt(width * bound1), cInt(width * bound2))
        divider = [x, y, x, y + height]
    end if

    return {divider: divider, direction: direction}
end function

function createRooms(tree as Object, levelArr as Object, settings as Object) as Object
    rooms = []
    roomMin = .4
    bottomLevel = tree[tree.count() - 1]
    
    for s = 0 to bottomLevel.count() - 1
        square = bottomLevel[s]
        ?"SQUARE: ";square
        sX = square[0]
        sY = square[1]
        sHeight = square[2]
        sWidth = square[3]
        roomHeight = getRandomRange(cInt(sHeight * roomMin), sHeight)
        roomWidth = getRandomRange(cInt(sWidth * roomMin), sWidth)

        startX = sX + getRandomRange(1, cInt((square[3] - roomWidth) - 1))
        startY = sY + getRandomRange(1, cInt((square[2] - roomHeight) - 1))
        room = [startX, startY, roomHeight, roomWidth]
        ?"ROOM ";s.toStr();": ";room
        rooms.push(room)
    end for
    
    for r = 0 to rooms.count() - 1
        room = rooms[r]
        roomId = "room_" + r.toStr()
        leftEdge = room[0]
        rightEdge = leftEdge + room[3]
        topEdge = room[1]
        bottomEdge = topEdge + room[2]

        if leftEdge = 0
            leftEdge = 1
        end if

        if topEdge = 0
            topEdge = 1
        end if

        if rightEdge = levelArr.count()
            rightEdge = levelArr.count() - 1
        end if

        if bottomEdge = levelArr[0].count()
            bottomEdge = levelArr[0].count() - 1
        end if


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
            'levelArr[leftEdge - 1][topEdge - 1] = "wall:none"
            'levelArr[leftEdge - 1][bottomEdge] = "wall:none"
            'levelArr[rightEdge][topEdge - 1] = "wall:none"
            'levelArr[rightEdge][bottomEdge] = "wall:none"
        end for
    end for

    'set up stairs arbitrairily in the start room
    upRoomNum = rnd(rooms.count()) - 1
    uRoom = rooms[upRoomNum]
    upstairX = getRandomRange(uRoom[0], uRoom[3] + uRoom[0])
    upstairY = getRandomRange(uRoom[1], uRoom[2] + uRoom[1])
    levelArr[upstairX][upstairY] = "upstairs:none"
    downRoomNum = upRoomNum

    while downRoomNum = upRoomNum
        downRoomNum = rnd(rooms.count() - 1)
    end while

    dRoom = rooms[downRoomNum]
    downstairX = getRandomRange(dRoom[2], dRoom[2] + dRoom[0])
    downstairY = getRandomRange(dRoom[3], dRoom[3] + dRoom[1])
    levelArr[downstairX][downstairY] = "downstairs:none"

    return {levelArr:levelArr, rooms:rooms, upstairs:[upstairX, upstairY], downstairs:[downstairX, downstairY]}

end function

'Rooms end up being [width, height, x, y]
function _createRoom() as Object
    'TODO: Move the room settings into level settings
    appSettings = m.global.settings
    width = getRandomRange(appSettings.room_min_width, appSettings.room_max_width)
    height = getRandomRange(appSettings.room_min_height, appSettings.room_max_height)

    return [width, height]
end function 

function _placeRooms(holder as Object) as Object
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

function _createCorridoors(holder as Object) as Object
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

function _pathFind(startLoc, endLoc, levelArr) as Object
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

sub _addCorridorFloor(x, y, levelArr) as Object
    tileType = levelArr[x, y].split(":")[0]
    if tileType <> "upstairs"
        levelArr[x, y] = "floor:none"
    end if
    return levelArr
end sub

