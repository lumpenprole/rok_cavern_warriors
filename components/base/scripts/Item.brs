sub init()
	?"ITEM CREATED"
	m.tileHolder = m.top.findNode("tile_holder")
end sub

sub onTypeSet()
	itemType = m.top.itemType
	?"ITEM TYPE: "; itemData
	itemData = m.global.settings.items.getField(itemType[1])
	?"ITEM DATA: "; itemData
	addTile(itemType)
end sub

sub addTile(itemType)
	path = getTilePath(itemType[0], itemType[1])
    tile = createObject("roSGNode", "Poster")
    tile.loadDisplayMode = "scaleToFill"
    tile.loadWidth = m.tileSize
    tile.loadHeight = m.tileSize
    tile.uri = path
    m.tileHolder.appendChild(tile)
end sub

function getTilePath(tileType as String, tileRace as String, tileSex = "none" as String) as String
    tiles = m.global.settings.tilemap[tileType]
    tilePath = "pkg:/locale/default/tiles/" + m.global.settings.tileset + "/"
    if tileSex <> "none"
        tileRace = tileRace + "_" + tileSex
    end if
    tilePath = tilePath + tiles[tilerace]
    return tilePath
end function

sub onSeenSet()
    m.tileHolder.visible = m.top.seen
end sub

