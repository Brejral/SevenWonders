-- Card Class
Card = class()

function Card:init(params)
    -- you can accept and set parameters here
    params = params or {}
    self.name = params.name or ""
    self.ctype = params.ctype or "def"
    self.cost = params.cost or {}
    self.freeBuildings = params.freeBuildings or {}
    self.resources = params.resources or {}
    self.rnum = params.rnum or 0
    self.effect = params.effect or {}
    -- self.scitype = params.scitype or ""
    -- self.shields = params.shields or 0
    self.shields = 0
    -- self.victoryPoints = params.vp or 0
    self.victoryPoints = 0
    self.addCoins = 0
    self.image = self:createImage()
    self.addCoins = 0
    
    return self
end

function Card:getResCost()
    local resCost = {}
    for k,v in pairs(self.cost) do
        if v ~= "Coin" then
            table.insert(resCost, v)
        end
    end
    return resCost
end

function Card:coinCost()
    local coinCost = 0
    for k,v in pairs(self.cost) do
        if v == "Coin" then
            coinCost = coinCost + 1
        end
    end
    return coinCost
end

-- move to util or a common draw class
function Card.drawResourceImage(name, x, y)
    spriteMode(CENTER)
    if name == "Wood" then
        sprite("Project:Wood 40", x, y)
    elseif name == "Stone" then
        sprite("Project:Stone 40", x, y)
    elseif name == "Clay" then
        sprite("Project:Clay 40", x, y)
    elseif name == "Ore" then
        sprite("Project:Ore 40", x, y)
    elseif name == "Loom" then
        sprite("Project:Loom 40", x, y)
    elseif name == "Glass" then
        sprite("Project:Glass 40", x, y)
    elseif name == "Papyrus" then
        sprite("Project:Papyrus 40", x, y)
    else
        sprite("Cargo Bot:Condition None", x, y)
    end
end

-- move to util or a common draw class
function Card.drawCostImage(cost, x, y)
    spriteMode(CENTER)
    if cost == "Ore" then
        sprite("Project:Cost Ore", x, y)
    elseif cost == "Wood" then
        sprite("Project:Cost Wood", x, y)
    elseif cost == "Stone" then
        sprite("Project:Cost Stone", x, y)
    elseif cost == "Clay" then
        sprite("Project:Cost Clay", x, y)
    elseif cost == "Loom" then
        sprite("Project:Cost Loom", x, y)
    elseif cost == "Glass" then
        sprite("Project:Cost Glass", x, y)
    elseif cost == "Papyrus" then
        sprite("Project:Cost Papyrus", x, y)
    elseif cost == "Coin" then
        sprite("Project:Coins 1 OL", x, y)
    end
end

function Card:drawEffect()
    local y = 25

    -- resources
    if self.rnum == 1 then
        -- if #self.resources == 2 then    -- choose one of two resources
            -- self.drawResourceImage(self.resources[1], 72, y)
            -- sprite("Project:Resource Separator", 97, y)
        -- self.drawResourceImage(self.resources[2], 122, y)
    -- else
    -- "ClayOre", "StoneWood", "WoodOre", "WoodClay", 
        if self.resources[1] == "ClayOre" then
            sprite("Project:Resource Separator", 97, y)
            self.drawResourceImage("Clay", 72, y)
            self.drawResourceImage("Ore", 122, y)
        elseif self.resources[1] == "StoneWood" then
            sprite("Project:Resource Separator", 97, y)
            self.drawResourceImage("Stone", 72, y)
            self.drawResourceImage("Wood", 122, y)
        elseif self.resources[1] == "WoodOre" then
            sprite("Project:Resource Separator", 97, y)
            self.drawResourceImage("Wood", 72, y)
            self.drawResourceImage("Ore", 122, y)
        elseif self.resources[1] == "WoodClay" then
            sprite("Project:Resource Separator", 97, y)
            self.drawResourceImage("Wood", 72, y)
            self.drawResourceImage("Clay", 122, y)
        else
            self.drawResourceImage(self.resources[1], 122, y)
        end
    elseif self.rnum == 2 then
            self.drawResourceImage(self.resources[1], 72, y)
            self.drawResourceImage(self.resources[2], 122, y) 
    end
    
    -- draw symbols based the effect
    --[[
    table.insert(cardArray, {name="East Trading Post", ctype="Com", age=1, effect={"BuyRaw1Right"}, cost={}})
    table.insert(cardArray, {name="West Trading Post", ctype="Com", age=1, effect={"BuyRaw1Left"}, cost={}})
    table.insert(cardArray, {name="Marketplace", ctype="Com", age=1, effect={"BuyMan1"}, cost={}})
    table.insert(cardArray, {name="Forum", ctype="Com", age=2, effect={"ManResource"}, cost={"Clay", "Clay"}})
    table.insert(cardArray, {name="Caravansery", ctype="Com", age=2, effect={"RawResource"}, cost={"Wood", "Wood"}})
    table.insert(cardArray, {name="Vineyard", ctype="Com", age=2, effect={"RawCoins1"}, cost={}})
    table.insert(cardArray, {name="Haven", ctype="Com", age=3, effect={"RawCoinsVp"}, cost={"Loom", "Ore", "Wood"}})
    table.insert(cardArray, {name="Lighthouse", ctype="Com", age=3, effect={"SciCoinsVp"}, cost={"Glass", "Stone"}})
    table.insert(cardArray, {name="Arena", ctype="Com", age=3, effect={"WonderCoinsVp"}, cost={"Ore", "Stone", "Stone"}})
      ]]

    local effect, count = Util.getEffect(self.effect[1])
    print(self.name.." card effect "..listItems(self.effect).." "..effect.." "..count)
    
    -- science symbols
    dy = y
    if effect == "Compass" then
        sprite("Project:Compass OL", 122, dy)
    elseif effect == "Gear" then
        sprite("Project:Gear OL", 122, dy)
    elseif effect == "Tablet" then
        sprite("Project:Tablet OL", 122, dy)

    -- special sybmbols
    elseif effect=="BuyRaw1Right" then
        sprite("Project:Raw Cost1 Right", 105, dy-5)
    elseif effect=="BuyRaw1Left" then
        sprite("Project:Raw Cost1 Left", 105, dy-5)
    elseif effect=="BuyMan1" then
        sprite("Project:Gray Cost 1", 105, dy-5)
    elseif effect=="ManResource" then
        sprite("Project:Player Self", 105, dy+5)
    elseif effect=="RawResource" then
        sprite("Project:Raw Choice", 105, dy+5)
    elseif effect=="RawCoins1" then
        sprite("Project:Raw Coins", 122, dy)
    elseif effect=="RawCoinsVp" then
        sprite("Project:Raw Coins 1 Vp 1", 122, dy)
    elseif effect=="SciCoinsVp" then
         sprite("Project:Yellow Coins 1 Vp 1", 122, dy)
    elseif effect=="WonderCoinsVp" then
         sprite("Project:Stages Coins3 Vp1", 122, dy)               
    elseif effect=="Coins" then
        self.addCoins = count
    elseif effect=="vp" then
        self.victoryPoints = count
    elseif effect=="shields" then
        self.shields = count
    end

    -- victory points
    if self.victoryPoints > 0 then
        sprite("Project:VP OL", 120, y)
        font("Futura-CondensedExtraBold")
        if self.ctype == "Com" then     -- commercial structures (yellow)
            fill(0)
        else
            fill(255)
        end
        fontSize(24)
        textMode(CENTER)
        text(self.victoryPoints, 120, y)
    end
    
    -- shields
    local dy = y + 8
    if self.shields > 0 then
        sprite("Project:Shield", 133, dy)
    end
    if self.shields > 1 then
        sprite("Project:Shield", 115, dy)
    end
    if self.shields > 2 then
        sprite("Project:Shield", 102, dy)
    end
    
end

function Card:createImage()
    local w = 146
    local h = 50
    local tsize = 12
    local img = image(w, h)
    
    -- begin local image drawing
    setContext(img)
    
    -- draw background rectangle
    if self.ctype == "Man" then         -- manufactured resources (gray)
        fill(128)
    elseif self.ctype == "Civ" then     -- civilian structures (blue)
        fill(0, 2, 255, 255)
    elseif self.ctype == "Com" then     -- commercial structures (yellow)
        fill(255, 203, 0, 255)
    elseif self.ctype == "Mil" then     -- military structures (red)
        fill(182, 20, 36, 255)
    elseif self.ctype == "Sci" then     -- science structures (green)
        fill(26, 151, 32, 255)
    elseif self.ctype == "Guild" then   -- guilds (purple)
        fill(198, 12, 229, 255)
    else                                -- raw resources (brown)
        fill(192, 128, 88, 255)
    end
    strokeWidth(2)
    stroke(0)
    rectMode(CORNER)
    rect(0, 0, w, h)
    
    -- draw text in upper left hand corner
    font("ArialRoundedMTBold")
    if self.ctype == "Com" then     -- commercial structures (yellow)
        fill(0)
    else
        fill(255)
    end
    fontSize(tsize)
    textMode(CORNER)
    text(self.name, 2, h-tsize-2)
    
    -- draw cost
    local xs = 12
    for i,v in pairs(self.cost) do
        Card.drawCostImage(v, xs, 12)
        xs = xs + 24
    end
    
    -- draw effect
    self:drawEffect()
    
    -- end local image drawing
    setContext()
    
    return img
end

function Card:draw()
    -- Codea does not automatically call this method
end

function Card:touched(touch)
    -- Codea does not automatically call this method
end

function Card:info()
    -- print(self.name .. " coin cost " .. self.coinCost .. ...)
    return self.name .. " coin cost " .. self.coinCost
end
