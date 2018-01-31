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

sub levelUp()
    m.top.hitPoints = m.top.hitPoints + rnd(6)
end sub
