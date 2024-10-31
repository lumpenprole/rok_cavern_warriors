sub init()
end sub

sub handleData()
    listData = m.top.data
    for each itemLabel in listData
        thisNode = CreateObject("roSGNode", "ContentNode")
        thisNode.title = itemLabel
        ?"ADDING NODE WITH TITLE: "; itemLabel
        m.top.appendChild(thisNode)
    end for
end sub