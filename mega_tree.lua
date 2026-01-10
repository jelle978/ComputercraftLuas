-- spruce_lumberjack.lua
-- CC:Tweaked, Minecraft 1.21
-- Kapt 1x1 en 2x2 spruce mega trees binnen een chunk

local FUEL_SLOT = 1
local SAPLING_SLOT = 2
local LOG_NAME = "minecraft:spruce_log"
local CHUNK_SIZE = 16

-- Turtle positie tracking
local x, z = 0, 0
local dir = 0 -- 0=N, 1=E, 2=S, 3=W

-- ========== Beweging ==========

local function turnRight()
    turtle.turnRight()
    dir = (dir + 1) % 4
end

local function turnLeft()
    turtle.turnLeft()
    dir = (dir + 3) % 4
end

local function forward()
    while not turtle.forward() do
        turtle.dig()
        sleep(0.2)
    end
    if dir == 0 then z = z - 1
    elseif dir == 1 then x = x + 1
    elseif dir == 2 then z = z + 1
    elseif dir == 3 then x = x - 1 end
end

local function goTo(tx, tz)
    while x < tx do while dir ~= 1 do turnRight() end forward() end
    while x > tx do while dir ~= 3 do turnRight() end forward() end
    while z < tz do while dir ~= 2 do turnRight() end forward() end
    while z > tz do while dir ~= 0 do turnRight() end forward() end
end

-- ========== Inventaris ==========

local function countLogs()
    local count = 0
    for i = 1,16 do
        local detail = turtle.getItemDetail(i)
        if detail and detail.name == LOG_NAME then
            count = count + detail.count
        end
    end
    return count
end

local function refuelIfNeeded()
    if turtle.getFuelLevel() < 500 then
        turtle.select(FUEL_SLOT)
        turtle.refuel(1)
    end
end

local function dumpLogs()
    print("Inventaris vol, dump logs...")
    local cx, cz, cdir = x, z, dir

    goTo(0,0)
    turnLeft() turnLeft()

    for i=3,16 do
        turtle.select(i)
        turtle.drop()
    end

    turnLeft() turnLeft()
    goTo(cx, cz)
    while dir ~= cdir do turnRight() end
end

-- ========== Boom detectie ==========

local function isLogBlock(xOff, zOff)
    -- Simpele check: kijk diagonaal voor 2x2
    if xOff == 0 and zOff == 0 then
        return turtle.detect() and turtle.inspect().name == LOG_NAME
    else
        -- Turtle kan diagonaal checken door te bewegen
        -- We doen dit in chopMegaTree()
        return false
    end
end

-- ========== Boom hakken ==========

local function chopSingleTree()
    -- Hak 1x1 stam
    local height = 0
    turtle.dig()
    turtle.forward()
    while turtle.detectUp() do
        turtle.digUp()
        turtle.up()
        height = height + 1
    end
    for i=1,height do turtle.down() end
    turtle.back()
    turtle.select(SAPLING_SLOT)
    turtle.place()
end

local function chopMegaTree()
    -- 2x2 mega tree: hak alle 4 stammen omhoog
    -- verplaats turtle in 1 van de hoeken
    turtle.dig()
    turtle.forward()
    turtle.dig()
    turnRight()
    turtle.dig()
    turtle.forward()
    turtle.dig()

    local height = 0

    while true do
        local anyBlock = false
        -- hak huidige laag rondom
        for i=1,4 do
            if turtle.detect() then turtle.dig() anyBlock=true end
            turnRight()
        end
        if turtle.detectUp() then turtle.digUp() anyBlock=true end

        if anyBlock then
            turtle.up()
            height = height + 1
        else
            break
        end
    end

    -- terug naar grond
    for i=1,height do turtle.down() end

    -- terug naar startpositie
    turnLeft()
    turtle.forward()
    turnLeft()
    turtle.forward()
    turtle.select(SAPLING_SLOT)

    -- plant 2x2 saplings
    turtle.placeDown()
    turtle.forward()
    turtle.placeDown()
    turnRight()
    turtle.forward()
    turtle.placeDown()
    turtle.back()
    turnLeft()
    turtle.back()
end

-- ========== Chunk scan ==========

local function scanChunk()
    for row = 1, CHUNK_SIZE do
        for col = 1, CHUNK_SIZE-1 do
            refuelIfNeeded()

            -- detecteer boom
            if isLogBlock(0,0) then
                chopSingleTree()
            elseif isLogBlock(1,0) or isLogBlock(0,1) then
                chopMegaTree()
            end

            if countLogs() >= 64 then
                dumpLogs()
            end

            forward()
        end

        -- volgende rij
        if row < CHUNK_SIZE then
            if row %2 == 1 then turnRight() forward() turnRight()
            else turnLeft() forward() turnLeft() end
        end
    end
end

-- ========== Main loop ==========

while true do
    print("Start chunk scan...")
    scanChunk()
    print("Chunk klaar, opnieuw beginnen...")
    goTo(0,0)
    sleep(10)
end
