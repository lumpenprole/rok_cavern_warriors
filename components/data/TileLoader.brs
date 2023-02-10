sub init()
    ?"HERE IN TILELOADER"
end sub

sub getTileset()
    folderName = m.top.tileset_folder_name
    path = "pkg:/locale/default/tiles/" + folderName + "/tileset.json"
    ?"PATH: "; path
    response = parseJson(readAsciiFile(path))
    m.top.tileset_obj = response
end sub
