'This creates the event node and adds it to the global event holder. The
'RootScene is listening to that field and will handle the event itself.
function fireEvent(eventType as String, data as object)
    event = CreateObject("roSGNode", "EventNode")
    time = CreateObject("roDateTime")
    event.id = "event_" + time.asSeconds().toStr()
    event.evType = eventType
    event.data = data
    m.global.event = event
end function
