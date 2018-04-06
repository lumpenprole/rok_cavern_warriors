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

    returnObj = BSP_walkTree(levelArr, settings)

    return returnObj
end function

function BSP_walkTree(levelArr as Object, settings as Object) as Object
    'tree consists of of an array of arrays describing squares
    'each square is an array describing [startX, startY, height, width]
    tree = []
    tree[0] = [[0, 0, levelArr[0].count() - 1, levelArr.count() - 1]]
    depth = settings.maxTreeDepth

    m.dividerBoundary1 = settings.dividerBoundary1
    m.dividerBoundary2 = settings.dividerBoundary2

    for x = 0 to depth - 1
        tree.push(BSP_forkTree(tree[x]))
    end for

    returnObj = BSP_createRooms(tree, levelArr, settings)
    levelArr = BSP_CreateCorridors(returnObj)

    return returnObj
end function

function BSP_forkTree(tree as Object) as Object
    newTree = []
    for x = 0 to tree.count() - 1
        newTree.append(BSP_splitSquare(tree[x]))
    end for

    return newTree
end function

function BSP_splitSquare(square as Object) as Object
    horiz = rnd(2)
    bound1 = m.dividerBoundary1
    bound2 = m.dividerBoundary2
    square1 = []
    square2 = []

    if horiz = 1 'horizontal
        width = square[3]
        height1 = getRandomRange(cInt(square[2] * bound1), cInt(square[2] * bound2))
        height2 = square[2] - height1
        square1 = [square[0], square[1], height1, width]
        square2 = [square[0], square[1] + height1, height2, width]
    else 'vertical
        height = square[2]
        width1 = getRandomRange(cInt(square[3] * bound1), cInt(square[3] * bound2))
        width2 = square[3] - width1
        square1 = [square[0], square[1], height, width1]
        square2 = [square[0] + width1, square[1], height, width2]
    end if

    return [square1, square2]
end function


function BSP_createRooms(tree as Object, levelArr as Object, settings as Object) as Object
    rooms = []
    roomMin = .4
    bottomLevel = tree[tree.count() - 1]

    for s = 0 to bottomLevel.count() - 1
        'each square is an array describing [startX, startY, height, width]
        square = bottomLevel[s]
        if square[2] > 3 and square[3] > 3
            sX = square[0]
            sY = square[1]
            sHeight = square[2]
            sWidth = square[3]
            roomHeight = getRandomRange(cInt(sHeight * roomMin), sHeight)
            roomWidth = getRandomRange(cInt(sWidth * roomMin), sWidth)

            startX = sX + getRandomRange(1, cInt((square[3] - roomWidth) - 1))
            startY = sY + getRandomRange(1, cInt((square[2] - roomHeight) - 1))
            room = [startX, startY, roomHeight, roomWidth]
            rooms.push(room)
        end if
    end for
    
    for r = 0 to rooms.count() - 1
        room = rooms[r]
        roomId = "room_" + r.toStr()

        if room[0] = 0
            room[0] = 1
        end if

        if room[1] = 0
            room[1] = 1
        end if

        if room[0] + room[3] >= levelArr.count()
            room[3] = room[3] - 1
        end if

        if room[1] + room[2] >= levelArr[0].count()
            room[2] = room[2] - 1
        end if

        leftEdge = room[0]
        rightEdge = leftEdge + room[3]
        topEdge = room[1]
        bottomEdge = topEdge + room[2]

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

    'set up stairs arbitrairily in the start room
    upRoomNum = rnd(rooms.count()) - 1
    uRoom = rooms[upRoomNum]
    upLoc = BSP_placeRandomlyInRoom(uRoom)
    levelArr[upLoc[0]][upLoc[1]] = "upstairs:none"
    downRoomNum = upRoomNum

    while downRoomNum = upRoomNum
        downRoomNum = rnd(rooms.count() - 1)
    end while

    dRoom = rooms[downRoomNum]
    dLoc = BSP_placeRandomlyInRoom(dRoom)
    levelArr[dRoom[0]][dRoom[1]] = "downstairs:none"

    return {levelArr:levelArr, rooms:rooms, upstairs:upLoc, downstairs:dLoc}

end function

function BSP_CreateCorridors(holder as Object) as Object
    rooms = holder.rooms
    levelArr = holder.levelArr
    m.connections = [] 'this is going to be so I can test that you can get out
    
    for x = 0 to rooms.count() - 1
        connectArray = []
        for y = 0 to rooms.count() - 1
            if y <> x
                connectArray.push(rooms[y])
            end if
        end for
        connections = rnd(2)
        startRoom = rooms[x]
        startCenter = BSP_getRoomCenter(startRoom)

        for z = 0 to connections
            if connectArray.count() > 0
                endRoom = connectArray[rnd(connectArray.count() - 1)]
                endCenter = BSP_getRoomCenter(endRoom)
                levelArr = BSP_pathFind(startCenter, endCenter, levelArr)
                connectArray.delete(z)
            end if
        end for
        
    end for
    holder.rooms = rooms
    holder.levelArr = levelArr
    return holder
end function

function BSP_pathFind(startLoc, endLoc, levelArr) as Object
    startX = startLoc[0]
    startY = startLoc[1]
    currentDraw = [startX,startY]

    levelArr[currentDraw[0]][currentDraw[1]] = "floor:none"
    
    if currentDraw[0] < endLoc[0]
        while currentDraw[0] < endLoc[0]
            currentDraw[0] = currentDraw[0] + 1
            levelArr = BSP_addCorridorFloor(currentDraw[0], currentDraw[1], levelArr)
        end while
    else 
        while currentDraw[0] > endLoc[0]
            currentDraw[0] = currentDraw[0] - 1
            levelArr = BSP_addCorridorFloor(currentDraw[0], currentDraw[1], levelArr)
        end while
    end if
    
    if currentDraw[1] < endLoc[1]
        while currentDraw[1] < endLoc[1]
            currentDraw[1] = currentDraw[1] + 1
            levelArr = BSP_addCorridorFloor(currentDraw[0], currentDraw[1], levelArr)
        end while
    else 
        while currentDraw[1] > endLoc[1]
            currentDraw[1] = currentDraw[1] - 1
            levelArr = BSP_addCorridorFloor(currentDraw[0], currentDraw[1], levelArr)
        end while
    end if

    return levelArr
end function

sub BSP_addCorridorFloor(x, y, levelArr) as Object
    tileType = levelArr[x, y].split(":")[0]
    if tileType <> "upstairs"
        levelArr[x, y] = "floor:none"
    end if
    return levelArr
end sub

function BSP_getRoomCenter(room)
    'room is an array describing [startX, startY, height, width]
    centerX = cInt(room[3] / 2) + room[0]
    centerY = cInt(room[2] / 2) + room[1]
    return [centerX, centerY]
end function

function BSP_placeRandomlyInRoom(room as Object) as Object
    'room is an array describing [startX, startY, height, width]
    sX = room[0] + 1
    sY = room[1] + 1
    w = sX + (room[3] - 1)
    h = sY + (room[2] - 1)

    newX = getRandomRange(sX, w)
    newY = getRandomRange(sY, h)
    
    return [newX, newY]
end function

 
