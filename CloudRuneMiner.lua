print("Run Runite Miner")
local API = require("api")
local UTILS = require("utils")

local afk = os.time()
local startTime = os.time()
local idleTimeThreshold = math.random(120, 260)
local MAX_IDLE_TIME_MINUTES = 8 -- CHANGE TO (5) IF NOT ON JAGEX ACC
local timerDuration = 60  -- Timer duration in seconds
local lastActionTime = os.time()
local minIdleTime = 60  -- You can adjust this value based on your preference
local maxIdleTime = 480 

skill = "MINING"
startXp = API.GetSkillXP(skill)
local strings, fail = 0, 0

local Geode = 0  -- Initialize the geodes variable to 0
local Ore = 0  -- Initialize Ores to 0
local Trip = 0 -- Initialize Trips to 0


ID = {
    rune = 451,
    geode = 44816,
    orebox = 44789
}


Orebox = { 
    bronze = 44779,
    steel = 44783,
    iron = 44781,
    mithril = 44785,
    addy = 44787,
    rune = 44789

 }


local function round(val, decimal)
    if decimal then
        return math.floor((val * 10 ^ decimal) + 0.5) / (10 ^ decimal)
    else
        return math.floor(val + 0.5)
    end
end

function formatNumber(num)
    if num >= 1e6 then
        return string.format("%.1fM", num / 1e6)
    elseif num >= 1e3 then
        return string.format("%.1fK", num / 1e3)
    else
        return tostring(num)
    end
end

-- Format script elapsed time to [hh:mm:ss]
local function formatElapsedTime(startTime)
    local currentTime = os.time()
    local elapsedTime = currentTime - startTime
    local hours = math.floor(elapsedTime / 3600)
    local minutes = math.floor((elapsedTime % 3600) / 60)
    local seconds = elapsedTime % 60
    return string.format("[%02d:%02d:%02d]", hours, minutes, seconds)
end

local function calcProgressPercentage(skill, currentExp)
    local currentLevel = API.XPLevelTable(API.GetSkillXP(skill))
    if currentLevel == 120 then return 100 end
    local nextLevelExp = XPForLevel(currentLevel + 1)
    local currentLevelExp = XPForLevel(currentLevel)
    local progressPercentage = (currentExp - currentLevelExp) / (nextLevelExp - currentLevelExp) * 100
    return math.floor(progressPercentage)
end

local function printProgressReport(final)
    local currentXp = API.GetSkillXP(skill)
    local elapsedMinutes = (os.time() - startTime) / 60
    local diffXp = math.abs(currentXp - startXp);
    local xpPH = round((diffXp * 60) / elapsedMinutes);
    local TripPH = round((Trip * 60) / elapsedMinutes)
    local OrePH = round((Ore * 60) / elapsedMinutes)
    local GeodePH = round((Geode * 60) / elapsedMinutes)
    local time = formatElapsedTime(startTime)
    local currentLevel = API.XPLevelTable(API.GetSkillXP(skill))
    IGP.radius = calcProgressPercentage(skill, API.GetSkillXP(skill)) / 100
    IGP.string_value = time ..
    " | " ..
    string.lower(skill):gsub("^%l", string.upper) ..
    ": " .. currentLevel ..  " | Ore: " .. formatNumber(Ore) .. " | Ore/H: " .. formatNumber(OrePH).. " | Geode: " .. formatNumber(Geode) .. " | Geode/HR: " .. formatNumber(GeodePH)  .. ": "  .. " | XP/H: " .. formatNumber(xpPH) .. " | XP: " .. formatNumber(diffXp) .. " | Trips: " .. formatNumber(Trip) .. " | Trips/H: " .. formatNumber(TripPH)
end

local function setupGUI()
    IGP = API.CreateIG_answer()
    IGP.box_start = FFPOINT.new(10, 10, 0)
    IGP.box_name = "PROGRESSBAR"
    IGP.colour = ImColor.new(78, 91, 150);
    IGP.string_value = "CloudX Runite Miner"
end

local function drawGUI()
    DrawProgressBar(IGP)
end

function banking()
    print("Bank: Updating Ore Count")
    Ore = Ore + API.InvItemcount_1(ID.rune)
    Trip = Trip + API.InvItemcount_1(ID.orebox)
    Geode = Geode + API.InvItemcount_1(ID.geode)
    print("Banking")
    API.DoAction_Object1(0x5, GeneralObject_route1, {11758}, 50)
    print("Banking Click Delay")
    API.RandomSleep2(1000,1000,1000)
    API.WaitUntilMovingEnds()
    print("Yeeting your shit")
    API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 517, 39, -1, GeneralInterface_route)
    API.RandomSleep2(2000, 1500, 3200)
    API.DoAction_Interface(0x24, 0xffffffff, 1, 517, 119, 1, GeneralInterface_route)
    print("Waiting for interface to close")
    API.RandomSleep2(2000, 1500, 3200)
end

function MineMoreOre()
    local Sparkles = API.FindHl(0x3a, 0, {113067, 113066, 113065}, 50, {7165, 7164})
    
    --API.DoAction_Object1(0x3a, 0, {113067, 113066, 113065}, 50)
    API.RandomSleep2(6500, 250, 5000)  -- change first digit to how long you wait it to wait between clicks  EX: 1000 = 1second  2500 = 2.5 sec  6500 = 6.5sec  
        if Sparkles then
            print("SHIMMY SHIMMY BABBYYYYY found")
            API.RandomSleep2(2500, 3050, 12000)
            API.DoAction_Object_r(0x3a, 0, {113067, 113066, 113065}, 10, FFPOINT.new(0, 0, 0), 50)
            printProgressReport()
        else
    print("LOGIC:Mining More Ore")
    API.DoAction_Object1(0x3a, 0, {113067, 113066, 113065}, 50)   
    printProgressReport()
    end
end

function fillorebox()
    print("---Updating Ore Count---")
        Ore = Ore + API.InvItemcount_1(ID.rune)
        Geode = Geode + API.InvStackSize(ID.geode)
        print("Updating UI")
        printProgressReport()
    print("OreBox Found")
    API.DoAction_Interface(0x24,0xaef5,1,1473,5,0,GeneralInterface_route) -- rune orebox
    API.RandomSleep2(650, 250, 250)
end

function WalktoBank()
print ("Clicking Ladder to go Up")
    API.DoAction_Object1(0x34,GeneralObject_route0,{6226},50);
    API.RandomSleep2(1500,1500,1500)
    UTILS.waitForAnimation(0, 20)           
    print('waitForAnimation done')
    API.RandomSleep2(2500,1500,1500)
    API.DoAction_Tile(WPOINT.new( 3015 + API.Math_RandomNumber(2), 3355 + API.Math_RandomNumber(2), 0))
    API.RandomSleep2(1050,1000,1000)
    API.WaitUntilMovingEnds()            
    API.RandomSleep2(1050,1000,1000)
end    

function WalktoOre()
    print ("Clicking Node 1")
    API.DoAction_Tile(WPOINT.new( 3019 + API.Math_RandomNumber(4), 3339 + API.Math_RandomNumber(4), 0))
    API.RandomSleep2(650,1000,1000)
    API.WaitUntilMovingEnds()
    print ("Clicking Ladder to go down")
    API.DoAction_Object1(0x35,GeneralObject_route0,{2113},50)
    API.RandomSleep2(1500,1500,1500)
    UTILS.waitForAnimation(0, 20)   
end

setupGUI()
-- Timer to control UI update interval (1 second)
local uiUpdateTimer = os.time()


-- Function to generate a random idle time
local function getRandomIdleTime()
    return math.random(minIdleTime, maxIdleTime)
end

local function antiIdleTask()
    local currentTime = os.time()
    local elapsedTime = os.difftime(currentTime, startTime)

    if elapsedTime >= idleTimeThreshold then
        API.PIdle2()
        -- Reset the timer and generate a new random idle time
        startTime = os.time()
        idleTimeThreshold = math.random(220, 260)
        ScripCuRunning1 = "Timer interupt"
        print("Reset Timer & Threshhold")
    end
end

-- Main loop
API.Write_LoopyLoop(true)
while (API.Read_LoopyLoop()) do    
    drawGUI()

   -- if API.CheckAnim(10) or API.ReadPlayerMovin2() then
   --     API.RandomSleep2(50, 100, 100)
   --     goto continue
   -- end

    local currentTime = os.time()
    print("Updating UI")
    if currentTime - uiUpdateTimer >= 1 then
        uiUpdateTimer = currentTime
        printProgressReport()
    end

    print("LOGIC:Checking if player is at Mines and if Invy is not full")
    if API.PInArea(3028, 30, 9736, 30)then
        print("LOGIC:Mining More Ore")
        MineMoreOre()
        if API.InvFull_() then
            print("LOGIC:Invy is Full, Filling Orebox")
            fillorebox()
            antiIdleTask()
            if API.InvFull_() then
            print("LOGIC:Invy still full Going to bank")
            WalktoBank()
            banking()
            end       
        end
    end


    print("LOGIC:Checking if player is at bank and if Invy is full")
    if API.PInArea(3017, 20, 3356, 20) and API.InvFull_() then
        print("LOGIC:Bank")
        banking()
        printProgressReport()
    end
        if not API.PInArea(3028, 20, 9736, 20) then 
            print("LOGIC:Walking to Ore")
            WalktoOre()
            printProgressReport()
        end   
   

        ::continue::
        printProgressReport()
        API.RandomSleep2(100, 200, 200)


    -- Main loop sleep interval increased to 1 second
    API.RandomSleep2(1000, 200, 200)
end