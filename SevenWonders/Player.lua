-- Player Class
Player = class()

function Player:init(params)
    -- you can accept and set parameters here
    self.name = params.name or "Player"
    self.coins = 3
    -- "Wood", "Stone", "Ore", "Clay", 
    -- "ClayOre", "StoneWood", "WoodOre", "WoodClay", 
    -- "Loom", "Glass", "Papyrus"
    self.resources = {}     -- brown and gray
    self.buildings = {}
    self.board = params.board or "Giza"
    self.hand = {}
    self.pick = 0
    self.action = ""    -- "Build Structure" or "Build Wonder" or "GainCoins"
    self.resNeeded = {}
    self.wonder = nil
    self.shields = 0
    
    self.militaryPoints = {left = {}, right = {}}
    self.treasuryPoints = 0
    self.wonderPoints = 0
    self.civilianPoints = 0
    self.commercialPoints = 0
    self.guildPoints = 0
    self.scienceTypes = {Gear=0,Compass=0,Tablet=0}
    self.victoryPoints = 0
    self.effects = {}

    -- not using these values
    self.resCount = {Wood=0, Stone=0, Ore=0, Clay=0, ClayOre=0, StoneWood=0, WoodOre=0, WoodClay=0, Loom=0, Glass=0, Papyrus=0}      -- brown
    -- self.mans = {}      -- gray
    self.guilds = {}    -- purple
    self.civs = {}      -- blue
    self.mils = {}      -- red
    self.scis = {}      -- green
    self.coms = {}      -- yellow
end

function Player:printInfo(left, right)
    print("---------------------------")
    print(self.name.." coins "..self.coins)
    print("  resources ")
    if #self.resources > 0 then
        for i,res in pairs(self.resources) do
            print("  "..res)
        end
    end
    -- if #self.resNeeded > 0 then
    -- print("  needed ")
    -- Util.printTable(self.resNeeded)
    -- print("picked "..self.pick.." "..self.hand[self.pick].name)
    -- Util.printTable(self.hand[self.pick].cost)
-- end
    if self.pick > 0 then
        print("picked "..self.pick.." "..self.hand[self.pick].name.." cost "..listItems(self.hand[self.pick].cost))
        -- Util.printTable(self.hand[self.pick].cost)
        local resNeeded  = self:getResNeeded(self.hand[self.pick].cost)
        print("resources Needed "..listItems(resNeeded))
        -- Util.printTable(resNeeded)
        print("  self have Res needed "..tostring(self:hasResources(resNeeded)))
        print("  left "..left.name.." has Res needed "..tostring(left:hasResources(resNeeded)))
        print("  right "..right.name.." has Res needed "..tostring(right:hasResources(resNeeded)))
    end
    
    print()
end

function Player:setLeftPlayer(player)
    self.leftPlayer = player
end

function Player:getLeftPlayer()
    return self.leftPlayer
end

function Player:setRightPlayer(player)
    self.rightPlayer = player
end

function Player:getRightPlayer()
    return self.rightPlayer
end

function Player:setWonder(wonder)
    self.wonder = wonder
    table.insert(self.resources, wonder.resource)
end

function Player:addToHand(card)
    table.insert(self.hand, card)
end

function Player.sortResources(a, b)
    if string.len(a) < string.len(b) then
        return true
    end
    
    return false
end

function Player:buildWonderStage(card)
    table.insert(self.wonder.stages["built"], card)
end

function Player:addCoins(num)
    self.coins = self.coins + num
end

function Player:addCivilianPoints(num)
    self.civilianPoints = self.civilianPoints + num
end

function Player:addGuildPoints(num)
    self.guildPoints = self.guildPoints + num
end

function Player:getGuildPoints()
    return 0
end

function Player:addCommercialPoints(num)
    self.commercialPoints = self.commercialPoints + num
end

function Player:getCommercialPoints()
    return self.commercialPoints
end

function Player:addScienceType(key)
    self.scienceTypes[key] = self.scienceTypes[key] + 1
end

function Player:getSciencePoints()
    local gearNum = self.scienceTypes["Gear"]
    local compassNum = self.scienceTypes["Compass"]
    local tabletNum = self.scienceTypes["Tablet"]
    local numSets = math.min(gearNum, math.min(compassNum, tabletNum))
    local sciencePoints = (gearNum * gearNum) + (compassNum * compassNum) + (tabletNum * tabletNum) + (numSets * 7)
    return sciencePoints
end

function Player:getVictoryPoints()
    local victoryPoints = 
        self.treasuryPoints +
        self.wonderPoints +
        self.civilianPoints +
        self:getCommercialPoints() +
        self:getGuildPoints() +
        self:getSciencePoints() +
        self:getMilitaryPoints()

    return victoryPoints
end

function Player:addShields(num)
    self.shields = self.shields + num
end

function Player:getShields()
    return self.shields
end

function Player:addMilitaryPoints(key, points)
    table.insert(self.militaryPoints[key], points)
end

function Player:getMilitaryPoints()
    local mp = 0
    myDebug("getMiltaryPoints()")
    for k,v in pairs(self.militaryPoints) do
        myDebug("  key "..k.." "..listItems(v))
        for i,pts in pairs(v) do
            mp = mp + pts
        end
    end
    myDebug("  total points "..mp)
    return mp
end

function Player:haveEffect(eff)
    for i,effect in pairs(self.effects) do
        if eff == effect then
            return true
        end
    end
    return false
end

function Player:addEffect(effect)
    print(self.name.." added effect "..effect)
    table.insert(self.effects, effect)
    if effect=="RawCoinsVp" then
        self.addCoins(Player:getCardTypeCount("Raw"))
    elseif effect=="ManCoinsVp" then
        self.addCoins(Player:getCardTypeCount("Man")*2)
    elseif effect=="SciCoinsVp" then
        self.addCoins(Player:getCardTypeCount("Sci")*2)
    elseif effect=="WonderCoinsVp" then
        self.addCoins(Player:getWonderStagesCount()*3)
    end
end

--[[
    -- guilds
    table.insert(cardArray, {name="Workers Guild", ctype="Guild", age=3, effect={"WorkersGuild"}, cost={"Ore", "Ore", "Clay", "Stone", "Wood"}})
    table.insert(cardArray, {name="Craftsmens Guild", ctype="Guild", age=3, effect={"CraftsmensGuild"}, cost={"Ore", "Ore", "Stone", "Stone"}})
    table.insert(cardArray, {name="Traders Guild", ctype="Guild", age=3, effect={"TradersGuild"}, cost={"Loom", "Papyrus", "Glass"}})
    table.insert(cardArray, {name="Philosophers Guild", ctype="Guild", age=3, effect={"PhilosophersGuild"}, cost={"Clay", "Clay", "Clay", "Loom", "Papyrus"}})
    table.insert(cardArray, {name="Spies Guild", ctype="Guild", age=3, effect={"SpiesGuild"}, cost={"Clay", "Clay", "Clay", "Glass"}})
    table.insert(cardArray, {name="Strategists Guild", ctype="Guild", age=3, effect={"StrategistsGuild"}, cost={"Ore", "Ore", "Stone", "Loom"}})
    table.insert(cardArray, {name="Shipowners Guild", ctype="Guild", age=3, effect={"ShipownersGuild"}, cost={"Wood", "Wood", "Wood", "Papyrus", "Glass"}})
    table.insert(cardArray, {name="Scientists Guild", ctype="Guild", age=3, effect={"ScientistsGuild"}, cost={"Wood", "Wood", "Ore", "Ore", "Papyrus"}})
    table.insert(cardArray, {name="Magistrates Guild", ctype="Guild", age=3, effect={"MagistratesGuild"}, cost={"Wood", "Wood", "Wood", "Stone", "Loom"}})
    table.insert(cardArray, {name="Builders Guild", ctype="Guild", age=3, effect={"BuildersGuild"}, cost={"Stone", "Stone", "Clay", "Clay", "Glass"}})
  ]]

function Player:addBuilding(card)
    print(self.name.." building "..card.name.." "..card.ctype)
    self.coins = self.coins - card:coinCost()
    for k,v in pairs(card.resources) do
        table.insert(self.resources, v)
        self.resCount[v] = self.resCount[v] + 1
        -- print(card.name.." "..v.." "..self.resCount[v])
    end
    -- print(self.name.." resources before sort...")
    -- Util.printTable(self.resources)
    table.sort(self.resources, Player.sortResources)
    -- print(self.name.." resources after sort...")
    -- Util.printTable(self.resources)
    table.insert(self.buildings, card)
    
    -- do cards effect
    for i,effect in pairs(card.effect) do
        local effect,count = Util.getEffect(effect)
        
        if effect=="coins" then
            self:addCoins(count)
        elseif effect=="vp" and card.ctype == "Civ" then
            print(" add Civ Points "..count)
            self:addCivilianPoints(count)
        elseif effect=="shields" then
            self:addShields(count)
        elseif card.ctype == "Sci" then
            print(" add Sci Type "..effect)
            self:addScienceType(effect)
        elseif card.ctype == "Guild" then
            print(" add Guild Type "..effect)
        -- elseif card.ctype == "Com" then
            -- print(" add Com Type "..effect)
        elseif effect == "RawCoins1" then
            local leftPlayer = self:getLeftPlayer()
            local rightPlayer = self:getRightPlayer()
            self.addCoins(self:getCardTypeCount("Raw"))
            self.addCoins(leftPlayer:getCardTypeCount("Raw"))
            self.addCoins(rightPlayer:getCardTypeCount("Raw"))
            
        else
            self:addEffect(effect)
        end
    end
end

function Player:getHand()
    return self.hand
end

function Player:setPick(pick)
    if pick <= #self.hand then
        self.pick = pick
    else
        self.pick = 0
    end
end

function Player:getPick()
    return self.pick
end

-- actionChoices = 
-- None="Cannot Build", 
-- BuildStructue="Build Structure", 
-- PayLeft="Pay Left, Build", 
-- PayRight="Pay Left, Build", 
-- BuildWonder="Build Wonder", 
-- GainCoins="Gain Coins"

function Player:getAction()
    return self.action
end

function Player:setAction(action)
    print(self.name.." action "..action)
    self.action = action
end

function Player:isFreeBuilding(card)
    return false
end

function Player:hasResources(checkList)
    -- make copy of players resoources
    local res = copy(self.resources)
    myDebug(self.name.." has "..listItems(res))
    myDebug(" looking for "..listItems(checkList))
    -- compare all specified resources 
    for i,v in pairs(checkList) do
        -- check if player has the resource
        if not Util.removeMatchingResource(res, v) then
            -- player does not have a needed item
            myDebug("  did not find "..v.." return false")
            return false
        end
    end
    myDebug(self.name.." has all the items!")
    return true
end

-- input is list of resources needed to build
-- output is list of resources not owned by player
function Player:getResNeeded(resCost)
    local resNeeded = copy(resCost)
    local resources = copy(self.resources)
    myDebug("Get needs for "..self.name.." has "..listItems(resources))
    myDebug("  cost "..listItems(resCost))
    -- print(self.name.." getResNeeded()")
    for i,v in pairs(resCost) do
        myDebug("checking need "..v.." in "..listItems(resources))
        if Util.removeMatchingResource(resources, v) then
            myDebug("remove "..v.." from needs")
            removeItem(resNeeded, v)
        end
    end
    myDebug(self.name.." needs "..listItems(resNeeded))
    return resNeeded
end

function Player:getBuildStructureAction(pick)
    -- returns "BuildStructure" or "PayLeft" or "PayRight" or "None"
    local card = self.hand[pick]
    
    -- reset the needed resources
    self.resNeeded = {}

    if self:isFreeBuilding(card) then
        return "BuildStructure"
    end
    
    -- print(card.name.." Coin Cost "..card:coinCost())
    if card:coinCost() > 0 then
        if card:coinCost() > self.coins then
            return "None"
        else
            return "BuildStructure"
        end
    end
    
    local resCost = card:getResCost()
    -- print(card.name.." Resource Cost "..#resCost)
    if #resCost > 0 then
        myDebug("---------------------------")
       if self:hasResources(resCost) then
            return "BuildStructure"
        end
        
        -- create list of only resources needed
        self.resNeeded = self:getResNeeded(resCost)
        -- print(self.name.."  needs "..listItems(self.resNeeded))

        -- check if player on left has resources
        local leftPlayer = self:getLeftPlayer()
        -- print("  left "..player.name.." has Resource needed "..tostring(player:hasResources(self.resNeeded)))
        
        if leftPlayer:hasResources(self.resNeeded) then
            if self.coins >= (#self.resNeeded*2) then
                return "PayLeft"
            end
        end

        -- check if player on right has resources
        local rightPlayer = self:getRightPlayer()
        -- print("  right "..player.name.." has Resource needed "..tostring(player:hasResources(self.resNeeded)))
        if rightPlayer:hasResources(self.resNeeded) then
            if self.coins >= (#self.resNeeded*2) then
                return "PayRight"
            end
        end
        
        return "None"
    end
    
    -- no coin or resource cost so it must be free
    return "BuildStructure"
end

function Player:payPlayer(payee)
    local cost = #self.resNeeded*2
    print(self.name.." paid "..payee.name.." "..cost.." coins")
    self.coins = self.coins - cost
    payee:addCoins(cost)
    self.resNeeded = {}
end

function Player.getRawCount(tab)
    local count = 0
    for i,resource in pairs(tab) do
        if Util.isResourceRaw(resource) then
            count = count + 1 
        end
    end
    return count
end

function Player.getManCount(tab)
    local count = 0
    for i,resource in pairs(tab) do
        if Util.isResourceMan(resource) then
            count = count + 1 
        end
    end
    return count
end

function Player:getCardTypeCount(ctype)
    local count = 0
    for i,card in pairs(self.buildings) do
        if card.ctype == ctype then
            count = count + 1 
        end
    end
    return count
end

function Player:getWonderStagesCount()
    return #self.wonder.stages["Built"]
end

function Player:owes()
    local rawNumL = 0
    local rawNumR = 0
    local manNum = 0
    local resNum = #self.resNeeded

    print("res needed "..listItems(self.resNeeded))
    if self:haveEffect("BuyRaw1Left") or self:haveEffect("BuyRaw1Right") then 
        print("have BuyRaw1 effect")
        rawNumL = Player.getRawCount(self.resNeeded)
        resNum = resNum - rawNumL
    end

    --[[
    if self:haveEffect("BuyRaw1Left") then 
        rawNumL = Player.getRawCount(self.resNeeded["left"])
        resNum = resNum - rawNumL
    end

    if self:haveEffect("BuyRaw1Right") then 
        rawNumR = Player.getRawCount(self.resNeeded["right"])
        resNum = resNum - rawNumR
    end
      ]]

    if self:haveEffect("BuyMan1") then 
        print("have BuyMan1 effect")
        manNum = Player.getManCount(self.resNeeded)
        resNum = resNum - manNum
    end

    print(self.name.." owes ("..resNum.." * 2) + "..rawNumL.." + "..manNum.." = "..((resNum * 2) + rawNumL + rawNumR + manNum))
    return (resNum * 2) + rawNumL + rawNumR + manNum
end

function Player:createImageTemplate()
    local w = 20            -- local image width
    local h = 20            -- local image height
    local tsize = 12        -- local image text size
    local img = image(w, h) -- create local image
    
    -- begin local image drawing
    setContext(img)
    
    -- end local image drawing
    setContext()
    
    return img
end

function Player:drawImage(offX, bgTint)
    local w = 341           -- local image width
    local h = HEIGHT - 120  -- local image height
    local tsize = 24        -- local image text size
    local centerX = offX + (w / 2)
    local nameX =  centerX
    local nameY =  h - 30
    local coinX =  offX + 30
    local coinY = nameY
    local resX = coinX + 60
    local resY = nameY
    local vpX = offX + w - 30
    local vpY = nameY
    local milX = vpX - 60
    local milY = nameY
    local colX1 = offX + (w / 4)
    local colX2 = centerX + (w / 4)
    local colY = nameY - 60
    local wonX = centerX
    local wonY = (260 / 2) + 10
    
    -- draw shaded background in name area
    -- if not bgTint then
        fill(127, 127, 127, 150)
        noStroke()
        -- stroke(0)
        rectMode(CORNER)
        rect(offX + 0, h-60, w, 60)
    -- end

    -- draw player name
    font("ArialRoundedMTBold")
    fill(255)
    fontSize(tsize)
    textMode(CENTER)
    text(self.name, nameX, nameY)
    
    -- draw players coins
    sprite("Project:Coin Token BG", coinX, coinY)
    text(self.coins, coinX, coinY)
    
    -- draw wonder resource 
    Card.drawResourceImage(self.wonder.resource, resX, resY)

    -- draw players miltary points
    sprite("Project:Military Token Retina", milX, milY)
    text(self:getMilitaryPoints(), milX, milY)
    
    -- draw victory points
    sprite("Project:VP OL", vpX, vpY)
    text(self:getVictoryPoints(), vpX, vpY)

    -- draw players buildings
    x = colX1
    y = colY
    for k,v in pairs(self.buildings) do
        sprite(v.image, x, y)
        if k == 8 then 
            x = colX2
            y = colY
        else
            y = y - 55
        end
    end
    
    -- draw wonder stages
    sprite(self.wonder.image, wonX, wonY)

    if bgTint then
        fill(212, 212, 212, 75)
        noStroke()
        -- stroke(0)
        rectMode(CORNER)
        rect(offX + 0, 0, w, h)
    end
end

function Player:draw()
    -- Codea does not automatically call this method
end

function Player:touched(touch)
    -- Codea does not automatically call this method
end
