sub init()
    ?"PLAYER INIT()"
    m.tilePath = m.raceSettings.human_tile
    m.top.seen = true
end sub

sub postSetup()
    m.top.hitPoints = m.top.hitPoints + 5
    ?"FINAL HIT POINTS: ";m.top.hitPoints
end sub
