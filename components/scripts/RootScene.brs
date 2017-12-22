sub init()
    ?"RootScene: Init()"
    m.top.id = "RootScene"

    m.screenSize = [1080, 1920] 'Probably needs to be figured on the fly

    setup()
end sub

sub setup()
    'I'm probably going to have to refactor this to be a true
    'queue. But I really want to get something moving now. 
    m.global.addField("event", "node", true)
    m.global.observeField("event", "handleEvent")

    'Event node:
    'id: A unique id that's used in identifying the event. I'm not sure we need it, but we might want to cancel events
    'type: The event type. This will be the key in the dictionary used to send event results to subscribed nodes.
    'data: An object holding any data the event needs

    m.eventDict = {}

    m.levelHolder = m.top.findNode("level_holder")
    m.playerHolder = m.top.findNode("player_holder")
    m.monsterHolder = m.top.findNode("monster_holder")

    subscribe("startGame", m.top.id)
    subscribe("goDownstairs", m.top.id)
    subscribe("goUpstairs", m.top.id)
    openCharSelect()
end sub

'Subscribe to an event will be an event.
sub subscribe(evType as String, nodeId as String)
    if not m.eventDict.doesExist(evType)
        m.eventDict[evType] = []
    end if

    m.eventDict[evType].push(nodeId)
end sub

sub unsubscribe(evType as String, nodeId as String)
    for x = 0 to m.eventDict[evType].Count() - 1
        if m.eventDict[evType][x] = nodeId
            m.eventDict[evType].Delete(x)
            exit for
        end if
    end for
end sub

'This will basically be the event lookup table
sub handleEvent()
    ev = m.global.event
    evType = ev.evType
    data = ev.data
    if evType = "subscribe"
        'TODO: check for fields and throw error if they don't exist.
        subscribe(data.evType, data.nodeId)
    else if evType = "unsubscribe"
        'TODO: check for fields and throw error if they don't exist.
        unsubscribe(data.evType, data.nodeId)
    else
        broadcastEvent(evType, data)
    end if
end sub

'broadcast event to all subscribers
sub broadcastEvent(evType as String, data as dynamic)
    ?"Firing event result handler for event : ";evType
    callbackNode = createObject("roSGNode", "EventCallbackNode")
    callbackNode.evType = evType
    callbackNode.data = data
    if m.eventDict.doesExist(evType)
        for x = 0 to m.eventDict[evType].Count() - 1
            node = m.top.FindNode(m.eventDict[evType][x])
            node.eventCallback = callbackNode
        end for
    end if
end sub

sub openCharSelect()
    charSelect = createObject("roSGNode", "rcw_CharSelect")
    charSelect.id = "charSelect"
    m.top.appendChild(charSelect)
    charSelect.setFocus(true)
end sub

sub startGame(data as dynamic)
    ?"START GAME"
    m.currentLevel = 0
    level0 = createObject("roSGNode", "rcw_Level")
    level0.id = "level0"
    m.levelSettings = createObject("roSGNode", "LevelSettingsNode")
    m.global.addField("settings", "node", false) 'Setting always notify to false, settings are read only
    m.global.settings = createObject("roSGNode", "AppSettingsNode")
    m.global.addField("grid", "array", false) 'Setting always notify to false, settings are read only
    m.global.grid = createGrid(m.screenSize, m.global.settings.tile_size)
    ?"GRID SIZE: ";m.global.grid[0]

    charSelect = m.top.findNode("charSelect") 'I probably don't need to build a nav stack. 
    m.top.removeChild(charSelect) 

    m.levelHolder.appendChild(level0)
    level0.settings = m.levelSettings 

    player = createObject("roSGNode", "rcw_Player")
    player.id = "current_player"
    player.class = data.class
    ?"PLAYER IS CLASS: ";data.class

    'm.playerHolder.appendChild(player) This probably isn't the way to go.
    'I'm thinking I need to put the player in the level to check walls, etc. 

    currentHolder = level0.findNode("player_holder")
    currentHolder.appendChild(player)
    level0.playerSet = true
    level0.setFocus(true)
end sub

sub goDownstairs()
    nextLevelNum = m.currentLevel + 1
    ?"NEXT LEVEL: ";nextLevelNum
    ?"LEVEL COUNT: ";m.levelHolder.getChildCount() - 1
    currentPlayerHolder = m.levelHolder.getChild(m.currentLevel).findNode("player_holder")
    player = currentPlayerHolder.findNode("current_player")
    currentPlayerHolder.removeChildren(player)

    if nextLevelNum > m.levelHolder.getChildCount() - 1
        currentLevel = m.levelHolder.getChild(m.currentLevel)
        'CREATE NEW LEVEL
        nextLevel = createObject("roSGNode", "rcw_Level")
        nextLevel.settings = m.levelSettings
        m.levelHolder.appendChild(nextLevel)
        currentHolder = nextLevel.findNode("player_holder")
        currentHolder.appendChild(player)
        nextLevel.playerSet = true
        nextLevel.setFocus(true)
        m.currentLevel = nextLevelNum 
    else
        'SHOW LEVEL
        currentPlayerHolder = m.levelHolder.getChild(m.currentLevel).findNode("player_holder")
        player = currentPlayerHolder.findNode("current_player")
        currentPlayerHolder.removeChildren(player)
        nextLevel = m.levelHolder.getChild(nextLevelNum)
        nextHolder = nextLevel.findNode("player_holder")
        nextHolder.appendChild(player)
        m.levelHolder.getChild(m.currentLevel).visible = false
        nextLevel.visible = true
        nextLevel.setFocus(true)
        nextLevel.playerStairs = "down" 
        m.currentLevel = nextLevelNum
    end if
end sub

sub goUpstairs()
    if m.currentLevel = 0
        ?"FIRE QUIT MODAL HERE"
    else
        nextLevelNum = m.currentLevel - 1
        currentPlayerHolder = m.levelHolder.getChild(m.currentLevel).findNode("player_holder")
        player = currentPlayerHolder.findNode("current_player")
        currentPlayerHolder.removeChildren(player)
        nextLevel = m.levelHolder.getChild(nextLevelNum)
        nextHolder = nextLevel.findNode("player_holder")
        nextHolder.appendChild(player)
        m.levelHolder.getChild(m.currentLevel).visible = false
        nextLevel.visible = true
        nextLevel.setFocus(true)
        nextLevel.playerStairs = "up" 
        m.currentLevel = nextLevelNum
    end if
end sub

sub onEventCallback()
    ev = m.top.eventCallback

    if ev.evType = "startGame"
        startGame(ev.data)
    else if ev.evType = "goDownstairs"
        goDownstairs()
    else if ev.evType = "goUpstairs"
        goUpstairs()
    end if
end sub
