'first function run on startup.
sub Main(args as Dynamic) 
    showHomeScreen()
end sub

'The function that brings the content to the screen.
sub showHomeScreen()
    m.screen = CreateObject("roSGScreen")
    m._port = CreateObject("roMessagePort")
    rokuAppInfo = CreateObject("roAppInfo")
    appVersion = rokuAppInfo.getVersion() 'For debugging.

    m.screen.setMessagePort(m._port)
    m.scene = m.screen.CreateScene("rcw_RootScene")
    m.screen.show()
    m.scene.observeField("exitApp", m._port)
    while(true)
        msg = wait(100, m._port)
        msgType = type(msg)
        if msgType <> "Invalid"
        end if
        if msgType = "roSGScreenEvent" then
            if msg.isScreenClosed() then return
        else if msgType = "roSGNodeEvent" then
            field = msg.getField()
            if field = "exitApp" then
                exit while
            end if
        end if
    end while
end sub

