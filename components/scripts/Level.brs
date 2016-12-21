sub init()
    ?"Level: Init()"
    m.loadTxt = m.top.findNode("loading_text")

    'TODO: Rewrite this so that it designs the map, then draws it. 
end sub

sub setupLevel()
    settings = m.top.settings
    '###########################################################
    '#####################TEST CODE#############################
    '###########################################################
    size = [500,500]


    
    roomStartX = cInt((1920 / 2) - (size[0] / 2)) - (size[0] / 2)
    roomStartY = cInt((1080 / 2) - (size[1] / 2)) - (size[1] / 2)

    ?"STARTX: ";startX
    ?"STARTY: ";startY

    ?"Settings: ";settings

    currentPos = [roomStartX,roomStartY]

    for r = 0 to size[1]
        thisRoom = createRoom(size)
        thisRoom.id = "room_" + r.toStr()
        thisRoom.translation = [roomStartX,startY]
        m.roomHolder.appendChild(thisRoom)
    end for
'    for y = 0 to size[1]
'        for x = 0 to size[0]
'            tile = createObject("roSGNode", "rcw_Tile")
'            if y = 0 or y = size[1] or x = 0 or x = size[0]
'                tile.tileType = "wall"
'            else
'                tile.tileType = "floor"
'            end if
'            tile.translation = currentPos
'            m.top.appendChild(tile)
'            currentPos[0] = currentPos[0] + 10
'        end for
'        currentPos[1] = currentPos[1] + 10
'        currentPos[0] = startX
'    end for


    m.loadTxt.visible = false
end sub

function createRoom(size as Object) as Object
    'TODO: I need a room object
    room = createObject("roSGNode", "Rectangle")
    room.width = size[0]
    room.height = size[1]
    room.color = "0xABAD96FF"

    return room
end function 
