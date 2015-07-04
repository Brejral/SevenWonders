-- Game Class
Game = class()

local xstart = 74
-- local picked = 0
local actionWidth = 200
local actionHeight = 50
local actionSpaceX = 20
local actionMaxY = HEIGHT - 60
local actionMinY = actionMaxY - actionHeight
local actionMinX1 = (WIDTH - (actionWidth*3) - (actionSpaceX*2)) / 2
local actionMaxX1 = actionMinX1 + actionWidth
local actionMinX2 = actionMaxX1 + actionSpaceX
local actionMaxX2 = actionMinX2 + actionWidth
local actionMinX3 = actionMaxX2 + actionSpaceX
local actionMaxX3 = actionMinX3 + actionWidth
local actionCenterX = actionMinX1 + (actionMaxX3 - actionMinX1) / 2
local actionCenterX1 = actionMinX1 + (actionMaxX1 - actionMinX1) / 2
local actionCenterX2 = actionMinX2 + (actionMaxX2 - actionMinX2) / 2
local actionCenterX3 = actionMinX3 + (actionMaxX3 - actionMinX3) / 2
local actionCenterY = actionMinY + (actionMaxY - actionMinY) / 2
local playerSepX1 = 341
local playerSepX2 = 683
local playerSepY1 = HEIGHT - 120
local nameX = playerSepX1 + (playerSepX2 - playerSepX1) / 2
local nameY = playerSepY1 - 30
local coinX = playerSepX1 + 30
local coinY = nameY
local milX = playerSepX2 - 30
local milY = nameY

local actionDo = "None"
local actionButton1 = "None"
local actionChoices = {None="Cannot Build", BuildStructure="Build Structure", PayLeft="Pay Left, Build", PayRight="Pay Right, Build", BuildWonder="Build Wonder", GainCoins="Gain Coins"}

local ageMilitaryPoints = {1, 3, 5}

local curPlayerIndex = 1

local gameMode = "Playing" -- "Starting", "Finished"

function Game:init(params)
    -- you can accept and set parameters here
    game = self
    
    self.age = 1
    self.round = 1
    self.ageDecks = {}
    self.ageDecks[1] = {}
    self.ageDecks[2] = {}
    self.ageDecks[3] = {}
    self.discards = {}
    self.players = params.players or {}
    self.wonders = {}
    curPlayerIndex = 1

    self:setup()
end

function Game:setup()
    -- setup players
    print("num players "..#self.players)
    Util.shuffle(self.players)
    
    -- create wonder boards
    self:createWonderBoards()
    
    -- assign wonder boards and left, right players
    for i,player in pairs(self.players) do
        player:setWonder(self.wonders[i])
        player:setLeftPlayer(self.players[self:getPrevPlayerIndex(i)])
        player:setRightPlayer(self.players[self:getNextPlayerIndex(i)])
    end

    -- setup age decks
    self:createCards()
    -- print("num age cards "..#self.ageDecks[1])
    
    -- start the first age
    self:startAge()
end

function Game:printPlayers()
    local player = self.players[curPlayerIndex]
    player:printInfo(player:getLeftPlayer(), player:getLeftPlayer())
end

function Game:getPrevPlayerIndex(idx)
    local index = idx - 1
    if index < 1 then
        index = #self.players
    end
    return index
end

function Game:getNextPlayerIndex(idx)
    local index = idx + 1
    if index > #self.players then
        index = 1
    end
    return index
end

function Game:dealCards(deck)
    while #deck>0 do
        for k,player in pairs(self.players) do
            player:addToHand(table.remove(deck))
        end
    end
end

function Game:getCurPlayerIndex()
    return curPlayerIndex
end

function Game:startAge()
    self:dealCards(self.ageDecks[self.age])
end

function Game:endAge()
    
    -- resolve military checks
    for i,player in pairs(self.players) do
        local leftPlayer = player:getLeftPlayer()
        local rightPlayer = player:getRightPlayer()
        if player:getShields() > leftPlayer:getShields() then
            player:addMilitaryPoints("left", ageMilitaryPoints[self.age])
        elseif player:getShields() < leftPlayer:getShields() then
            player:addMilitaryPoints("left", -1)
        else
            player:addMilitaryPoints("left", 0)
        end
        if player:getShields() > rightPlayer:getShields() then
            player:addMilitaryPoints("right", ageMilitaryPoints[self.age])
        elseif player:getShields() < rightPlayer:getShields() then
            player:addMilitaryPoints("right", -1)
        else
            player:addMilitaryPoints("right", 0)
        end
    end

    -- reset round, advance to next age
    self.round = 1
    self.age = self.age + 1
    if self.age > 3 then
        self:endGame()
    else
        self:startAge()
    end 
end

function Game:endPlayer()
    -- remove the card selection of our player
    -- self.players[curPlayerIndex]:setPick(picked)
    self.players[curPlayerIndex]:setAction(actionDo)

    curPlayerIndex = curPlayerIndex + 1
    if curPlayerIndex > #self.players then
        curPlayerIndex = 1
        self:endRound()
    end
end

function Game:endRound()
    
    -- for each player, build structure based on picked card
    for i,player in pairs(self.players) do
        local card = table.remove(player:getHand(), player:getPick())
        local action = player:getAction()
        if action == "BuildStructure" then
            player:addBuilding(card)
        elseif action == "PayLeft" then
            player:payPlayer(player:getLeftPlayer())
            player:addBuilding(card)
        elseif action == "PayRight" then
            player:payPlayer(player:getRightPlayer())
            player:addBuilding(card)
        elseif action == "BuildWonder" then
            player:buildWonderStage(card)
        else          -- "GainCoins"
            player:addCoins(3)
            table.insert(self.discards, card)
        end
        print(player.name.." "..action.." "..card.name)
    end
        
    -- save the hands reset the picks
    self.hands = {}
    for i,player in pairs(self.players) do
        table.insert(self.hands, player.hand)
        player:setPick(0)
    end
    
    -- rotate the hands
    if self.age == 2 then
        local hand = table.remove(self.hands, 1)
        table.insert(self.hands, hand)
    else
        local hand = table.remove(self.hands)
        table.insert(self.hands, 1, hand)
    end
    
    -- assign the hands to the players
    for i,hand in pairs(self.hands) do
        self.players[i].hand = hand
    end
    
    print("End Round "..self.round)
    
    -- end the round
    if self.round == 6 then
        -- discard last card from all players hand
        for i=1,#self.players do
            local card = table.remove(self.players[i].hand)
            table.insert(self.discards, card)
        end
        self:endAge()
    else
        self.round = self.round + 1
    end
end

function Game:endGame()
    -- resolve science points

    -- resolve guild points
    gameMode = "Finished"

end

function Game:createCards()
    local numPlayers = #self.players

    -- Read cards content from documents text file
    local myContent = readText("Documents:SevenWondersCards3")
    local cardArray = json.decode(myContent)
    
    -- Read guild cards from documents text file
    myContent = readText("Documents:SevenWondersCardsGuilds")
    local guildArray = json.decode(myContent)
    Util.shuffle(guildArray, 3)

    -- Add the appropriate guild cards to main cards
    for i=1,numPlayers+2 do
        local card = table.remove(guildArray)
        table.insert(cardArray, card)
    end
    
    Util.shuffle(cardArray, 5)

    for key,value in pairs(cardArray) do
        -- print("card "..key.." = "..value.name.." "..value.age)
        table.insert(self.ageDecks[value.age], Card(value))
    end
    -- print("ageDecks sizes "..#self.ageDecks[1].." "..#self.ageDecks[2].." "..#self.ageDecks[3])
end

function Game:createWonderBoards()
    -- Read wonder boards content from documents text file
    -- table.insert(boardArray, {name=wonders[1], side="A", resource="Ore", stages={{cost={"Wood", "Wood"}, effect="vp:3"}, {cost={"Clay", "Clay", "Clay"}, effect="shields:2"}, {cost={"Ore", "Ore", "Ore", "Ore"}, effect="vp:7"}}})
    local myContent = readText("Documents:SevenWondersBoards")
    local boardArray = json.decode(myContent)
    
    Util.shuffle(boardArray, 3)

    print("wonders size "..#self.wonders)
    for i,v in pairs(boardArray) do
        print("wonder "..i.." = "..v.name.." "..v.resource)
        table.insert(self.wonders, Wonder(v))
    end
end

function Game:drawImage(name, x, y)
    spriteMode(CENTER)
    if name == "Wood" then
        sprite("Project:Resource Wood", x, y)
    elseif name == "Stone" then
        sprite("Project:Resource Stone", x, y)
    elseif name == "Clay" then
        sprite("Project:Resource Clay", x, y)
    elseif name == "Ore" then
        sprite("Project:Resource Ore", x, y)
    elseif name == "Loom" then
        sprite("Project:Resource Loom", x, y)
    elseif name == "Glass" then
        sprite("Project:Resource Glass", x, y)
    elseif name == "Papyrus" then
        sprite("Project:Resource Papyrus", x, y)
    else
        sprite("Cargo Bot:Condition None", x, y)
    end
end

function Game.sortPlayers(player1, player2)
    if player1:getVictoryPoints() < player2:getVictoryPoints() then
        return true
    end
    return false
end

function Game:drawFinished()
    local w = WIDTH
    local h = HEIGHT
    local bgX = 0
    local bgY = 0
    local centerX = bgX + (w/2)
    local centerY = bgY + (h/2)

    -- draw background
        fill(103, 136, 156, 183)
        noStroke()
        -- stroke(0)
        rectMode(CORNER)
        rect(bgX, bgY, w, h)

    -- find the winner
    -- rewrite this to be more complete and check ties
    local standings = copy(self.players)
    table.sort(standings, Game.sortPlayers)
    
    -- display the standing
    font("ArialRoundedMTBold")
    fill(255)
    fontSize(40)
    textMode(CENTER)

    local tw, th = textSize()
    local num = #standings
    local rowSize = h / num
    local tx = rowSize
    for i,player in pairs(standings) do
        text("Player "..player.name.." - VP "..player:getVictoryPoints(), tx, centerY)
        tx = tx + rowSize
    end
end

function Game:draw()
    -- check different game modes: Starting, Playing, Finished
    if gameMode == "Finished" then
        self:drawFinished()
        return
    end
    
    local player = self.players[curPlayerIndex]
    -- draw the background
    spriteMode(CENTER)
    sprite("Project:"..player.wonder.name, WIDTH/2, HEIGHT/2)

    -- draw the current players hand to pick
    local x = xstart
    local y = HEIGHT - 30
    for k,card in pairs(player.hand) do
        sprite(card.image, x, y)
        x = x + 146
    end
    
    -- draw player separators
    stroke(128)
    strokeWidth(4)
    line(0, playerSepY1, playerSepX1, playerSepY1)
    line(playerSepX2, playerSepY1, WIDTH, playerSepY1)
    line(playerSepX1, 0, playerSepX1, playerSepY1)
    line(playerSepX2, 0, playerSepX2, playerSepY1)
    
    -- draw age
    font("ArialRoundedMTBold")
    fill(255)
    fontSize(24)
    textMode(CORNER)
    -- text("Age "..self.age.." - Round "..self.round.." - "..player.name, 10, actionMinY)
    text("Age "..self.age, 10, actionMinY)
    
    -- draw player areas
    player:getLeftPlayer():drawImage(0, true)
    player:drawImage(playerSepX1, false)
    player:getRightPlayer():drawImage(playerSepX2, true)
    
    -- check for picked card
    local pick = player:getPick()
    if pick > 0 then 
        x = xstart + (146*(pick-1))
        y = HEIGHT - 30
        
        -- draw background rectangle
        noFill()
        strokeWidth(4)
        stroke(0, 251, 255, 255)
        rectMode(CENTER)
        rect(x, y, 146, 50)
        
        -- draw action buttons
        y = actionMinY+(actionMaxY-actionMinY)/2-4
        spriteMode(CENTER)
        x = actionMinX1+(actionMaxX1-actionMinX1)/2
        sprite("Project:Action Marble", x, y)
        x = actionMinX2+(actionMaxX2-actionMinX2)/2
        sprite("Project:Action Marble", x, y)
        x = actionMinX3+(actionMaxX3-actionMinX3)/2
        sprite("Project:Action Marble", x, y)
        
        font("ArialRoundedMTBold")
        fill(0)
        fontSize(24)
        textMode(CORNER)
        text(actionChoices["BuildWonder"], actionMinX2+25, actionMinY+10)
        text(actionChoices["GainCoins"], actionMinX3+38, actionMinY+10)
        actionButton1 = player:getBuildStructureAction(pick)
        local label = ""
        if actionButton1 == "None" then
            fill(255, 0, 61, 255)
        end
        if actionButton1 == "PayLeft" then
            label = "Pay Left "..player:owes()
        elseif actionButton1 == "PayRight" then
            label = "Pay Right "..player:owes()
        else
            label = actionChoices[actionButton1]
        end
        -- local tw, th = textSize(label)
        -- text(actionChoices[actionButton1], actionMinX1+12, actionMinY+10)
        textMode(CENTER)
        text(label, actionCenterX1, actionCenterY)
    end
end

function Game:touched(touch)
    local player = self.players[curPlayerIndex]
    -- Codea does not automatically call this method
    if touch.state == ENDED then
        if touch.y > HEIGHT - 50 then
            local index = math.floor(touch.x/146) + 1
            player:setPick(index)
            --[[
            if index <= #player.hand then
                picked = index
            else
                picked = 0
            end
            -- print("picked "..picked.." x "..touch.x)
              ]]
        elseif touch.y > actionMinY and touch.y < actionMaxY and
               touch.x > actionMinX1 and touch.x < actionMaxX3 then
            if touch.x > actionMinX1 and touch.x < actionMaxX1 then
                actionDo = actionButton1
            elseif touch.x > actionMinX2 and touch.x < actionMaxX2 then
                actionDo = "BuildWonder"
            elseif touch.x > actionMinX3 and touch.x < actionMaxX3 then
                actionDo = "GainCoins"
            end
            local pick = player:getPick()
            if pick > 0 and actionDo ~= "None" then
                self:endPlayer()
            else
                -- sound(SOUND_EXPLODE, 10632)
            end
        else
            player:setPick(0)
        end
    end
end
