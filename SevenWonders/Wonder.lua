Wonder = class()

function Wonder:init(params)
    -- you can accept and set parameters here
    -- table.insert(boardArray, {name=wonders[1], side="A", resource="Ore", stages={{cost={"Wood", "Wood"}, effect="vp:3"}, {cost={"Clay", "Clay", "Clay"}, effect="shields:2"}, {cost={"Ore", "Ore", "Ore", "Ore"}, effect="vp:7"}}})

    self.name = params.name
    self.side = params.side
    self.resource = params.resource
    self.stages = params.stages
    self.stageImages = {}
    for i,stage in pairs(self.stages) do
        local img = self:createStageImage(stage)
        -- local img = self:createStageImage(self.stages[1])
        table.insert(self.stageImages, img)
    end
    self.image = self:createImage()
    
    return self
end

function Wonder:drawEffectImage(eff, x, y)
    local effect,count = Util.getEffect(eff)
    
    if effect=="coins" then
        -- self.addCoins = count
    elseif effect=="vp" then
        sprite("Project:VP OL", x, y)
        font("Futura-CondensedExtraBold")
        fill(255)
        fontSize(24)
        textMode(CENTER)
        text(count, x, y)
    elseif effect=="shields" then
        -- self.shields = count
        local dy = y
        if count > 0 then
            sprite("Project:Shield 42", x, dy)
        end
        if count > 1 then
            sprite("Project:Shield 42", x-52, dy)
        end
        if count > 2 then
            sprite("Project:Shield 42", x-104, dy)
        end
    end
end

function Wonder:createStageImage(stage)
    local w = 320
    local h = 50
    local tsize = 12
    local img = image(w, h)
    
    -- begin local image drawing
    setContext(img)

    -- noFill()
    fill(143, 135, 141, 130)
    strokeWidth(4)
    stroke(31, 104, 33, 115)
    rectMode(CORNER)
    rect(0, 0, w, h)
    
    -- draw cost
    local cy = 15
    local cx = cy
    for i,cost in pairs(stage.cost) do
        Card.drawCostImage(cost, cx, cy)
        cx = cx + 24
    end
    
    -- draw effect
    local ey = 24
    local ex = w - ey
    for i,effect in pairs(stage.effect) do
        Wonder:drawEffectImage(effect, ex, ey)
        ex = ex + 48
    end
    
    -- self:drawEffect()
    
    -- end local image drawing
    setContext()
    
    return img
end

function Wonder:createImage()
    local w = 340
    local h = 260
    local tsize = 12
    local img = image(w, h)
    
    -- begin local image drawing
    setContext(img)

    -- fill(255, 0, 202, 255)
    noFill()
    strokeWidth(4)
    stroke(0)
    rectMode(CORNER)
    -- rect(0, 0, w, h)
    
    -- draw board name in lower center
    font("ArialRoundedMTBold")
    fill(221, 197, 90, 255)
    fontSize(tsize)
    textMode(CENTER)
    text(self.name, w/2, tsize+2)

    -- draw wonder stages
    local stageX = w/2
    local stageY = 50
    for i,stageImage in pairs(self.stageImages) do
        sprite(stageImage, stageX, stageY)
        stageY = stageY + 60 
    end

    -- end local image drawing
    setContext()
    
    return img
end

function Wonder:draw()
    -- Codea does not automatically call this method
end

function Wonder:touched(touch)
    -- Codea does not automatically call this method
end
