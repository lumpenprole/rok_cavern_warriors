sub init()
    ?"RootScene: Init()"
    m.top.id = "RootScene"

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
    m.top.appendChild(charSelect)
    charSelect.setFocus(true)
end sub

sub startGame()
    ?"START GAME"
    testLevel = createObject("roSGNode", "rcw_Level")
    settings = createObject("roSGNode", "LevelSettingsNode") 'We probably need a level settings object
    m.levelHolder.appendChild(testLevel)
    testLevel.settings = settings

    player = createObject("roSGNode", "rcw_player")
    m.playerHolder.appendChild(player)


end sub

sub onEventCallback()
    ev = m.top.eventCallback

    if ev.evType = "startGame"
        startGame()
    end if
end sub
