function createGrid(screenSize, tileSize as Integer) as Dynamic
    gridWidth = int(screenSize[1] / tileSize)
    gridHeight = int(screenSize[0] / tileSize)

    gridX = int((screenSize[0] mod tileSize) / 2)
    gridY = int((screenSize[1] mod tileSize) / 2)

    return [[gridWidth, gridHeight], [gridX, gridY]]
end function

function getTileXY(grid as Object, tile as Object, tileSize as Integer) as Dynamic
    tileX = (tile[0] * tileSize) + grid[1][0]
    tileY = (tile[1] * tileSize) + grid[1][1]

    return [tileX, tileY]
end function


function getNextTile(direction as String, currentLocation as Object)
    tileSize = [10, 10]
    newLocation = currentLocation
    if m.global.settings.tile_size <> invalid
        tileSize = m.global.settings.tile_size
    end if

    if direction = "left"
        newLocation[0] = Int(newLocation[0]) - tileSize
    else if direction = "right"
        newLocation[0] = Int(newLocation[0]) + tileSize
    else if direction = "up"
        newLocation[1] = Int(newLocation[1]) - tileSize
    else if direction = "down"
        newLocation[1] = Int(newLocation[1]) + tileSize
    end if

    return newLocation
end function
