sub init()
    ?"PLAYER INIT()"
    m.tilePath = "pkg://locale/default/images/player/base/" + m.raceSettings.human_tile
    m.top.seen = true
end sub

sub postSetup()
    m.top.hitPoints = m.top.hitPoints + 5
    ?"FINAL HIT POINTS: ";m.top.hitPoints
    'CHECK IF ALL OPTIONS ARE SET BEFORE CREATING TILE
end sub
