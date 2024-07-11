sub init()
	?"EVENT GROUP CREATED"
end sub

sub onEventCallback(eventData as Object)
    ?"Event callback called in EventGroup: "; eventData
end sub
