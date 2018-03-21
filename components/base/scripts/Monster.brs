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
    m.top.weapons = monsterSettings.weapons
    hp = 0
    for x = 0 to monsterSettings.hitdice_amount
        hp = hp + rnd(monsterSettings.dice)
    end for
    hp = hp + monsterSettings.hitdice_bonus
    m.top.hitPoints = hp
    m.top.experience = (monsterSettings.hitdice_amount * monsterSettings.dice) + monsterSettings.hitdice_bonus
    m.top.title = monsterSettings.title
    'TODO: Handle distance vs melee weapons
    m.top.armorClass = monsterSettings.ac
    postSetup()
end sub

sub postSetup()
    tilePath = getTilePath("monster", m.top.race)
    addTile(tilePath)
    setMeleeWeapon()
end sub

sub setMeleeWeapon()
    weapon = {}
    if m.top.weapons.doesExist("alt1")
        'TODO: handle multiple melee weapons
        ?"ALT WEAPON FIRED"
        weapon = m.top.weapons.melee
    else
        weapon = m.top.weapons.melee
    end if
    ?"WEAPON SET TO ";weapon.weaponName
    m.top.meleeWeapon = weapon.weaponName
    m.top.attackBonus = weapon.bonus
    m.top.damageDice = [weapon.dice_amount, weapon.dice]
end sub
    
