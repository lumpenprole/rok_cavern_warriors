sub printLevel(levelArr)
    ?"****LEVEL****"
    ?""
    ?""
    rows = []
    for x = 0 to levelArr.count() - 1
        for y = 0 to levelArr[x].count() - 1
            if rows[y] = Invalid
                rows[y] = []
            end if

            rows[y].push(levelArr[x][y])
        end for
    end for


    for index = 0 to rows.count() - 1
        row = rows[index]
        printRow = "|"
        for column = 0 to row.count() -1
            gridSquare = row[column]
            if gridSquare = Invalid
                printRow += " "
            else
                gType = gridSquare.split(":")[0]
                if gType = "wall"
                    printRow = printRow + "^"
                else if gType = "floor"
                    printRow += "."
                else if gType = "upstairs"
                    printRow += "<"
                else if gType = "downstairs"
                    printRow += ">"
                else
                    printRow += " "
                end if
            end if
        end for
        printRow += "|"
        ?printRow
    end for
    ?""
    ?""
end sub

'this is a specific debug for the BSP generator. 
sub printTree(tree, levelArr)
    for x = 0 to tree.count() - 1
        thisLevel = tree[x]
        for y = 0 to thisLevel.count() - 1
            thisBox = thisLevel[y]
            for w = thisBox[0] to thisBox[3] - 1
                for h = thisBox[1] to thisBox[2] - 1
                    if w = thisBox[0] or w = thisBox[3] - 1 or h = thisbox[1] or h = thisBox[2] - 1
                        levelArr[w][h] = "wall:none"
                    else
                        levelArr[w][h] = "floor:none"
                    end if
                end for
            end for
        end for
    end for

    printLevel(levelArr)
end sub

