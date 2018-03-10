sub init()
    ?"MONSTER INIT()"
    m.settings = m.global.settings.monster
    m.top.class = "monster"
end sub

sub onClassSet()
    m.top.class = "monster"
end sub

sub onRaceSet()
    race = m.top.race
    monsterSettings = m.settings[race]
    m.top.hitPoints = (monsterSettings.hitdice_amount * monsterSettings.dice) + monsterSettings.hitdice_bonus
    m.top.title = monsterSettings.title
    weaponName = monsterSettings.weapon
    if weaponName.inStr(0, ":") > -1
        arr = weaponName.split(":")
        weaponName = arr[0]
    end if
    weapon = m.settings[weaponName]
    'TODO: Handle distance vs melee weapons
    m.top.hitDice = (weapon.dice_amount * weapon.dice) + weapon.bonus
    m.top.armorClass = monsterSettings.ac
    postSetup()
end sub

sub postSetup()
    tilePath = getTilePath("monster", m.top.race)
    addTile(tilePath)
end sub
