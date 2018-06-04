'This creates the event node and adds it to the global event holder. The
'RootScene is listening to that field and will handle the event itself.
function fireEvent(eventType as String, data = {} as object)
    time = CreateObject("roDateTime")
    event = CreateObject("roSGNode", "EventNode")
    time = CreateObject("roDateTime")
    event.id = "event_" + time.asSeconds().toStr()
    event.evType = eventType
    event.data = data
    queue = m.global.event
    queue.push(event)
    m.global.event = queue
    m.global.eventFlag = time.asSeconds()
end function
