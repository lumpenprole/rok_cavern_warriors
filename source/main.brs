'first function run on startup.
function Main(args as Dynamic) as void
    showHomeScreen()
end function

'The function that brings the content to the screen.
sub showHomeScreen()
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    rokuAppInfo = CreateObject("roAppInfo")
    appVersion = rokuAppInfo.getVersion() 'For debugging.

    screen.setMessagePort(m.port)
    m.scene = screen.CreateScene("rcw_RootScene")
    screen.show()
    while(true)
        msg = wait(100, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        endif
    end while
end sub

