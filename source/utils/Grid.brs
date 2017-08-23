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


