sub init()
    m.top.functionName = "getTileset"
end sub

sub getTileset()
    folderName = m.top.tileset_folder_name
    path = "pkg:/locale/default/tiles/" + folderName + "/tileset.json"
    response = parseJson(readAsciiFile(path))
    m.top.tileset_obj = response
end sub
