'This creates the event node and adds it to the global event holder. The
'RootScene is listening to that field and will handle the event itself.
sub fireEvent(eventType as String, data = {} as object)
    time = CreateObject("roDateTime")
    event = CreateObject("roSGNode", "EventNode")
    time = CreateObject("roDateTime")
    event.id = "event_" + time.asSeconds().toStr()
    event.evType = eventType
    ?"FIRING EVENT: ";eventType
    event.data = data
    'TODO: Figure out if I need to use pre/post to prevent overwrites
    pre = m.global.events.queue.count()
    events = m.global.events
    events.queue.push(event)
    m.global.events = events
    post = m.global.events.queue.count()
    m.global.events.timer.control = "start"
end sub
