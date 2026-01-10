-- spruce_autofarm.lua
-- CC:Tweaked, Minecraft 1.21
-- Automatisch hakken van 1x1 en 2x2 spruce mega trees
-- Houdt rekening met hoogteverschillen
-- Dump logs in chest, plant saplings terug

local FUEL_SLOT = 1
local SAPLING_SLOT = 2
local LOG_NAME = "minecraft:spruce_log"
local LEAF_NAMES = {["minecraft:spruce_leaves"]=true}
local CHUNK_SIZE = 16

-- Positie tracking
local x, z = 0, 0
local y = 0 -- hoogte
local dir = 0 -- 0=N,1=E,2=S,3=W

-- ========== Basis beweging ==========

local function turnRight()
    turtle.turnRight()
    dir = (dir+1)%4
end

local function turnLeft()
    turtle.turnLeft()
    dir = (dir+3)%4
end

local function forward()
    while not turtle.forward() do
        if turtle.detect() then turtle.dig()
        elseif turtle.detectUp() then turtle.digUp()
        elseif turtle.detectDown() then turtle.digDown() end
        sleep(0.2)
    end
    if dir == 0 then z = z-1
    elseif dir==1 then x = x+1
    elseif dir==2 then z=z+1
    elseif dir==3 then x=x-1 end
end

local function up()
    while not turtle.up() do
        turtle.digUp()
        sleep(0.2)
    end
    y = y + 1
end

local function down()
    while not turtle.down() do
        turtle.digDown()
        sleep(0.2)
    end
    y = y - 1
end

local function goTo(tx,tz,ty)
    -- Beweeg horizontaal eerst
    while x<tx do while dir~=1 do turnRight() end forward() end
    while x>tx do while dir~=3 do turnRight() end forward() end
    while z<tz do while dir~=2 do turnRight() end forward() end
    while z>tz do while dir~=0 do turnRight() end forward() end
    -- Beweeg verticaal
    while y<ty do up() end
    while y>ty do down() end
end

-- ========== Inventaris ==========

local function countLogs()
    local count=0
    for i=1,16 do
        local d = turtle.getItemDetail(i)
        if d and d.name==LOG_NAME then count = count+d.count end
    end
    return count
end

local function refuelIfNeeded()
    if turtle.getFuelLevel()<500 then
        turtle.select(FUEL_SLOT)
        turtle.refuel(1)
    end
end

-- Dump logs in chest achter turtle
local function dumpLogs()
    print("Dump logs...")
    local cx,cz,cy,cdir = x,z,y,dir
    goTo(0,0,0)
    turnLeft() turnLeft()
    for i=3,16 do
        turtle.select(i)
        turtle.drop()
    end
    turnLeft() turnLeft()
    goTo(cx,cz,cy)
    while dir~=cdir do turnRight() end
end

-- ========== Boom detectie ==========

local function isLog()
    local success,data = turtle.inspect()
    if success and data.name==LOG_NAME then return true end
    return false
end

local function isLeaf()
    local success,data = turtle.inspect()
    if success and LEAF_NAMES[data.name] then return true end
    return false
end

-- ========== Boom hakken ==========

-- Hak een 1x1 of 2x2 boom inclusief bladeren
local function chopTree()
    local visited = {}
    local stack = {{0,0,0}}
    local startX,startY,startZ = x,y,z

    while #stack>0 do
        local node = table.remove(stack)
        local nx,ny,nz = node[1],node[2],node[3]
        local key = nx..","..ny..","..nz
        if not visited[key] then
            visited[key]=true

            -- Ga naar blok
            local tx,ty,tz = startX+nx,startY+ny,startZ+nz
            goTo(tx,tz,ty)

            -- Hak hout
            if isLog() then turtle.dig() end
            -- Hak bladeren
            if isLeaf() then turtle.dig() end

            -- Check omliggende blokken
            local dirs={{1,0,0},{-1,0,0},{0,1,0},{0,-1,0},{0,0,1},{0,0,-1}}
            for _,d in ipairs(dirs) do
                local dx,dy,dz = d[1],d[2],d[3]
                table.insert(stack,{nx+dx,ny+dy,nz+dz})
            end
        end
    end

    -- Ga terug naar startblok
    goTo(startX,startZ,startY)

    -- Plant sapling (2x2 check kan later uitgebreid worden)
    turtle.select(SAPLING_SLOT)
    turtle.place()
end

-- ========== Chunk scan ==========

local function scanChunk()
    for row=1,CHUNK_SIZE do
        for col=1,CHUNK_SIZE do
            refuelIfNeeded()
            if isLog() then chopTree() end
            if countLogs()>=64 then dumpLogs() end
            forward()
        end
        if row<CHUNK_SIZE then
            if row%2==1 then turnRight() forward() turnRight()
            else turnLeft() forward() turnLeft() end
        end
    end
end

-- ========== Main loop ==========

while true do
    print("Start chunk scan...")
    scanChunk()
    print("Chunk klaar, terug naar start...")
    goTo(0,0,0)
    sleep(10)
end
