sub init()
    ?"PLAYER INIT()"
    m.tilePath = m.raceSettings.human_tile
end sub

sub postSetup()
    m.hitPoints = m.hitPoints + 5
    ?"FINAL HIT POINTS: ";m.hitPoints
end sub
