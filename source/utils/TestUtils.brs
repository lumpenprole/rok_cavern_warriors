sub showLevelArr(lvl as Object)
    'This is a utility for printing the level array to the console
    strings = []
    for x = 0 to lvl.count() - 1
        strings[x] = ""
        for y = 0 to lvl[x].count() - 1
            tile = lvl[x][y]
            tileType = tile.split(":")[0]
            if tileType = "none"
                strings[x] = strings[x] + "0"
            else 
                strings[x] = strings[x] + "1"
            end if
        end for
    end for

    for s = 0 to strings.count() - 1
        ?strings[s]
    end for
end sub
