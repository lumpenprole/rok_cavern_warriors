sub init()
    ?"RootScene: Init()"
    m.top.id = "RootScene"
    m.messageActive = false

    m.screenSize = [1080, 1920] 'Probably needs to be figured on the fly

    setup()
end sub

sub setup()
    eventTimer = createObject("roSGNode", "Timer")
    eventTimer.duration = .01
    eventTimer.repeat = false
    eventTimer.observeField("fire", "handleEvent")

    m.global.addFields({
        events: {
            timer: eventTimer,
            queue: []
        }
    })

    'Event node:
    'id: A unique id that's used in identifying the event. I'm not sure we need it, but we might want to cancel events
    'type: The event type. This will be the key in the dictionary used to send event results to subscribed nodes.
    'data: An object holding any data the event needs

    m.eventDict = {}

    m.levelHolder = m.top.findNode("level_holder")
    m.playerHolder = m.top.findNode("player_holder")
    m.monsterHolder = m.top.findNode("monster_holder")
    m.statusBarHolder = m.top.findNode("status_holder")
    m.modalHolder = m.top.findNode("modal_holder")

    subscribe("startGame", m.top.id)
    subscribe("goDownstairs", m.top.id)
    subscribe("goUpstairs", m.top.id)
    subscribe("statusUpdate", m.top.id)
    subscribe("systemMessage", m.top.id)
    subscribe("removeMessage", m.top.id)

    m.global.addField("settings", "node", false) 'Setting always notify to false, settings are read only
    m.global.settings = createObject("roSGNode", "AppSettingsNode")
    m.global.settings.addField("monster", "node", false) 
    m.global.settings.monster = createObject("roSGNode", "MonsterSettingsNode")
    m.global.settings.addField("items", "node", false) 
    m.global.settings.items = createObject("roSGNode", "ItemSettingsNode")
    m.tilesetParser = createObject("roSGNode", "rcw_TileLoader")
    m.tilesetParser.tileset_folder_name = m.global.settings.tileset
    m.tilesetParser.observeField("tileset_obj", "tilesetParsed")
    m.tilesetParser.control = "RUN"
end sub

sub tilesetParsed(msg as object)
    m.global.settings.addField("tilemap", "assocarray", false)
    m.global.settings.tilemap = msg.getData().tileset
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
    if m.global.events.queue.count() > 0
        queue = m.global.events.queue
        ev = queue.pop()
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
        m.global.events.queue = queue
    end if
end sub

'broadcast event to all subscribers
sub broadcastEvent(evType as String, data as dynamic)
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
    m.currentLevel = 0
    statusBarSize = 50 'TODO: put in settings
    level0 = createObject("roSGNode", "rcw_Level")
    level0.id = "level0"
    level0.levelDepth = 0
    m.levelSettings = createObject("roSGNode", "LevelSettingsNode")
    m.global.addField("grid", "array", false) 'Setting always notify to false, settings are read only
    m.global.grid = createGrid(m.screenSize, m.global.settings.tile_size, statusBarSize)
    subscribe("handleGameModalOnOff", level0.id)
    
    bottom = m.screenSize[0] - statusBarSize
    m.statusBarHolder.translation = [0, bottom]
    rect = CreateObject("roSGNode", "Rectangle")
    rect.width = m.screenSize[1]
    rect.height = statusBarSize
    rect.color = "0x276CDBFF"
    m.statusBarHolder.appendChild(rect)

    'TODO: Make the status bar a custom object with labels for each field
    m.statusBar = CreateObject("roSGNode", "Label")
    m.statusBar.height = statusBarSize
    m.statusBar.width = m.screenSize[1]
    m.statusBar.color = "0xFFFFFFFF"
    statusFont = CreateObject("roSGNode", "Font")
    statusFont.uri = "pkg:/locale/default/fonts/Roboto-Black.ttf"
    statusFont.size = 36
    m.statusBar.font = statusFont
    m.statusBarHolder.appendChild(m.statusBar)

    charSelect = m.top.findNode("charSelect") 'I probably don't need to build a nav stack. 
    m.top.removeChild(charSelect)

    m.gameModal = CreateObject("roSGNode", "rcw_GameModal")
    m.gameModal.visible = false
    m.gameModal.translation = [600,100]
    m.gameModal.id = "mainModal"
    subscribe("handleGameModalOnOff", m.gameModal.id)
    subscribe("modalKeyEvent", m.gameModal.id)
    m.modalHolder.appendChild(m.gameModal)

    m.levelHolder.appendChild(level0)
    level0.settings = m.levelSettings 

    player = CreateObject("roSGNode", "rcw_Player")
    player.id = "current_player"
    player.class = data.class
    player.race = data.race

    currentHolder = level0.findNode("player_holder")
    currentHolder.appendChild(player)
    level0.playerSet = true
    level0.setFocus(true)
    updateStatus()
end sub

sub goDownstairs()
    nextLevelNum = m.currentLevel + 1
    currentPlayerHolder = m.levelHolder.getChild(m.currentLevel).findNode("player_holder")
    player = currentPlayerHolder.findNode("current_player")
    currentPlayerHolder.removeChildren(player)

    if nextLevelNum > m.levelHolder.getChildCount() - 1
        currentLevel = m.levelHolder.getChild(m.currentLevel)
        'CREATE NEW LEVEL
        nextLevel = createObject("roSGNode", "rcw_Level")
        nextLevel.levelDepth = nextLevelNum
        nextLevel.settings = m.levelSettings
        m.levelHolder.appendChild(nextLevel)
        subscribe("handleGameModalOnOff", nextLevel.id)
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

sub updateStatus()
    currentPlayerHolder = m.levelHolder.getChild(m.currentLevel).findNode("player_holder")
    player = currentPlayerHolder.findNode("current_player")
    m.statusBar.text = "Level" + player.level.toStr() + " " + player.race + " " + player.class + "  HP:" + player.hitPoints.toStr()
end sub

sub systemMessage(evData)
    m.message = CreateObject("roSGNode", "rcw_Message")
    m.message.messageText = evData.messageText
    m.top.appendChild(m.message)
    m.messageActive = true
end sub

sub removeMessage()
    m.top.removeChild(m.message)
    m.messageActive = false
end sub

sub onEventCallback()
    ev = m.top.eventCallback

    if ev.evType = "startGame"
        startGame(ev.data)
    else if ev.evType = "goDownstairs"
        goDownstairs()
    else if ev.evType = "goUpstairs"
        goUpstairs()
    else if ev.evType = "statusUpdate"
        updateStatus()
    else if ev.evType = "systemMessage"
        systemMessage(ev.data)
    else if ev.evType = "removeMessage"
        removeMessage()
    end if
end sub
