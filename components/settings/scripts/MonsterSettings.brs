sub init()
    processMonsters()
end sub

sub processMonsters()
    
    'ANIMALS
	m.top.badger = {hitdice_amount: 1,
			dice: 8,
			hitdice_bonus: 2,
			ac: 15,
			weapons: {melee: {weaponName: "claw",
					attack_bonus: 4,
					dice_amount: 1,
					dice: 2,
					bonus: -1
					}},  
			title: "badger"}
	m.top.black_bear = {hitdice_amount: 3,
			dice: 8,
			hitdice_bonus: 6,
			ac: 13,
			weapons: {melee: {weaponName: "claw",
					attack_bonus: 6,
					dice_amount: 1,
					dice: 4,
					bonus: 4
                    },
                   alt1: {weaponName:"bite",
                    attack_bonus:1,
                    dice_amount:1,
                    dice: 6,
                    bonus: 2
                    }},  
			title: "black bear"}
	m.top.brown_bear = {hitdice_amount: 6,
			dice: 8,
			hitdice_bonus: 24,
			ac: 15,
			weapons: {melee: {weaponName: "claw",
					attack_bonus: 11,
					dice_amount: 1,
					dice: 8,
					bonus: 8
                    },
                   alt1: {weaponName:"bite",
                    attack_bonus:6,
                    dice_amount:2,
                    dice: 6,
                    bonus: 4
                    }},  
			title: "brown bear"}
	m.top.boar = {hitdice_amount: 3,
			dice: 8,
			hitdice_bonus: 12,
			ac: 16,
			weapons: {melee: {weaponName: "gore",
					attack_bonus: 4
					dice_amount: 1,
					dice: 8,
					bonus: 3
					}},  
			title: "boar"}
	m.top.crocodile = {hitdice_amount: 3,
			dice: 8,
			hitdice_bonus: 9,
			ac: 16,
			weapons: {melee: {weaponName: "bite",
					attack_bonus: 6,
					dice_amount: 1,
					dice: 8,
					bonus: 6
                    },
                   alt1: {weaponName:"tail slap",
                    attack_bonus: 6,
                    dice_amount: 1,
                    dice: 12,
                    bonus: 6
                    }},  
			title: "crocodile"}
	m.top.dog = {hitdice_amount: 1,
			dice: 8,
			hitdice_bonus: 2,
			ac: 15,
			weapons: {melee: {weaponName: "bite",
					attack_bonus: 2
					dice_amount: 1,
					dice: 4,
					bonus: 1
					}},  
			title: "wild dog"}
	m.top.donkey = {hitdice_amount: 2,
			dice: 8,
			hitdice_bonus: 2,
			ac: 13,
			weapons: {melee: {weaponName: "bite",
					attack_bonus: 1
					dice_amount: 1,
					dice: 2,
					bonus: 0
					}},  
			title: "donkey"}
	m.top.eagle = {hitdice_amount: 1,
			dice: 8,
			hitdice_bonus: 1,
			ac: 14,
			weapons: {melee: {weaponName: "talons",
					attack_bonus: 3
					dice_amount: 1,
					dice: 4,
					bonus: 0
					}},  
			title: "eagle"}
	m.top.giant_crocodile = {hitdice_amount: 7,
			dice: 8,
			hitdice_bonus: 28,
			ac: 16,
			weapons: {melee: {weaponName: "bite",
					attack_bonus: 11,
					dice_amount: 2,
					dice: 8,
					bonus: 12
                    },
                   alt1: {weaponName:"tail slap",
                    attack_bonus: 11,
                    dice_amount: 1,
                    dice: 12,
                    bonus: 12
                    }},  
			title: "giant crocodile"}
	m.top.horse = {hitdice_amount: 3,
			dice: 8,
			hitdice_bonus: 6,
			ac: 13,
			weapons: {melee: {weaponName: "hoof",
					attack_bonus: -1, 
					dice_amount: 1,
					dice: 6,
					bonus: 1
					}},  
			title: "horse"}
	m.top.mule = {hitdice_amount: 3,
			dice: 8,
			hitdice_bonus: 9,
			ac: 13,
			weapons: {melee: {weaponName: "hoof",
					attack_bonus: 4
					dice_amount: 1,
					dice: 4,
					bonus: 3
					}},  
			title: "mule"}
	m.top.pony = {hitdice_amount: 3,
			dice: 8,
			hitdice_bonus: 6,
			ac: 13,
			weapons: {melee: {weaponName: "hoof",
					attack_bonus: -1, 
					dice_amount: 1,
					dice: 6,
					bonus: 1
					}},  
			title: "pony"}
	m.top.small_boa_constrictor = {hitdice_amount: 3,
			dice: 8,
			hitdice_bonus: 6,
			ac: 15,
			weapons: {melee: {weaponName: "bite",
					attack_bonus: 5,
					dice_amount: 1,
					dice: 3,
					bonus: 4
					}},  
			title: "boa constrictor"}
	m.top.giant_boa_constrictor = {hitdice_amount: 11,
			dice: 8,
			hitdice_bonus: 14,
			ac: 15,
			weapons: {melee: {weaponName: "bite",
					attack_bonus: 13,
					dice_amount: 1,
					dice: 8,
					bonus: 10
					}},  
			title: "giant boa constrictor"}
	m.top.small_viper = {hitdice_amount: 1,
			dice: 8,
			hitdice_bonus: 0,
			ac: 17,
			weapons: {melee: {weaponName: "bite",
					attack_bonus: 4,
					dice_amount: 1,
					dice: 2,
					bonus: -2,
                    effect: "poison"
					}},  
			title: "small viper"}
	m.top.large_viper = {hitdice_amount: 3,
			dice: 8,
			hitdice_bonus: 6,
			ac: 15,
			weapons: {melee: {weaponName: "bite",
					attack_bonus: 4
					dice_amount: 1,
					dice: 4,
					bonus: 0,
                    effect: "poison"
					}},  
			title: "large viper"}
	m.top.huge_viper = {hitdice_amount: 6,
			dice: 8,
			hitdice_bonus: 6,
			ac: 15,
			weapons: {melee: {weaponName: "bite",
					attack_bonus: 6
					dice_amount: 1,
					dice: 6,
					bonus: 4,
                    effect: "poison"
					}},  
			title: "huge viper"}
	m.top.war_dog = {hitdice_amount: 2,
			dice: 8,
			hitdice_bonus: 4,
			ac: 16,
			weapons: {melee: {weaponName: "bite",
					attack_bonus: 3
					dice_amount: 1,
					dice: 6,
					bonus: 3
					}},  
			title: "war dog"}
	m.top.heavy_warhorse = {hitdice_amount: 4,
			dice: 8,
			hitdice_bonus: 12,
			ac: 14,
			weapons: {melee: {weaponName: "hoof",
					attack_bonus: 6, 
					dice_amount: 1,
					dice: 6,
					bonus: 4
					}},  
			title: "heavy warhorse"}
	m.top.light_warhorse = {hitdice_amount: 3,
			dice: 8,
			hitdice_bonus: 9,
			ac: 14,
			weapons: {melee: {weaponName: "hoof",
					attack_bonus: 4,
					dice_amount: 1,
					dice: 4,
					bonus: 3
					}},  
			title: "light warhorse"}
	m.top.warpony = {hitdice_amount: 2,
			dice: 8,
			hitdice_bonus: 4,
			ac: 13,
			weapons: {melee: {weaponName: "hoof",
					attack_bonus: 3
					dice_amount: 1,
					dice: 3,
					bonus: 2
					}},  
			title: "warpony"}
	m.top.wolf = {hitdice_amount: 2,
			dice: 8,
			hitdice_bonus: 4,
			ac: 14,
			weapons: {melee: {weaponName: "bite",
					attack_bonus: 3
					dice_amount: 1,
					dice: 6,
					bonus: 1
					}},  
			title: "wolf"}
	m.top.ankheg = {hitdice_amount: 3,
			dice: 10,
			hitdice_bonus: 12,
			ac: 18,
			weapons: {melee: {weaponName: "bite",
					attack_bonus: 7,
					dice_amount: 2,
					dice: 6,
					bonus: 7,
                    effect: "poison"
					}},  
			title: "ankheg"}
	m.top.assassin_vine = {hitdice_amount: 4,
			dice: 8,
			hitdice_bonus: 12,
			ac: 15,
			weapons: {melee: {weaponName: "slam",
					attack_bonus: 7,
					dice_amount: 1,
					dice: 6,
					bonus: 7
                    },
                   alt1: {weaponName:"strangle",
                    attack_bonus: 0,
                    dice_amount: 1,
                    dice: 6,
                    bonus: 7
					}},  
			title: "assassin vine"}
    m.top.bugbear = {hitdice_amount: 3,
			 dice: 8,
			 hitdice_bonus: 3,
			 ac: 17,
			 weapons: {melee: {weaponName:"morningstar",
                        attack_bonus:5,
                        dice_amount:1,
                        dice: 8,
                        bonus: 2
                       },
                       ranged: {weaponName:"javelin",
                        attack_bonus:3,
                        dice_amount:1,
                        dice: 6,
                        bonus: 2
                       }},
			 title: "bugbear"}
	m.top.choker = {hitdice_amount: 3,
			dice: 8,
			hitdice_bonus: 3,
			ac: 17,
			weapons: {melee: {weaponName: "tentacle",
					attack_bonus: 6,
					dice_amount: 1,
					dice: 6,
					bonus: 7
					}},  
			title: "choker"}
	m.top.cockatrice = {hitdice_amount: 5,
			dice: 10,
			hitdice_bonus: 0,
			ac: 14,
			weapons: {melee: {weaponName: "bite",
					attack_bonus: 9,
					dice_amount: 1,
					dice: 4,
					bonus: -2
					}},  
			title: "cockatrice"}
    'DINOSAURS
    m.top.deinonychus = {hitdice_amount: 4,
			 dice: 8,
			 hitdice_bonus: 16,
			 ac: 16,
			 weapons: {melee: {weaponName:"claw",
                        attack_bonus:6,
                        dice_amount:2,
                        dice: 6,
                        bonus: 4
                       },
                       alt1: {weaponName:"bite",
                        attack_bonus:1,
                        dice_amount:2,
                        dice: 4,
                        bonus: 4
                       }},
			 title: "Deinonychus"}
    m.top.megaraptor = {hitdice_amount: 8,
			 dice: 8,
			 hitdice_bonus: 43,
			 ac: 16,
			 weapons: {melee: {weaponName:"talons",
                        attack_bonus:9,
                        dice_amount:2,
                        dice: 8,
                        bonus: 5
                       },
                       alt1: {weaponName:"bite",
                        attack_bonus:4,
                        dice_amount:2,
                        dice: 6,
                        bonus: 2
                       }},
			 title: "Megaraptor"}
    m.top.triceratops = {hitdice_amount: 16,
			 dice: 8,
			 hitdice_bonus: 124,
			 ac: 18,
			 weapons: {melee: {weaponName:"gore",
                        attack_bonus:20,
                        dice_amount:2,
                        dice: 8,
                        bonus: 15
                       }},
			 title: "Triceratops"}
    m.top.tyrannosaurus = {hitdice_amount: 18,
			 dice: 8,
			 hitdice_bonus: 99,
			 ac: 14,
			 weapons: {melee: {weaponName:"bite",
                        attack_bonus:20,
                        dice_amount:3,
                        dice: 6,
                        bonus: 13
                       }},
			 title: "Tyrannosaurus"}

    'DIRE ANIMALS
    m.top.dire_bear = {hitdice_amount: 12,
			 dice: 8,
			 hitdice_bonus: 51,
			 ac: 17,
			 weapons: {melee: {weaponName:"claw",
                        attack_bonus:19,
                        dice_amount:2,
                        dice: 4,
                        bonus: 10
                       },
                       alt1: {weaponName:"bite",
                        attack_bonus:13,
                        dice_amount:2,
                        dice: 8,
                        bonus: 5
                       }},
			 title: "Dire Bear"}
    m.top.dire_rat = {hitdice_amount: 1,
			 dice: 8,
			 hitdice_bonus: 1,
			 ac: 15,
			 weapons: {melee: {weaponName:"bite",
                        attack_bonus:4,
                        dice_amount:1,
                        dice: 4,
                        bonus:0, 
                        effect: "disease"
                       }},
			 title: "Dire Rat"}
    m.top.dire_wolf = {hitdice_amount: 6,
			 dice: 8,
			 hitdice_bonus: 18,
			 ac: 14,
			 weapons: {melee: {weaponName:"bite",
                        attack_bonus:11,
                        dice_amount:1,
                        dice: 8,
                        bonus:10 
                       }},
			 title: "Dire Wolf"}

    'DRAGONS
    m.top.young_red = {hitdice_amount: 13,
			 dice: 12,
			 hitdice_bonus: 39,
			 ac: 21,
			 weapons: {melee: {weaponName:"bite",
                        attack_bonus:20,
                        dice_amount:2,
                        dice: 6,
                        bonus: 7
                       },
                       alt1: {weaponName:"breathe fire",
                        attack_bonus:0,
                        dice_amount:10,
                        dice: 10,
                        bonus: 0,
                        effect: "dragonfire"
                       }},
			 title: "Young Red Dragon"}

    m.top.very_old_red = {hitdice_amount: 31,
			 dice: 12,
			 hitdice_bonus: 248,
			 ac: 36,
			 weapons: {melee: {weaponName:"bite",
                        attack_bonus:40,
                        dice_amount:4,
                        dice: 6,
                        bonus: 13
                       },
                       alt1: {weaponName:"breathe fire",
                        attack_bonus:0,
                        dice_amount:18,
                        dice: 10,
                        bonus: 0,
                        effect: "dragonfire"
                       }},
			 title: "Very Old Red Dragon"}

    m.top.adult_gold = {hitdice_amount: 23,
			 dice: 12,
			 hitdice_bonus: 115,
			 ac: 30,
			 weapons: {melee: {weaponName:"bite",
                        attack_bonus:32,
                        dice_amount:2,
                        dice: 8,
                        bonus: 11
                       },
                       alt1: {weaponName:"breathe fire",
                        attack_bonus:0,
                        dice_amount:12,
                        dice: 10,
                        bonus: 0,
                        effect: "dragonfire"
                       }},
			 title: "Adult Gold Dragon"}

    m.top.young_adult_silver = {hitdice_amount: 19,
			 dice: 12,
			 hitdice_bonus: 79,
			 ac: 28,
			 weapons: {melee: {weaponName:"bite",
                        attack_bonus:24,
                        dice_amount:2,
                        dice: 6,
                        bonus: 6
                       },
                       alt1: {weaponName:"breathe cold",
                        attack_bonus:0,
                        dice_amount:10,
                        dice: 18,
                        bonus: 0,
                        effect: "dragonfreeze"
                       }},
			 title: "Young Adult Silver Dragon"}


    'CREATURES
    m.top.dwarf = {hitdice_amount: 1,
			 dice: 8,
			 hitdice_bonus: 2,
			 ac: 16,
			 weapons: {melee: {weaponName:"waraxe",
                        attack_bonus:3,
                        dice_amount:1,
                        dice: 10,
                        bonus: 1
                       },
                       ranged: {weaponName:"shortbow",
                        attack_bonus:1,
                        dice_amount:1,
                        dice: 6,
                        bonus: 2
                       }},
			 title: "Dwarven Warrior"}
    m.top.earth_elemental = {hitdice_amount: 8,
			 dice: 8,
			 hitdice_bonus: 32,
			 ac: 18,
			 weapons: {melee: {weaponName:"slam",
                        attack_bonus:12,
                        dice_amount:2,
                        dice: 8,
                        bonus:7 
                       }},
			 title: "Earth Elemental"}
    m.top.elf = {hitdice_amount: 1,
			 dice: 8,
			 hitdice_bonus: 4,
			 ac: 15,
			 weapons: {melee: {weaponName:"longsword",
                        attack_bonus:2,
                        dice_amount:1,
                        dice: 8,
                        bonus: 2
                       },
                       ranged: {weaponName:"longbow",
                        attack_bonus:3,
                        dice_amount:1,
                        dice: 8,
                        bonus: 0
                       }},
			 title: "Elf Warrior"}
    m.top.gargoyle = {hitdice_amount: 4,
			 dice: 8,
			 hitdice_bonus: 19,
			 ac: 16,
			 weapons: {melee: {weaponName:"claw",
                        attack_bonus:6,
                        dice_amount:1,
                        dice: 4,
                        bonus:2 
                       }},
			 title: "Gargoyle"}
    m.top.gelatinous_cube = {hitdice_amount: 4,
			 dice: 10,
			 hitdice_bonus: 32,
			 ac: 3,
			 weapons: {melee: {weaponName:"slam",
                        attack_bonus:1,
                        dice_amount:1,
                        dice: 6,
                        bonus: 0,
                        effect: "acid"
                       }},
			 title: "Gelatinous Cube"}
    m.top.ghoul = {hitdice_amount: 2,
			 dice: 12,
			 hitdice_bonus: 0,
			 ac: 14,
			 weapons: {melee: {weaponName:"bite",
                        attack_bonus:2,
                        dice_amount:1,
                        dice: 6,
                        bonus: 0,
                        effect: "paralysis"
                       },
                       alt1: {weaponName:"claws",
                        attack_bonus:0,
                        dice_amount:1,
                        dice: 3,
                        bonus: 0,
                        effect: "paralysis"
                       }},
			 title: "Ghoul"}
    m.top.gnoll = {hitdice_amount: 2,
			 dice: 8,
			 hitdice_bonus: 2,
			 ac: 15,
			 weapons: {melee: {weaponName:"battleaxe",
                        attack_bonus:3,
                        dice_amount:1,
                        dice: 8,
                        bonus: 2
                       },
                       ranged: {weaponName:"shortbow",
                        attack_bonus:1,
                        dice_amount:1,
                        dice: 6,
                        bonus: 0
                       }},
			 title: "Gnoll"}
    m.top.goblin = {hitdice_amount: 1,
			 dice: 8,
			 hitdice_bonus: 1,
			 ac: 15,
			 weapons: {melee: {weaponName:"morningstar",
                        attack_bonus:2,
                        dice_amount:1,
                        dice: 6,
                        bonus: 0
                       },
                       ranged: {weaponName:"javelin",
                        attack_bonus:3,
                        dice_amount:1,
                        dice: 4,
                        bonus: 0
                       }},
			 title: "Goblin"}
    m.top.griffon = {hitdice_amount: 7,
			 dice: 10,
			 hitdice_bonus: 21,
			 ac: 17,
			 weapons: {melee: {weaponName:"bite",
                        attack_bonus:11,
                        dice_amount:2,
                        dice: 6,
                        bonus:4 
                       }},
			 title: "Griffon"}
    m.top.halfling = {hitdice_amount: 1,
			 dice: 8,
			 hitdice_bonus: 1,
			 ac: 16,
			 weapons: {melee: {weaponName:"shortsword",
                        attack_bonus:3,
                        dice_amount:1,
                        dice: 6,
                        bonus: 0
                       },
                       ranged: {weaponName:"light crossbow",
                        attack_bonus:3,
                        dice_amount:1,
                        dice: 6,
                        bonus: 0
                       }},
			 title: "Halfling Theif"}
    m.top.hellhound = {hitdice_amount: 4,
			 dice: 8,
			 hitdice_bonus: 4,
			 ac: 16,
			 weapons: {melee: {weaponName:"bite",
                        attack_bonus:5,
                        dice_amount:1,
                        dice: 8,
                        bonus: 0,
                        effect: "fire"
                       }},
			 title: "Hellhound"}
    m.top.hill_giant = {hitdice_amount: 12,
			 dice: 8,
			 hitdice_bonus: 48,
			 ac: 20,
			 weapons: {melee: {weaponName:"greatclub",
                        attack_bonus:16,
                        dice_amount:2,
                        dice: 8,
                        bonus: 10
                       },
                       ranged: {weaponName:"rock",
                        attack_bonus:8,
                        dice_amount:2,
                        dice: 6,
                        bonus: 7
                       }},
			 title: "Hill Giant"}
    m.top.hobgoblin = {hitdice_amount: 1,
			 dice: 8,
			 hitdice_bonus: 2,
			 ac: 15,
			 weapons: {melee: {weaponName:"longsword",
                        attack_bonus:2,
                        dice_amount:1,
                        dice: 8,
                        bonus: 1
                       },
                       ranged: {weaponName:"javelin",
                        attack_bonus:2,
                        dice_amount:1,
                        dice: 6,
                        bonus: 1
                       }},
			 title: "Hobgoblin"}
    m.top.human_commoner = {hitdice_amount: 1,
			 dice: 8,
			 hitdice_bonus: 1,
			 ac: 12,
			 weapons: {melee: {weaponName:"dagger",
                        attack_bonus:1,
                        dice_amount:1,
                        dice: 6,
                        bonus: 1
                       },
                       ranged: {weaponName:"sling",
                        attack_bonus:1,
                        dice_amount:1,
                        dice: 4,
                        bonus: 0
                       }},
			 title: "Commoner Thug"}
    m.top.kobold = {hitdice_amount: 1,
			 dice: 8,
			 hitdice_bonus: 0,
			 ac: 15,
			 weapons: {melee: {weaponName:"spear",
                        attack_bonus:1,
                        dice_amount:1,
                        dice: 6,
                        bonus: -1
                       },
                       ranged: {weaponName:"sling",
                        attack_bonus:3,
                        dice_amount:1,
                        dice: 3,
                        bonus: 0
                       }},
			 title: "Kobold"}
    m.top.lizardfolk = {hitdice_amount: 2,
			 dice: 8,
			 hitdice_bonus: 12,
			 ac: 15,
			 weapons: {melee: {weaponName:"club",
                        attack_bonus:2,
                        dice_amount:1,
                        dice: 6,
                        bonus: 1
                       },
                       alt1: {weaponName:"claw",
                        attack_bonus:2,
                        dice_amount:1,
                        dice: 4,
                        bonus: 1
                       },
                       ranged: {weaponName:"javelin",
                        attack_bonus:1,
                        dice_amount:1,
                        dice: 6,
                        bonus: 1
                       }},
			 title: "Kobold"}
    m.top.ogre = {hitdice_amount: 4,
			 dice: 8,
			 hitdice_bonus: 11,
			 ac: 16,
			 weapons: {melee: {weaponName:"greatclub",
                        attack_bonus:8,
                        dice_amount:2,
                        dice: 8,
                        bonus: 7
                       },
                       ranged: {weaponName:"javelin",
                        attack_bonus:1,
                        dice_amount:1,
                        dice: 8,
                        bonus: 5
                       }},
			 title: "Ogre"}
    m.top.orc = {hitdice_amount: 1,
			 dice: 8,
			 hitdice_bonus: 1,
			 ac: 13,
			 weapons: {melee: {weaponName:"falchion",
                        attack_bonus:4,
                        dice_amount:2,
                        dice: 4,
                        bonus: 4
                       },
                       ranged: {weaponName:"javelin",
                        attack_bonus:1,
                        dice_amount:1,
                        dice: 6,
                        bonus: 3
                       }},
			 title: "Orc Warrior"}
    m.top.owlbear = {hitdice_amount: 5,
			 dice: 10,
			 hitdice_bonus: 25,
			 ac: 15,
			 weapons: {melee: {weaponName:"claw",
                        attack_bonus:9,
                        dice_amount:1,
                        dice: 6,
                        bonus: 5
                       }},
			 title: "Owlbear"}
    m.top.shadow = {hitdice_amount: 3,
			 dice: 12,
			 hitdice_bonus: 0,
			 ac: 13,
			 weapons: {melee: {weaponName:"touch",
                        attack_bonus:3,
                        dice_amount:1,
                        dice: 6,
                        bonus: 0,
                        effect: "strength_drain"
                       }},
			 title: "Shadow"}
    m.top.shambling_mound = {hitdice_amount: 8,
			 dice: 8,
			 hitdice_bonus: 24,
			 ac: 20,
			 weapons: {melee: {weaponName:"slam",
                        attack_bonus:11,
                        dice_amount:2,
                        dice: 6,
                        bonus: 5
                       },
                       alt1: {weaponName:"strangle",
                        attack_bonus:0,
                        dice_amount:2,
                        dice: 6,
                        bonus: 0
                       }},
			 title: "Shambling Mound"}
    m.top.skeleton_warrior = {hitdice_amount: 1,
			 dice: 12,
			 hitdice_bonus: 0,
			 ac: 15,
			 weapons: {melee: {weaponName:"scimitar",
                        attack_bonus:1,
                        dice_amount:1,
                        dice: 6,
                        bonus: 1
                       }},
			 title: "Skeleton Warrior"}
    m.top.stirge = {hitdice_amount: 1,
			 dice: 10,
			 hitdice_bonus: 0,
			 ac: 16,
			 weapons: {melee: {weaponName:"touch",
                        attack_bonus:7,
                        dice_amount:1,
                        dice: 4,
                        bonus: 0,
                        effect: "immobilize"
                       }},
			 title: "Strige"}
    m.top.stone_golem = {hitdice_amount: 14,
			 dice: 10,
			 hitdice_bonus: 30,
			 ac: 26,
			 weapons: {melee: {weaponName:"slam",
                        attack_bonus:18,
                        dice_amount:2,
                        dice: 10,
                        bonus:9 
                       }},
			 title: "Stone Golem"}
    m.top.troll = {hitdice_amount: 6,
			 dice: 8,
			 hitdice_bonus: 36,
			 ac: 16,
			 weapons: {melee: {weaponName:"claw",
                        attack_bonus:9,
                        dice_amount:1,
                        dice: 6,
                        bonus: 6
                       }},
			 title: "Troll"}
    m.top.werewolf = {hitdice_amount: 3,
			 dice: 8,
			 hitdice_bonus: 7,
			 ac: 16,
			 weapons: {melee: {weaponName:"claw",
                        attack_bonus:4,
                        dice_amount:1,
                        dice: 4,
                        bonus: 2
                       }},
			 title: "Werewolf"}
    m.top.wight = {hitdice_amount: 4,
			 dice: 12,
			 hitdice_bonus: 0,
			 ac: 15,
			 weapons: {melee: {weaponName:"slam",
                        attack_bonus:3,
                        dice_amount:1,
                        dice: 4,
                        bonus: 1,
                        effect: "energy_drain"
                       }},
			 title: "Wight"}
    m.top.wyvern = {hitdice_amount: 7,
			 dice: 12,
			 hitdice_bonus: 14,
			 ac: 18,
			 weapons: {melee: {weaponName:"sting",
                        attack_bonus:10,
                        dice_amount:1,
                        dice: 6,
                        bonus: 4,
                        effect: "poison"
                       },
                       alt1: {weaponName:"talon",
                        attack_bonus:10,
                        dice_amount:2,
                        dice: 6,
                        bonus: 4
                       },
                       alt2: {weaponName:"bite",
                        attack_bonus:10,
                        dice_amount:2,
                        dice: 8,
                        bonus: 4
                       }},
			 title: "Wyvern"}
    m.top.zombie = {hitdice_amount: 2,
			 dice: 12,
			 hitdice_bonus: 3,
			 ac: 11,
			 weapons: {melee: {weaponName:"slam",
                        attack_bonus:2,
                        dice_amount:1,
                        dice: 6,
                        bonus: 1
                       },
                       alt1: {weaponName:"club",
                        attack_bonus:2,
                        dice_amount:1,
                        dice: 6,
                        bonus: 1
                       }},
			 title: "Zombie"}
end sub
