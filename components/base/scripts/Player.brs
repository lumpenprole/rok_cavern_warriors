sub init()
    ?"PLAYER INIT()"
    m.tilePathRoot = "pkg://locale/default/images/player/base/"
    m.top.seen = true
    'TODO: ADD SEX OPTION
    m.sex = "male" 
    m.top.level = 1
end sub

sub onRaceSet()
    race = m.top.race
    ?"RACE: ";m.top.race
    m.raceBonus = m.raceSettings.getField(race + "_bonus")
    ?"RACE BONUS: ";m.raceBonus
    postSetup()
end sub

sub postSetup()
    'CHECK IF ALL OPTIONS ARE SET BEFORE CREATING TILE
    if m.top.race <> "none" and m.top.class <> "none"
        m.mind = m.mind + m.raceBonus[0]
        m.strength = m.strength + m.raceBonus[1]
        m.dexterity = m.dexterity + m.raceBonus[2]
        m.top.hitPoints = m.strength + rnd(6)
        ?"FINAL HIT POINTS: ";m.top.hitPoints
        setTile()
    end if
end sub

sub setTile()
    race = m.top.race
    
    tileName = race + "_" + m.sex + ".png"
    tilePath = getTilePath("player", race, m.sex)
    addTile(tilePath)
    processStartingEquipment()
end sub

sub processStartingEquipment()
    if m.classSettings[m.top.class + "_starting_equipment"] <> invalid
        sEquip = m.classSettings[m.top.class + "_starting_equipment"]
        if sEquip.armor <> invalid
            loadBodyArmor(m.global.settings.tilemap.armor[sEquip.armor])
        end if
        if sEquip.pants <> invalid
            loadPants(m.global.settings.tilemap.pants[sEquip.pants])
        end if
        if sEquip.helmet <> invalid
            loadHelmet(m.global.settings.tilemap.helmet[sEquip.helmet])
        end if
        if sEquip.gloves <> invalid
            loadGloves(m.global.settings.tilemap.gloves[sEquip.gloves])
        end if
        if sEquip.boots <> invalid
            loadGloves(m.global.settings.tilemap.boots[sEquip.boots])
        end if
    end if
end sub

sub loadBodyArmor(armorPath as String)
    armorTile = createObject("roSGNode", "Poster")
    armorTile.loadDisplayMode = "scaleToFill"
    armorTile.loadWidth = m.tileSize
    armorTile.loadHeight = m.tileSize
    armorTile.uri = "pkg:/locale/default/tiles/" + m.global.settings.tileset + "/" + armorPath
    m.bodyArmorHolder.appendChild(armorTile)
end sub

sub loadPants(pantsPath as String)
    pantsTile = createObject("roSGNode", "Poster")
    pantsTile.loadDisplayMode = "scaleToFill"
    pantsTile.loadWidth = m.tileSize
    pantsTile.loadHeight = m.tileSize
    pantsTile.uri = "pkg:/locale/default/tiles/" + m.global.settings.tileset + "/" + pantsPath
    m.pantsHolder.appendChild(pantsTile)
end sub

sub loadHelmet(helmetPath as String)
    helmetTile = createObject("roSGNode", "Poster")
    helmetTile.loadDisplayMode = "scaleToFill"
    helmetTile.loadWidth = m.tileSize
    helmetTile.loadHeight = m.tileSize
    helmetTile.uri = "pkg:/locale/default/tiles/" + m.global.settings.tileset + "/" + helmetPath
    m.helmetHolder.appendChild(helmetTile)
end sub

sub loadGloves(glovesPath as String)
    glovesTile = createObject("roSGNode", "Poster")
    glovesTile.loadDisplayMode = "scaleToFill"
    glovesTile.loadWidth = m.tileSize
    glovesTile.loadHeight = m.tileSize
    glovesTile.uri = "pkg:/locale/default/tiles/" + m.global.settings.tileset + "/" + glovesPath
    m.glovesHolder.appendChild(glovesTile)
end sub

sub loadBoots(bootsPath as String)
    bootsTile = createObject("roSGNode", "Poster")
    bootsTile.loadDisplayMode = "scaleToFill"
    bootsTile.loadWidth = m.tileSize
    bootsTile.loadHeight = m.tileSize
    bootsTile.uri = "pkg:/locale/default/tiles/" + m.global.settings.tileset + "/" + bootsPath
    m.bootsHolder.appendChild(bootsTile)
end sub

sub levelUp()
    m.top.hitPoints = m.top.hitPoints + rnd(6)
end sub
