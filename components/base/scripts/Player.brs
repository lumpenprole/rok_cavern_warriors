sub init()
    ?"PLAYER INIT()"
    m.tilePathRoot = "pkg://locale/default/images/player/base/"
    m.top.seen = true
    'TODO: ADD SEX OPTION
    m.sex = "male" 
end sub

sub postSetup()
    m.top.hitPoints = m.top.hitPoints + 5
    ?"FINAL HIT POINTS: ";m.top.hitPoints
    'CHECK IF ALL OPTIONS ARE SET BEFORE CREATING TILE
    if m.top.race <> "none" and m.top.class <> "none"
        setTile()
    end if
end sub

sub setTile()
    race = m.top.race
    if race = "halfelf"
        race = "elf"
    else if race = "halforc"
        race = "orc"
    end if
    
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
