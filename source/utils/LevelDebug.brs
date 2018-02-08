function printLevel(levelArr)
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
end function
