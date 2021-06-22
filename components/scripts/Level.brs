sub init()
    m.loadTxt = m.top.findNode("loading_text")
    m.roomHolder = m.top.findNode("room_holder")
    m.playerHolder = m.top.findNode("player_holder")
    m.monsterHolder = m.top.findNode("monster_holder")
    m.bonesHolder = m.top.findNode("bones_holder")
    m.monsters = []
    m.playerHasDied = false
    m.aimSquare = m.top.findNode("aim_square")
    m.aimSquare.opacity = 0
    m.aimingLocation = [0,0]
    m.rangedHolder = m.top.findNode("ranged_weapon_holder")
    m.rangedAttackAnim = m.top.findNode("ranged_attack_animation")
    m.rangedAttackVector = m.top.findNode("ranged_vector")
    m.lastRangedAttack = invalid
    m.aimingTiles = []
end sub

sub setupLevel()
    settings = m.top.settings
    appSettings = m.global.settings

    m.modalOn = false
    m.aiming = false

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
    addItems()
end sub

sub onPlayerStairs()
    tileSize = m.global.settings.tile_size
    m.player = m.playerHolder.findNode("current_player")
    if m.top.playerStairs = "down" then
        m.playerHolder.translation = [m.upstairs[0] * tileSize, m.upstairs[1] * tileSize]
        m.player.location = m.upstairs
    else if m.top.playerStairs = "up"
        m.playerHolder.translation = [m.downstairs[0] * tileSize, m.downstairs[1] * tileSize]
        m.player.location = m.downstairs
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if m.modalOn
        fireEvent("modalKeyEvent", {key: key, press: press, player: m.player})
    else
        if press then
            if key = "OK" then
                if not m.playerHasDied then
                    if m.aiming then
                        fireRangedWeapon()
                    else
                        checkActOnTile()
                    end if

                    handled = true
                end if
            else if key = "left" or key = "right" or key = "up" or key = "down"
                if not m.aiming then
                    playerMove(key)
                else
                    aim(key)
                end if
            else if key = "play"
                pd = getPlayerData()
                fireEvent("handleGameModalOnOff", {playerData: pd})
            else if key = "options"
                if m.player.rangedWeapon <> "none"
                    if m.aiming = true
                        'cancel ranged weapon
                        m.aimSquare.opacity = 0
                        clearAimingTiles()
                        m.aiming = false
                    else
                        handleRangedAttack(m.player.rangedWeaponType, m.player.rangedWeapon)
                    end if
                end if
            end if
        end if
    end if
    return handled
end function

sub playerMove(direction as String)

    ploc = m.player.location
    checkLoc = []
    if direction = "left" then
        checkLoc = [ploc[0] - 1, ploc[1]]
    else if direction = "right"
        checkLoc = [ploc[0] + 1, ploc[1]]
    else if direction = "down"
        checkLoc = [ploc[0], ploc[1] + 1]
    else if direction = "up"
        checkLoc = [ploc[0], ploc[1] - 1]
    end if

    if m.levelArr[checkLoc[0], checkLoc[1]] <> invalid then
        if collisionCheck(m.player, checkLoc) <> true then
            if canOccupy(checkLoc) then
                m.player.location = checkLoc
            end if
        end if
    end if

    setTile(m.player, m.playerHolder)
    makeVisible(m.player.location, m.player.sightDistance)
    m.player.timeIncrement = 1
    fireEvent("statusUpdate")
    handleTurnEnd({turnType: "player"})
end sub

sub addMonsters()
    totalMonsters = rnd(7)
    'totalMonsters = 1
    'TODO infer monster level
    monsterLevel = 0
    monsterArr = m.global.settings.monster.monsterLevels[monsterLevel]
    monsterTotal = monsterArr.count() - 1
    for x = 0 to totalMonsters - 1
        monster = CreateObject("roSGNode", "rcw_Monster")
        monster.id = "monster_" + x.toStr()
        monster.race = monsterArr[rnd(monsterTotal) - 1]
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

sub addItems()
    'TODO: Actually make this work. This is just placing a sword on every level so I can test items
    sword = CreateObject("roSGNode", "rcw_Item")
    sword.itemType = ["weapon", "short_sword"]
    mRoom = m.rooms[rnd(m.rooms.count()) - 1]
    sword.location = placeRandomlyInRoom(mRoom)
    m.top.appendChild(sword)
    tileSize = m.global.settings.tile_size
    sword.translation = [sword.location[0] * tileSize, sword.location[1] * tileSize]
    sword.seen = m.global.settings.level_visible
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
    ?attacker.race;" ";attacker.class;" ATTACKS ";defender.race;" ";defender.class;" WITH ";attacker.mainHand;"!"
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
    else
        if monsterAttack
            handleTurnEnd({turnType: "monster"})
        else
            handleTurnEnd({turnType: "player"})
        end if
    end if
end sub

sub handleRangedAttack(weaponType, weapon)
    ?"FIRE ";weapon;" WHICH IS A ";weaponType
    if weaponType = "spell"
        spell = m.global.settings.spells.lookup(weapon)
        ?"CASTING ";spell.name
    end if

    tileSize = m.global.settings.tile_size
    ploc = m.player.location
    m.aimSquare.width = tileSize
    m.aimSquare.height = tileSize
    m.aimSquare.translation = [ploc[0] * tileSize, ploc[1] * tileSize]
    m.aimSquare.opacity = 1
    if m.lastRangedAttack = invalid
        m.aimingLocation = ploc
        m.aiming = true
    else 
        m.aiming = true
        m.aimingLocation = m.lastRangedAttack.location
        aimTo(m.lastRangedAttack.location)
    end if
end sub

sub aim(direction as string)
    cloc = m.aimingLocation
    tileSize = m.global.settings.tile_size
    checkLoc = []
    if direction = "left"
        checkLoc = [cloc[0] - 1, cloc[1]]
    else if direction = "right"
        checkLoc = [cloc[0] + 1, cloc[1]]
    else if direction = "down"
        checkLoc = [cloc[0], cloc[1] + 1]
    else if direction = "up"
        checkLoc = [cloc[0], cloc[1] - 1]
    end if
   
    if canAim(checkLoc[0], checkLoc[1])
        m.aimSquare.translation = [checkLoc[0] * tileSize, checkLoc[1] * tileSize]
        m.aimingLocation = checkLoc
    end if

end sub 

sub aimTo(location)
    tileSize = m.global.settings.tile_size
    if canAim(location[0], location[1])
        m.aimSquare.translation = [location[0] * tileSize, location[1] * tileSize]
        m.aimingLocation = location
    end if
end sub

sub fireRangedWeapon()
    m.aiming = false
    m.aimSquare.opacity = 0
    
    if m.player.rangedWeaponType = "spell"
        tilePath = "pkg:/locale/default/tiles/" + m.global.settings.tileset + "/" + m.global.settings.tilemap.spells[m.player.rangedWeapon]
    end if

    tileSize = m.global.settings.tile_size
    tile = CreateObject("roSGNode", "Poster")
    tile.id = "RangedTile"
    tile.width = tileSize
    tile.height = tileSize
    tile.uri = tilePath
    ploc = m.player.location
    tile.visible = true
    m.rangedHolder.appendChild(tile)
    m.rangedHolder.translation = [ploc[0] * tileSize, ploc[1] * tileSize]
    m.rangedHolder.opacity = 1

     
    'TODO: allow monsters to fire ranged weapons
    attacker = m.player
    monsterAttack = false
    ?"Firing ranged animation. attacker: "; attacker.location; ", aiming location: "; m.aimingLocation
    fireRangedAttackAnimation(attacker.location, m.aimingLocation)
    
    'TODO: Spell use needs to advance turn
    bonus = 0
    if attacker.rangedWeaponType = "spell"
        bonus = attacker.spellBonus 
    else if attacker.rangedWeaponType = "missle"
        bonus = attacker.missleBonus
    end if

    for x = 0 to m.monsters.count() - 1
        monster = m.monsters[x]
        if monster.location[0] = m.aimingLocation[0] and monster.location[1] = m.aimingLocation[1]
            defender = monster
            m.lastRangedAttack = monster
            exit for
        end if
    end for
    
    hit = false
    if not type(defender) = "<uninitialized>"
        rangedRoll = rnd(20) + 10 + bonus
        hit = rangedRoll > defender.armorClass
    end if

    if hit
        damage = 0
        if attacker.rangedWeaponType = "spell"
            spellData = m.global.settings.spells[attacker.rangedWeapon]
            if attacker.level <= spellData.level_bonus_top
                for d = 0 to (attacker.level * spellData.level_bonus)
                    damage = damage + rnd(spellData.damage_dice_type)
                end for
            else
                for d = 0 to (spellData.level_bonus_top * spellData.level_bonus)
                    damage = damage + rnd(spellData.damage_dice_type)
                end for
            end if
        else if attacker.rangedWeaponType = "missle"
            missleData = m.global.settings.missles[attacker.rangedWeapon]

            for x = 0 to int(attacker.damageDice[0])
                damage = damage + rnd(attacker.damageDice[1])
            end for
        end if

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
    else
        if monsterAttack
            handleTurnEnd({turnType: "monster"})
        else
            handleTurnEnd({turnType: "player"})
        end if
    end if
    'moveMonsters() I think I need to make a turn system. 
end sub

sub monsterDead(monster)
    ?"MONSTER ";monster.id;" DIES"
    ?"MONSTER EXP: ";monster.experience
    m.player.addExperience = monster.experience
    m.lastRangedAttack = invalid
    m.top.removeChild(monster)
    setTileData(monster.location,"bones", true)
    setBones(monster.location)
    for x = 0 to m.monsters.count() - 1
        if m.monsters[x].id = monster.id
            m.monsters.delete(x)
            exit for
        end if
    end for
end sub

sub setBones(bonesLoc)
    tileSize = m.global.settings.tile_size
    x = bonesLoc[0]
    y = bonesLoc[1]
    bonesTile = CreateObject("roSGNode", "Poster")
    bonesTile.width = tileSize
    bonesTile.height = tileSize
    bonesTile.uri = "pkg:/locale/default/tiles/" + m.global.settings.tileset + "/" + m.global.settings.tilemap.effects.bones
    bonesTile.translation = [x * tileSize, y * tileSize]
    bonesTile.id = "bones_" + x.toStr() + "_" + y.toStr()
    m.bonesHolder.appendChild(bonesTile)
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
            tileData = parseTileData(m.levelArr[x][y])
            'TODO Make this room aware, so that it draws a single rectangle for each room. Maybe.
            if(tileData <> invalid)
                'TODO: need to move tile creation into a separate function
                'and set colors and tiles in the settings
                if tileData.tileType = "floor"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Poster")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.uri = getFloorTile()
                    tile.translation = [tileSize * x, tileSize * y]
                    tile.id = name
                    tile.visible = m.global.settings.level_visible
                    m.roomHolder.appendChild(tile)
                else if tileData.tileType = "wall"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Poster")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.uri = getWallTile()
                    tile.translation = [tileSize * x, tileSize * y]
                    tile.id = name
                    tile.visible = m.global.settings.level_visible
                    m.roomHolder.appendChild(tile)
                else if tileData.tileType = "upstairs"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Poster")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.uri = getTilePath("stairsup")
                    tile.translation = [tileSize * x, tileSize * y]
                    tile.id = name
                    tile.visible = m.global.settings.level_visible
                    m.roomHolder.appendChild(tile)
                else if tileData.tileType = "downstairs"
                    name = "tile_" + x.toStr() + "_" + y.toStr()
                    tile = CreateObject("roSGNode", "Poster")
                    tile.width = tileSize
                    tile.height = tileSize
                    tile.uri = getTilePath("stairsdown")
                    tile.translation = [tileSize * x, tileSize * y]
                    tile.id = name
                    tile.visible = m.global.settings.level_visible
                    m.roomHolder.appendChild(tile)
                else if tileData.tileType = "door"
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

                if tileData.bones
                    setBones([x, y])
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

function canOccupy(tileLoc, checkMonster = true)
    openTile = false
    tile = parseTileData(m.levelArr[tileLoc[0], tileLoc[1]])

    if tile.tileType = "floor" or tile.tileType = "upstairs" or tile.tileType = "downstairs"
        openTile = true
    else if tile.tileType = "door"
        if tile.open = true
            openTile = true
        else
            openTile = false
        end if
    end if
    
    if checkMonster
        for x = 0 to m.monsters.count() - 1
            monster = m.monsters[x]
            if tileLoc[0] = monster.location[0] and tileLoc[1] = monster.location[1]
                openTile = false
            end if
        end for
    end if

    return openTile
end function

sub clearAimingTiles()
    for x = 0 to m.aimingTiles.count() - 1
        tileLoc = m.aimingTiles[x]
        tile = m.roomHolder.findNode("tile_" + tileLoc[0].toStr() + "_" + tileLoc[1].toStr())
        tile.blendColor = "0xFFFFFFFF"
    end for
end sub

function canAim(tileLoc0, tileLoc1) as boolean
    checkTile = [tileLoc0, tileLoc1]
    'TODO: monsters will need this when they can shoot
    finalTile = m.player.location
    
    openTile = false
    
    'Is tile open
    if canOccupy(checkTile, false)
        openTile = true
    else
        openTile = false
    end if

    pathData = []
    if openTile
        
        'Set check tile to next tile. 
        x0 = checkTile[0]
        x1 = finalTile[0]
        y0 = checkTile[1]
        y1 = finalTile[1]
        
        if abs(y1 - y0) < abs(x1 - x0)
            if x0 > x1
                pathData = plotLineLow(x1, y1, x0, y0)
            else
                pathData = plotLineLow(x0, y0, x1, y1)
            end if
        else
            if y0 > y1
                pathData = plotLineHigh(x1, y1, x0, y0)
            else
                pathData = plotLineHigh(x0, y0, x1, y1)
            end if
        end if

    end if

    if openTile
        openTile = pathData[0]
    end if

    if openTile
        'drawPath
        clearAimingTiles()
        for x = 0 to pathData[1].count() - 1
            tileLoc = pathData[1][x]
            tileGraphic = m.roomHolder.findNode("tile_" + tileLoc[0].toStr() + "_" + tileLoc[1].toStr())
            tileGraphic.blendColor = "0xB4CEF755"
        end for
        m.aimingTiles = pathData[1]
    end if

    return openTile

end function

function plotLineLow(x0, y0, x1, y1) as Object
    dx = x1 - x0
    dy = y1 - y0
    yi = 1
    if dy < 0
        yi = -1
        dy = -dy
    end if
    D = 2*dy - dx
    y = y0

    isGoodPath = true
    newAimPath = []
    for x = x0 to x1
        'Is tile open
        if not canOccupy([x, y], false)
            isGoodPath = false
            exit for
        end if

        newAimPath.push([x, y])

        if D > 0
            y = y + yi
            D = D - 2*dx
        end if
        D = D + 2*dy
    end for
    
    return [isGoodPath, newAimPath]

end function

function plotLineHigh(x0, y0, x1, y1) as Object
    dx = x1 - x0
    dy = y1 - y0
    xi = 1
    if dx < 0
        xi = -1
        dx = -dx
    end if
    D = 2*dx - dy
    x = x0

    isGoodPath = true
    newAimPath = []

    for y = y0 to y1
        'Is tile open
        if not canOccupy([x, y], false)
            isGoodPath = false
            exit for
        end if

        newAimPath.push([x, y])

        if D > 0
            x = x + xi
            D = D - 2*dy
        end if
        D = D + 2*dx
    end for

    return [isGoodPath, newAimPath]
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
    tile = parseTileData(m.levelArr[pLoc[0], pLoc[1]])
    if tile.tileType = "downstairs"
        fireEvent("goDownstairs", {})
    else if tile.tileType = "upstairs"
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

sub fireRangedAttackAnimation(attacker as Object, defender as Object)
    clearAimingTiles()
    tileSize = m.global.settings.tile_size
    aX = attacker[0] * tileSize
    aY = attacker[1] * tileSize
    dX = defender[0] * tileSize
    dY = defender[1] * tileSize
    
    ud = "none"
    lr = "none"

    if aX < dX
        lr = "right"
    else if aX > dX
        lr = "left"
    end if

    if aY < dY
        ud = "down"
    else if aY > dY
        ud = "up"
    end if

    m.rangedHolder.scaleRotateCenter = [tilesize/2, tilesize/2]
    if lr = "none"
        if ud = "up"
            m.rangedHolder.rotation = 5.49
        else if ud = "down"
            m.rangedHolder.rotation = 2.35
        end if
    else if ud = "none"
        if lr = "left"
            m.rangedHolder.rotation = 0.78
        else if lr = "right"
            m.rangedHolder.rotation = 3.92
        end if
    else
        if ud = "up"
            if lr = "right"
                m.rangedHolder.rotation = 4.71
            else if lr = "left"
                m.rangedHolder.rotation = 0.0
            end if
        else if ud = "down"
            if lr = "left"
                m.rangedHolder.rotation = 1.57
            else if lr = "right"
                m.rangedHolder.rotation = 3.14
            end if
        end if
    end if
    
    keyVal = [[aX, aY], [aX + (dX - aX) / 2, aY + (dY - aY) / 2], [dX, dY]]

    m.rangedAttackVector.keyValue = keyVal
    m.rangedAttackAnim.observeField("state", "deleteRangedAnimation")
    m.rangedAttackAnim.control = "start"

end sub

sub deleteRangedAnimation(msg)
    currentState = msg.getData()
    if currentState = "stopped"
        m.rangedHolder.opacity = 0
        m.rangedAttackAnim.unobserveField("state")
    end if
end sub

function parseTileData(tileLoc as String) as Object
    tile = {}
    arr = tileLoc.split(":")
    tile.tileType = arr[0]

    tile.open = false
    tile.bones = false

    tileData = arr[1].split(",")
    if tileData.count() > 0
        for x = 0 to tileData.count() - 1
            dt = tileData[x]
            if dt = "open"
                tile.open = true
            else if dt = "bones"
                tile.bones = true
            end if
        end for
    end if
    return tile
end function

sub setTileData(tileLoc, param, bool)
    tileArr = m.levelArr[tileLoc[0], tileLoc[1]].split(":")
    tType = tileArr[0]
    data = tileArr[1].split(",")
    if bool
        containsParam = false
        for x = 0 to data.count() - 1
            if data[x] = param
                containsParam = true
            end if
        end for

        if not containsParam
            data.push(param)
        end if
    else
        for x = 0 to data.count() - 1
            if data[x] = param
                data.delete(x)
                exit for
            end if
        end for
    end if
    m.levelArr[tileLoc[0], tileLoc[1]] = tType + ":" + data.join(",")
end sub

sub handleTurnEnd(evData)
    if evData.turnType = "player"
        moveMonsters()
    else
        ?"DO SOMETHING"
    end if
end sub

function getPlayerData() as Object
    pObj = {}
    pObj.class = m.player.class
    pObj.race = m.player.race
    pObj.hp = m.player.hitPoints
    pObj.level = m.player.level
    pObj.xp = m.player.experience
    pObj.ac = m.player.armorClass
    pObj.inv = {
        mainHand: m.player.mainHand
        offHand: m.player.offHand
        ranged: m.player.rangedWeapon
        armor: m.player.armorArray
        sack:[
            {TBD: "tbd"}
            ]
        }
    return pObj
end function 

sub onEventCallback(data as Object)
    ev = m.top.eventCallBack
    et = ev.evType

    if et = "handleGameModalOnOff"
        if m.modalOn
            m.modalOn = false
        else 
            m.modalOn = true
        end if
    else if et = "endTurn"
        handleTurnEnd(ev.data)
    end if
end sub
