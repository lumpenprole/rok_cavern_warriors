function getItem(name, itemType = "") as Object
    for i = 0 to m.global.settings.items.count()
        item = m.global.settings.items[i]
        if itemType = ""
            if name = item.name and itemType = item.itemType
                return item
            end if
        else
            if name = item.name
                return item
            end if
        end if
    end for
end function

'We should probably handle item modifiers here
