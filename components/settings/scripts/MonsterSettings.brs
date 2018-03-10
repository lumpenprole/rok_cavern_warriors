sub init()
    processMonsters()
end sub

sub processMonsters()
    m.top.badger = {hitdice_amount: 1, dice: 8, hitdice_bonus: 2, ac: 15, weapon: "badger_claw", title: "Badger"}
    m.top.ankheg = {hitdice_amount: 3, dice: 10, hitdice_bonus: 12, ac: 18, weapon: "ankheg_bite", title: "Ankheg"}
    m.top.bugbear = {hitdice_amount: 3, dice: 8, hitdice_bonus: 3, ac: 17, weapon: "morningstar:javelin", title: "Bugbear"}
    m.top.choker = {hitdice_amount: 3, dice: 8, hitdice_bonus: 3, ac: 17, weapon: "choker_tentacle", title: "Choker"}
    m.top.raptor = {hitdice_amount: 4, dice: 8, hitdice_bonus: 16, ac: 16, weapon: "raptor_talons", title: "Raptor"}
    m.top.dire_rat = {hitdice_amount: 1, dice: 8, hitdice_bonus: 1, ac: 15, weapon: "rat_bite", title: "Dire Rat"}
    m.top.dwarf = {hitdice_amount: 1, dice: 8, hitdice_bonus: 2, ac: 16, weapon: "waraxe:shortbow", title: "Dwarven Warrior"}
    m.top.earth_elemental = {hitdice_amount: 8, dice: 8, hitdice_bonus: 32, ac: 18, weapon: "elemental_slam", title: "Earth Elemental"}
    m.top.elf = {hitdice_amount: 1, dice: 8, hitdice_bonus: 4, ac: 15, weapon: "longsword:longbow", title: "Elf Warrior"}
    m.top.gargoyle = {hitdice_amount: 4, dice: 8, hitdice_bonus: 19, ac: 16, weapon: "gargoyle_claw", title: "Gargoyle"}
    m.top.goblin = {hitdice_amount: 1, dice: 8, hitdice_bonus: 1, ac: 15, weapon: "morningnstar:javelin", title: "Goblin"}
    m.top.griffon = {hitdice_amount: 7, dice: 10, hitdice_bonus: 21, ac: 17, weapon: "griffon_bite", title: "Griffon"}
    m.top.halfling = {hitdice_amount: 1, dice: 8, hitdice_bonus: 1, ac: 16, weapon: "shortsword:light_crossbow", title: "Halfling Theif"}
    m.top.hellhound = {hitdice_amount: 4, dice: 8, hitdice_bonus: 4, ac: 16, weapon: "hellhound_bite", title: "Hellhound"}
    m.top.hill_giant = {hitdice_amount: 12, dice: 8, hitdice_bonus: 48, ac: 20, weapon: "greatclub:rock", title: "Hill Giant"}
    m.top.hobgoblin = {hitdice_amount: 1, dice: 8, hitdice_bonus: 2, ac: 15, weapon: "longsword:javelin", title: "Hobgoblin"}
    m.top.human_commoner = {hitdice_amount: 1, dice: 8, hitdice_bonus: 1, ac: 12, weapon: "dagger:sling", title: "Commoner Thug"}
    m.top.spider = {hitdice_amount: 1, dice: 8, hitdice_bonus: 0, ac: 14, weapon: "spider_bite", title: "Spider"}
    m.top.kobold = {hitdice_amount: 1, dice: 8, hitdice_bonus: 0, ac: 15, weapon: "spear:sling", title: "Kobold"}
    m.top.ogre = {hitdice_amount: 4, dice: 8, hitdice_bonus: 11, ac: 16, weapon: "greatclub:javelin", title: "Ogre"}
    m.top.orc = {hitdice_amount: 1, dice: 8, hitdice_bonus: 1, ac: 13, weapon: "falchion:javelin", title: "Orc Warrior"}
    m.top.owlbear = {hitdice_amount: 5, dice: 10, hitdice_bonus: 25, ac: 15, weapon: "owlbear_claw", title: "Owlbear"}
    'Oh god I hate rust monsters, am I seriously going to put this thing in here? 
    m.top.rust_monster = {hitdice_amount: 5, dice: 8, hitdice_bonus: 5, ac: 18, weapon: "rust_touch", title: "Rust Monster"}
    m.top.shadow = {hitdice_amount: 3, dice: 12, hitdice_bonus: 0, ac: 13, weapon: "shadow_touch", title: "Shadow"}
    m.top.skeleton_warrior = {hitdice_amount: 1, dice: 12, hitdice_bonus: 0, ac: 15, weapon: "scimitar", title: "Skeleton Warrior"}
    m.top.stirge = {hitdice_amount: 1, dice: 10, hitdice_bonus: 0, ac: 16, weapon: "stirge_touch", title: "Strige"}
    m.top.stone_golem = {hitdice_amount: 14, dice: 10, hitdice_bonus: 30, ac: 26, weapon: "golem_slam", title: "Stone Golem"}
    m.top.troll = {hitdice_amount: 6, dice: 8, hitdice_bonus: 36, ac: 16, weapon: "troll_claw", title: "Troll"}
    m.top.werewolf = {hitdice_amount: 3, dice: 8, hitdice_bonus: 7, ac: 16, weapon: "werewolf_claw", title: "Werewolf"}
    m.top.wight = {hitdice_amount: 4, dice: 12, hitdice_bonus: 0, ac: 15, weapon: "wight_slam", title: "Wight"}
    m.top.wolf = {hitdice_amount: 2, dice: 8, hitdice_bonus: 4, ac: 14, weapon: "wolf_bite", title: "Wolf"}
    m.top.wyvern = {hitdice_amount: 7, dice: 12, hitdice_bonus: 14, ac: 18, weapon: "sting", title: "Wyvern"}
    m.top.zombie = {hitdice_amount: 2, dice: 12, hitdice_bonus: 3, ac: 11, weapon: "zombie_slam", title: "Zombie"}

    'weapons
    m.top.spear = {dice_amount: 1, dice: 6, bonus: 1}

end sub
