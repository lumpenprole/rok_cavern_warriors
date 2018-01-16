sub init()
    m.loadTxt = m.top.findNode("loading_text")
    m.roomHolder = m.top.findNode("room_holder")
    m.playerHolder = m.top.findNode("player_holder")
    m.monsterHolder = m.top.findNode("monster_holder")
    m.monsters = []
    m.playerHasDied = false
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

    addMonsters()
end sub

sub onPlayerStairs()
    tileSize = m.global.settings.tile_size
    m.player = m.playerHolder.findNode("current_player")
    if m.top.playerStairs = "down"
        m.playerHolder.translation = [m.upstairs[0] * tileSize, m.upstairs[1] * tileSize]
        m.player.location = m.upstairs
    else if m.top.playerStairs = "up"
        m.playerHolder.translation = [m.downstairs[0] * tileSize, m.downstairs[1] * tileSize]
        m.player.location = m.downstairs
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press then
        if key = "OK"
            if not m.playerHasDied
                checkActOnTile()
                handled = true
            end if
        else if key = "left" or key = "right" or key = "up" or key = "down"
            playerMove(key)
        end if
    end if
    ?"HANDLED: ";handled
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
        if collisionCheck(m.player, checkLoc) <> true
            if canOccupy(checkLoc)
                m.player.location = checkLoc
            end if
        end if
    end if
    setTile(m.player, m.playerHolder)

    makeVisible(m.player.location, m.player.sightDistance)
    moveMonsters() 
end sub 

sub addMonsters()
    totalMonsters = rnd(7)
    'totalMonsters = 1
    for x = 0 to totalMonsters - 1
        monster = CreateObject("roSGNode", "rcw_Monster")
        monster.id = "monster_" + x.toStr()
        monster.race = "orc"
        monster.class = "warrior"
        m.monsters.push(monster)
        mRoom = m.rooms[rnd(m.rooms.count()) - 1] 
        monsterX = getRandomRange(mRoom[2], mRoom[2] + mRoom[0])
        monsterY = getRandomRange(mRoom[3], mRoom[3] + mRoom[1])
        monster.location = [monsterX, monsterY]
        'TODO: Change player move to this model. I don't think we need the holders. 
        'm.monsterHolder.appendChild(monster)
        m.top.appendChild(monster)
        tileSize = m.global.settings.tile_size
        monster.translation = [monster.location[0] * tileSize, monster.location[1] * tileSize]
        monster.seen = false
        'setTile(monster, m.monsterHolder)
    end for
    'This is set here so that monsters will be made visible if appropriate
    makeVisible(m.player.location, m.player.sightDistance) 
end sub

sub moveMonsters()
    playerLoc = m.player.location
    
    for y = 0 to m.monsters.count() - 1
        if m.monsters[y] = invalid exit for
        monster = m.monsters[y]
        if checkMonsterSeesPlayer(monster, playerLoc)
            monsterLoc = monster.location
            newLoc = [playerLoc[0], playerLoc[1]]

            if monsterLoc[0] < playerLoc[0]
                newLoc[0] = monsterLoc[0] + 1
            else if monsterLoc[0] > playerLoc[0]
                newLoc[0] = monsterLoc[0] - 1
            end if

            if monsterLoc[1] < playerLoc[1]
                newLoc[1] = monsterLoc[1] + 1
            else if monsterLoc[1] > playerLoc[1]
                newLoc[1] = monsterLoc[1] - 1
            end if

            if canOccupy(newLoc)
                if collisionCheck(monster, newLoc) <> true
                    monster.location = newLoc
                    tileSize = m.global.settings.tile_size
                    monster.translation = [monster.location[0] * tileSize, monster.location[1] * tileSize]
                end if
            else if canOccupy([monsterLoc[0], newLoc[1]])
                monster.location = [monsterLoc[0], newLoc[1]]
                setTile(monster, m.monsterHolder)
            else if canOccupy([newLoc[0], monsterLoc[1]])
                monster.location = [newLoc[0], monsterLoc[1]]
                setTile(monster, m.monsterHolder)
            end if
        end if
    end for
end sub

function collisionCheck(monster, newPosition)
    if monster.id <> m.player.id 'monster is monster
        if newPosition[0] = m.player.location[0] and newPosition[1] = m.player.location[1]
            fight(monster, m.player)
        else
            return false
        end if
    else 'monster is player
        for x = 0 to m.monsters.count() - 1
            thisMonster = m.monsters[x]
            if newPosition[0] = thisMonster.location[0] and newPosition[1] = thisMonster.location[1]
                fight(m.player, thisMonster)
                return true
            end if
        end for
        return false
    end if
    return true

end function

sub fight(attacker, defender)
    ?attacker.class;" FIGHTS ";defender.race;" ";defender.class
    hit = rnd(attacker.hitDice) > defender.armorClass 
    m.player.hitPoints = -1 
    if hit
        defender.damageTaken = rnd(attacker.damageDice)
        if defender.id = "current_player"
            fireEvent("statusUpdate")
        end if
        if defender.hitPoints <= 0
            if defender.id = "current_player"
                playerDead()
            else
                monsterDead(defender)
            end if
        end if
    end if
end sub

sub monsterDead(monster)
    ?"MONSTER ";monster.id;" DIES"
    m.top.removeChild(monster)
    for x = 0 to m.monsters.count() - 1
        if m.monsters[x].id = monster.id
            m.monsters.delete(x)
            exit for
        end if
    end for
end sub

sub playerDead()
    m.playerHasDied = true
    fireEvent("systemMessage", {messageText:"YOU HAVE DIED"}) 
end sub

function checkMonsterSeesPlayer(monster, playerLoc) as Boolean
    if monster.seenPlayer 
        return true 
    else
        monsterLoc = monster.location
        if abs(monsterLoc[0] - playerLoc[0]) <= monster.sightLine and abs(monsterLoc[1] - playerLoc[1]) <= monster.sightLine
            monster.seenPlayer = true
            return true
        else
            return false
        end if
    end if
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
    upRoomNum = rnd(m.rooms.count() - 1)
    uRoom = m.rooms[upRoomNum]
    upstairX = getRandomRange(uRoom[2], uRoom[2] + uRoom[0])
    upstairY = getRandomRange(uRoom[3], uRoom[3] + uRoom[1])
    m.levelArr[upstairX][upstairY] = "upstairs:none"
    m.upstairs = [upstairX, upstairY] 'This is so the player can grab the start location easily
    downRoomNum = upRoomNum

    while downRoomNum = upRoomNum
        downRoomNum = rnd(m.rooms.count() - 1)
    end while

    dRoom = m.rooms[downRoomNum]
    downstairX = getRandomRange(dRoom[2], dRoom[2] + dRoom[0])
    downstairY = getRandomRange(dRoom[3], dRoom[3] + dRoom[1])
    m.levelArr[downstairX][downstairY] = "downstairs:none"
    m.downstairs = [downstairX, downstairY] 'This is so the player can grab the start location easily

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
                
                'TODO: need to move tile creation into a separate function
                'and set colors and tiles in the settings
                if gType = "floor"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Rectangle")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.color = "0xEFEEBFFF"
                    tile.translation = [tileSize * x, tileSize * y]
                    tile.id = name
                    tile.visible = false
                    m.roomHolder.appendChild(tile)
                else if gType = "wall"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Rectangle")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.color = "0x767B84FF"
                    tile.translation = [tileSize * x, tileSize * y]
                    tile.id = name
                    tile.visible = false
                    m.roomHolder.appendChild(tile)
                else if gType = "upstairs"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Rectangle")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.color = "0xFaFF05FF"
                    tile.translation = [tileSize * x, tileSize * y]
                    tile.id = name
                    tile.visible = false
                    m.roomHolder.appendChild(tile)
                else if gType = "downstairs"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Rectangle")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.color = "0x009900FF"
                    tile.translation = [tileSize * x, tileSize * y]
                    tile.id = name
                    tile.visible = false
                    m.roomHolder.appendChild(tile)
                else if gType = "door"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Rectangle")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.color = "0x28E014FF"
                    tile.translation = [tileSize * x, tileSize * y]
                    tile.id = name
                    tile.visible = false
                    m.roomHolder.appendChild(tile)
                end if
            end if
        end for
    end for
end sub

sub makeVisible(location, sightDistance)
    'TODO: Make sight area into some kind of sphere instead of square
    startX = location[0] - sightDistance
    if startX < 0
        startX = 0
    end if
    startY = location[1] - sightDistance
    if startY < 0
        startY = 0
    end if
    endX = location[0] + sightDistance
    if endX > m.levelArr.count() - 1
        endX = m.levelArr.count() - 1
    end if
    endY = location[1] + sightDistance
    if endY > m.levelArr[0].count() - 1
        endY = m.levelArr[0].count() - 1
    end if

    for x = startX to endX
        for y = startY to endY
            if m.levelArr[x][y] <> invalid and m.levelArr[x][y] <> "none:none"
                tile = m.roomHolder.findNode("tile_" + x.toStr() + "_" + y.toStr())
                if not tile.visible
                    tile.visible = true
                end if
                for z = 0 to m.monsters.count() - 1
                    monster = m.monsters[z]
                    if monster.seen = false
                        if monster.location[0] = x and monster.location[1] = y
                            monster.seen = true
                        end if
                    end if
                end for
            end if
        end for
    end for

end sub

sub setTile(tile, holder)
    tileSize = m.global.settings.tile_size
    holder.translation = [tile.location[0] * tileSize, tile.location[1] * tileSize]
end sub

function canOccupy(tileLoc)
    tile = m.levelArr[tileLoc[0], tileLoc[1]]
    arr = tile.split(":")
    tileType = arr[0]
    tileData = arr[1]

    if tileType = "floor" or tileType = "upstairs" or tileType = "downstairs"
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

sub checkActOnTile()
    ploc = m.player.location
    tile = m.levelArr[pLoc[0], pLoc[1]]
    arr = tile.split(":")
    tileType = arr[0]
    tileData = arr[1]
    if tileType = "downstairs"
        fireEvent("goDownstairs", {}) 
    else if tileType = "upstairs"
        fireEvent("goUpstairs", {}) 
    end if
end sub

