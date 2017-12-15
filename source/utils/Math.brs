'Return a random number between two numbers inclusive
function getRandomRange(a as Integer, b as Integer) as Integer
    aNum = b-a+1
    bNum = a-1
    rNum = rnd(aNum)
    retInt = rNum + bNum
    return retInt
end function
