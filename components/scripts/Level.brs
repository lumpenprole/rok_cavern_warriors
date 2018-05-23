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

    'creator = LevelCreator()
    'levelHolder = creator.create(settings, grid)

    creator = BSP_LevelCreator()
    levelHolder = creator.BSPCreate(settings, grid)

    m.rooms = levelHolder.rooms
    m.levelArr = levelHolder.levelArr
    m.upstairs = levelHolder.upstairs
    m.downstairs = levelHolder.downstairs

    draw()
    printLevel(m.levelArr)

    m.loadTxt.visible = false
end sub

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
        else if key = "play"
            pd = getPlayerData()
            fireEvent("handleGameModalOnOff", {playerData: pd})
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
        if collisionCheck(m.player, checkLoc) <> true
            if canOccupy(checkLoc)
                m.player.location = checkLoc
            end if
        end if
    end if
    setTile(m.player, m.playerHolder)
    makeVisible(m.player.location, m.player.sightDistance)
    m.player.timeIncrement = 1
    fireEvent("statusUpdate")
    moveMonsters()
end sub

sub addMonsters()
    totalMonsters = rnd(7)
    'totalMonsters = 1
    for x = 0 to totalMonsters - 1
        monster = CreateObject("roSGNode", "rcw_Monster")
        monster.id = "monster_" + x.toStr()
        monster.race = "kobold"
        'monster.class = "warrior"
        m.monsters.push(monster)
        mRoom = m.rooms[rnd(m.rooms.count()) - 1]
        monster.location = placeRandomlyInRoom(mRoom)
        m.top.appendChild(monster)
        tileSize = m.global.settings.tile_size
        monster.translation = [monster.location[0] * tileSize, monster.location[1] * tileSize]
        monster.seen = m.global.settings.level_visible
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

sub fight(attacker as Object, defender as Object)
    ?attacker.race;" ";attacker.class;" ATTACKS ";defender.race;" ";defender.class;" WITH ";attacker.meleeWeapon;"!"
    fireAttackAnimation(attacker, defender)
    monsterAttack = defender.id = "current_player"

    if monsterAttack
        attacker.setMeleeWeapon = true
    end if

    attack = rnd(20) + attacker.attackBonus

    hit = attack > defender.armorClass
    if hit
        damage = 0
        for x = 0 to int(attacker.damageDice[0])
            damage = damage + rnd(attacker.damageDice[1])
        end for
        defender.damageTaken = damage
        if monsterAttack
            fireEvent("statusUpdate")
        end if
        if defender.hitPoints <= 0
            if monsterAttack
                playerDead()
            else
                monsterDead(defender)
            end if
        end if
    end if
end sub

sub monsterDead(monster)
    ?"MONSTER ";monster.id;" DIES"
    ?"MONSTER EXP: ";monster.experience
    m.player.addExperience = monster.experience
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
                    tile = CreateObject("roSGNode", "Poster")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.uri = getFloorTile()
                    tile.translation = [tileSize * x, tileSize * y]
                    tile.id = name
                    tile.visible = m.global.settings.level_visible
                    m.roomHolder.appendChild(tile)
                else if gType = "wall"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Poster")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.uri = getWallTile()
                    tile.translation = [tileSize * x, tileSize * y]
                    tile.id = name
                    tile.visible = m.global.settings.level_visible
                    m.roomHolder.appendChild(tile)
                else if gType = "upstairs"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Poster")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.uri = getTilePath("stairsup")
                    tile.translation = [tileSize * x, tileSize * y]
                    tile.id = name
                    tile.visible = m.global.settings.level_visible
                    m.roomHolder.appendChild(tile)
                else if gType = "downstairs"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Poster")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.uri = getTilePath("stairsdown")
                    tile.translation = [tileSize * x, tileSize * y]
                    tile.id = name
                    tile.visible = m.global.settings.level_visible
                    m.roomHolder.appendChild(tile)
                else if gType = "door"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Poster")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.uri = getTilePath("dooropen")
                    tile.translation = [tileSize * x, tileSize * y]
                    tile.id = name
                    tile.visible = m.global.settings.level_visible
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
    openTile = false
    tile = m.levelArr[tileLoc[0], tileLoc[1]]
    arr = tile.split(":")
    tileType = arr[0]
    tileData = arr[1]

    if tileType = "floor" or tileType = "upstairs" or tileType = "downstairs"
        openTile = true
    else if tileType = "door"
        if tileData = "open"
            openTile = true
        else
            openTile = false
        end if
    end if

    for x = 0 to m.monsters.count() - 1
        monster = m.monsters[x]
        if tileLoc[0] = monster.location[0] and tileLoc[1] = monster.location[1]
            openTile = false
        end if
    end for

    return openTile
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

function getFloorTile() as String
    if m.top.levelDepth < 1
        tileNum = rnd(9) - 1
        tileName = "sand_floor" + tileNum.toStr()
    else if m.top.levelDepth < 3
        tileNum = rnd(8) - 1
        tileName = "grey_dirt_floor" + tileNum.toStr()
    else if m.top.levelDepth < 6
        tileNum = rnd(7) - 1
        tileName = "floor_vines" + tileNum.toStr()
    end if

    return getTilePath(tileName)
end function

function getWallTile() as String
    if m.top.levelDepth < 1
        tileNum = rnd(8) - 1
        tileName = "brick_brown_wall" + tileNum.toStr()
    else if m.top.levelDepth < 3 
        tileNum = rnd(4) - 1
        tileName = "brick_gray_wall" + tileNum.toStr()
    else if m.top.levelDepth < 6 
        tileNum = rnd(7) - 1
        tileName = "wall_vines" + tileNum.toStr()
    end if

    return getTilePath(tileName)
end function

function getTilePath(tileName as String) as String
    tilePath = "pkg:/locale/default/tiles/" + m.global.settings.tileset + "/" + m.global.settings.tilemap.dungeon[tilename]
    return tilePath
end function

function placeRandomlyInRoom(room as Object) as Object
    'room is an array describing [startX, startY, height, width]
    sX = room[0]
    sY = room[1]
    w = sX + (room[3])
    h = sY + (room[2])

    newX = getRandomRange(sX + 1, w - 1)
    newY = getRandomRange(sY + 1, h - 1)
    
    return [newX, newY]
end function

sub fireAttackAnimation(attacker as Object, defender as Object)
    aX = attacker.location[0]
    aY = attacker.location[1]
    dX = defender.location[0]
    dY = defender.location[1]

    if aX < dX
        direction = "right"
    else if aX > dX
        direction = "left"
    else if aY < dY
        direction = "down"
    else if aY > dY
        direction = "up"
    end if

    attacker.fireCombatAnim = direction
end sub

function getPlayerData() as Object
    pObj = {}
    pObj.class = m.player.class
    pObj.race = m.player.race
    pObj.hp = m.player.hp
end function 

