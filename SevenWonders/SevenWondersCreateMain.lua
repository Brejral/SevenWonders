-- Main
-- Create 7 Wonders Cards

-- Use this function to perform your initial setup
function setup()
    print("Creating 7 Wonders Cards")
    createCardsFile3()
    createCardsFileGuilds()
    createWonderBoards()
    print("Done!")
end

function createCardsFile3()
    print("...for 3 players")
    local cardArray = {}
    -- table.insert(cardArray, {name="", ctype="", age=1, resources={""}, cost={}})
    
    -- "Wood", "Stone", "Ore", "Clay", "ClayOre", "StoneWood", "WoodOre", "WoodClay", "Loom", "Glass", "Papyrus"
    
    -- Raw Resources (brown)
    table.insert(cardArray, {name="Lumber Yard", ctype="Raw", age=1, resources={"Wood"}, rnum=1, cost={}})
    table.insert(cardArray, {name="Stone Pit", ctype="Raw", age=1, resources={"Stone"}, rnum=1, cost={}})
    table.insert(cardArray, {name="Clay Pool", ctype="Raw", age=1, resources={"Clay"}, rnum=1, cost={}})
    table.insert(cardArray, {name="Ore Vein", ctype="Raw", age=1, resources={"Ore"}, rnum=1, cost={}})
    table.insert(cardArray, {name="Clay Pit", ctype="Raw", age=1, resources={"ClayOre"}, rnum=1, cost={"Coin"}})
    table.insert(cardArray, {name="Timber Yard", ctype="Raw", age=1, resources={"StoneWood"}, rnum=1, cost={"Coin"}})
    table.insert(cardArray, {name="Saw Mill", ctype="Raw", age=2, resources={"Wood", "Wood"}, rnum=2, cost={"Coin"}})
    table.insert(cardArray, {name="Quarry", ctype="Raw", age=2, resources={"Stone", "Stone"}, rnum=2, cost={"Coin"}})
    table.insert(cardArray, {name="Brickyard", ctype="Raw", age=2, resources={"Clay", "Clay"}, rnum=2, cost={"Coin"}})
    table.insert(cardArray, {name="Foundry", ctype="Raw", age=2, resources={"Ore", "Ore"}, rnum=2, cost={"Coin"}})
    
    -- Manufactured Resources (grey)
    table.insert(cardArray, {name="Loom", ctype="Man", age=1, resources={"Loom"}, rnum=1, cost={}})
    table.insert(cardArray, {name="Glassworks", ctype="Man", age=1, resources={"Glass"}, rnum=1, cost={}})
    table.insert(cardArray, {name="Press", ctype="Man", age=1, resources={"Papyrus"}, rnum=1, cost={}})
    table.insert(cardArray, {name="Loom", ctype="Man", age=2, resources={"Loom"}, rnum=1, cost={}})
    table.insert(cardArray, {name="Glassworks", ctype="Man", age=2, resources={"Glass"}, rnum=1, cost={}})
    table.insert(cardArray, {name="Press", ctype="Man", age=2, resources={"Papyrus"}, rnum=1, cost={}})

    -- Civilian Structures (blue)
    table.insert(cardArray, {name="Baths", ctype="Civ", age=1, cost={"Stone"}, effect={"vp:3"}})
    table.insert(cardArray, {name="Altar", ctype="Civ", age=1, cost={}, effect={"vp:2"}})
    table.insert(cardArray, {name="Theater", ctype="Civ", age=1, cost={}, effect={"vp:2"}})
    table.insert(cardArray, {name="Aqueduct", ctype="Civ", age=2, cost={"Stone", "Stone", "Stone"}, effect={"vp:5"}})
    table.insert(cardArray, {name="Temple", ctype="Civ", age=2, cost={"Wood", "Clay", "Glass"}, effect={"vp:3"}})
    table.insert(cardArray, {name="Statue", ctype="Civ", age=2, cost={"Wood", "Ore", "Ore"}, effect={"vp:4"}})
    table.insert(cardArray, {name="Courthouse", ctype="Civ", age=2, cost={"Clay", "Clay", "Loom"}, effect={"vp:4"}})
    table.insert(cardArray, {name="Pantheon", ctype="Civ", age=3, cost={"Clay", "Clay", "Ore", "Glass", "Papyrus", "Loom"}, effect={"vp:7"}})
    table.insert(cardArray, {name="Gardens", ctype="Civ", age=3, cost={"Wood", "Clay", "Clay"}, effect={"vp:5"}})
    table.insert(cardArray, {name="Town Hall", ctype="Civ", age=3, cost={"Glass", "Ore", "Stone", "Stone"}, effect={"vp:6"}})
    table.insert(cardArray, {name="Palace", ctype="Civ", age=3, cost={"Glass", "Papyrus", "Loom", "Clay", "Wood", "Ore", "Stone"}, effect={"vp:8"}})
    table.insert(cardArray, {name="Senate", ctype="Civ", age=3, cost={"Ore", "Stone", "Wood", "Wood"}, effect={"vp:6"}})

    -- Commercial Structures (yellow)
    table.insert(cardArray, {name="East Trading Post", ctype="Com", age=1, effect={"BuyRaw1Right"}, cost={}})
    table.insert(cardArray, {name="West Trading Post", ctype="Com", age=1, effect={"BuyRaw1Left"}, cost={}})
    table.insert(cardArray, {name="Marketplace", ctype="Com", age=1, effect={"BuyMan1"}, cost={}})
    table.insert(cardArray, {name="Forum", ctype="Com", age=2, effect={"ManResource"}, cost={"Clay", "Clay"}})
    table.insert(cardArray, {name="Caravansery", ctype="Com", age=2, effect={"RawResource"}, cost={"Wood", "Wood"}})
    table.insert(cardArray, {name="Vineyard", ctype="Com", age=2, effect={"RawCoins1"}, cost={}})
    table.insert(cardArray, {name="Haven", ctype="Com", age=3, effect={"RawCoinsVp"}, cost={"Loom", "Ore", "Wood"}})
    table.insert(cardArray, {name="Lighthouse", ctype="Com", age=3, effect={"SciCoinsVp"}, cost={"Glass", "Stone"}})
    table.insert(cardArray, {name="Arena", ctype="Com", age=3, effect={"WonderCoinsVp"}, cost={"Ore", "Stone", "Stone"}})

    -- Miltary Structures (red)
    table.insert(cardArray, {name="Stockade", ctype="Mil", age=1, cost={"Wood"}, effect={"shields:1"}})
    table.insert(cardArray, {name="Barracks", ctype="Mil", age=1, cost={"Ore"}, effect={"shields:1"}})
    table.insert(cardArray, {name="Guard Tower", ctype="Mil", age=1, cost={"Clay"}, effect={"shields:1"}})
    table.insert(cardArray, {name="Walls", ctype="Mil", age=2, cost={"Stone", "Stone", "Stone"}, effect={"shields:2"}})
    table.insert(cardArray, {name="Stables", ctype="Mil", age=2, cost={"Ore", "Clay", "Wood"}, effect={"shields:2"}})
    table.insert(cardArray, {name="Archery Range", ctype="Mil", age=2, cost={"Wood", "Wood", "Ore"}, effect={"shields:2"}})
    table.insert(cardArray, {name="Fortifications", ctype="Mil", age=3, cost={"Stone", "Ore", "Ore", "Ore"}, effect={"shields:3"}})
    table.insert(cardArray, {name="Arsenal", ctype="Mil", age=3, cost={"Ore", "Wood", "Wood", "Loom"}, effect={"shields:3"}})
    table.insert(cardArray, {name="Siege Workshop", ctype="Mil", age=3, cost={"Wood", "Clay", "Clay", "Clay"}, effect={"shields:3"}})
   
    -- Scientific Structures (green)
    table.insert(cardArray, {name="Apothecary", ctype="Sci", age=1, effect={"Compass"}, cost={"Loom"}})
    table.insert(cardArray, {name="Workshop", ctype="Sci", age=1, effect={"Gear"}, cost={"Glass"}})
    table.insert(cardArray, {name="Scriptorium", ctype="Sci", age=1, effect={"Tablet"}, cost={"Papyrus"}})
    table.insert(cardArray, {name="Dispensary", ctype="Sci", age=2, effect={"Compass"}, cost={"Ore", "Ore", "Glass"}})
    table.insert(cardArray, {name="Laboratory", ctype="Sci", age=2, effect={"Gear"}, cost={"Clay", "Clay", "Papyrus"}})
    table.insert(cardArray, {name="Library", ctype="Sci", age=2, effect={"Tablet"}, cost={"Stone", "Stone", "Loom"}})
    table.insert(cardArray, {name="School", ctype="Sci", age=2, effect={"Tablet"}, cost={"Wood", "Papyrus"}})
    table.insert(cardArray, {name="Lodge", ctype="Sci", age=3, effect={"Compass"}, cost={"Clay", "Clay", "Loom", "Papyrus"}})
    table.insert(cardArray, {name="Obseratory", ctype="Sci", age=3, effect={"Gear"}, cost={"Ore", "Ore", "Glass", "Loom"}})
    table.insert(cardArray, {name="University", ctype="Sci", age=3, effect={"Tablet"}, cost={"Wood", "Wood", "Papyrus", "Glass"}})
    table.insert(cardArray, {name="Academy", ctype="Sci", age=3, effect={"Compass"}, cost={"Stone", "Stone", "Stone", "Glass"}})
    table.insert(cardArray, {name="Study", ctype="Sci", age=3, effect={"Gear"}, cost={"Wood", "Papyrus", "Loom"}})
   
    -- Encode the content
    local myContent = json.encode(cardArray)
    
    -- Save text content into documents directory
    saveText("Documents:SevenWondersCards3", myContent)

end

function createCardsFile4()
    print("...for 4 players")
    local cardArray = {}
    table.insert(cardArray, {name="Lumber Yard", ctype="Raw", age=1, resources={"Wood"}, rnum=1, cost={}})
    table.insert(cardArray, {name="Ore Vein", ctype="Raw", age=1, resources={"Ore"}, rnum=1, cost={}})
    table.insert(cardArray, {name="Excavation", ctype="Raw", age=1, resources={"StoneClay"}, rnum=1, cost={"coin"}})
    table.insert(cardArray, {name="Saw Mill", ctype="Raw", age=2, resources={"Wood", "Wood"}, rnum=2, cost={"coin"}})
    table.insert(cardArray, {name="Quarry", ctype="Raw", age=2, resources={"Stone", "Stone"}, rnum=2, cost={"coin"}})
    table.insert(cardArray, {name="Brickyard", ctype="Raw", age=2, resources={"Clay", "Clay"}, rnum=2, cost={"coin"}})
    table.insert(cardArray, {name="Foundry", ctype="Raw", age=2, resources={"Ore", "Ore"}, rnum=2, cost={"coin"}})
    
    -- for 5 players
    table.insert(cardArray, {name="Stone Pit", ctype="Raw", age=1, resources={"Stone"}, rnum=1, cost={}})
    table.insert(cardArray, {name="Clay Pool", ctype="Raw", age=1, resources={"Clay"}, rnum=1, cost={}})
    table.insert(cardArray, {name="Forest Cave", ctype="Raw", age=1, resources={"WoodOre"}, rnum=1, cost={"coin"}})
    
    -- for 6 players
    table.insert(cardArray, {name="Tree Farm", ctype="Raw", age=1, resources={"WoodClay"}, rnum=1, cost={"coin"}})
    table.insert(cardArray, {name="Mine", ctype="Raw", age=1, resources={"Ore", "Stone"}, rnum=1, cost={"coin"}})
        
    -- for 7 players
    
    -- Encode the content
    local myContent = json.encode(cardArray)
    
    -- Save text content into documents directory
    saveText("Documents:SevenWondersCards4", myContent)

end

function createCardsFileGuilds()
    print("... and Guilds")
    local cardArray = {}

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
   
    local myContent = json.encode(cardArray)
    
    -- Save some text content into documents directory
    saveText("Documents:SevenWondersCardsGuilds", myContent)

end

function createWonderBoards()
    print("...Wonder Boards")

    local wonders = {"Rhodes", "Alexandria", "Ephesus", "Babylon", "Olympia", "Halicarnassus", "Giza"}
    
    local boardArray = {}
    table.insert(boardArray, {name=wonders[1], side="A", resource="Ore", stages={{cost={"Wood", "Wood"}, effect={"vp:3"}}, {cost={"Clay", "Clay", "Clay"}, effect={"shields:2"}}, {cost={"Ore", "Ore", "Ore", "Ore"}, effect={"vp:7"}}}})
    table.insert(boardArray, {name=wonders[2], side="A", resource="Glass", stages={{cost={"Stone", "Stone"}, effect={"vp:3"}}, {cost={"Ore", "Ore"}, effect={"RawChoice"}}, {cost={"Glass", "Glass"}, effect={"vp:7"}}}})
    table.insert(boardArray, {name=wonders[3], side="A", resource="Papyrus", stages={{cost={"Stone", "Stone"}, effect={"vp:3"}}, {cost={"Wood", "Wood"}, effect={"coins:9"}}, {cost={"Papyrus", "Papyrus"}, effect={"vp:7"}}}})
    table.insert(boardArray, {name=wonders[4], side="A", resource="Clay", stages={{cost={"Clay", "Clay"}, effect={"vp:3"}}, {cost={"Wood", "Wood", "Wood"}, effect={"ScienceChoice"}}, {cost={"Clay", "Clay", "Clay", "Clay"}, effect={"vp:7"}}}})
    table.insert(boardArray, {name=wonders[5], side="A", resource="Wood", stages={{cost={"Wood", "Wood"}, effect={"vp:3"}}, {cost={"Stone", "Stone"}, effect={"BuildFree"}}, {cost={"Ore", "Ore"}, effect={"vp:7"}}}})
    table.insert(boardArray, {name=wonders[6], side="A", resource="Loom", stages={{cost={"Clay", "Clay"}, effect={"vp:3"}}, {cost={"Ore", "Ore", "Ore"}, effect={"shields:2"}}, {cost={"Loom", "Loom"}, effect={"vp:7"}}}})
    table.insert(boardArray, {name=wonders[7], side="A", resource="Stone", stages={{cost={"Stone", "Stone"}, effect={"vp:3"}}, {cost={"Wood", "Wood", "Wood"}, effect={"vp:5"}}, {cost={"Stone", "Stone", "Stone", "Stone"}, effect={"vp:7"}}}})
   
    local myContent = json.encode(boardArray)
    
    -- Save some text content into documents directory
    saveText("Documents:SevenWondersBoards", myContent)
end

function createWonderBoardsB()
    print("...Wonder Boards B")

    local wonders = {"Rhodes", "Alexandria", "Ephesus", "Babylon", "Olympia", "Halicarnassus", "Giza"}
    
    local boardArray = {}
    table.insert(boardArray, {name=wonders[1], side="B", resource="Ore", stages={{cost={"Stone", "Stone", "Stone"}, effect={"shields:1","vp:3","coins:3"}}, {cost={"Ore", "Ore", "Ore", "Ore"}, effect={"shields:1","vp:4","coins:4"}}}})
    print("...Need to Finish Wonder Boards B")
    table.insert(boardArray, {name=wonders[2], side="B", resource="Glass", stages={{cost={"Stone", "Stone"}, effect={"vp:3"}}, {cost={"Ore", "Ore"}, effect={"RawChoice"}}, {cost={"Glass", "Glass"}, effect={"vp:7"}}}})
    table.insert(boardArray, {name=wonders[3], side="B", resource="Papyrus", stages={{cost={"Stone", "Stone"}, effect={"vp:3"}}, {cost={"Wood", "Wood"}, effect={"coins:9"}}, {cost={"Papyrus", "Papyrus"}, effect={"vp:7"}}}})
    table.insert(boardArray, {name=wonders[4], side="B", resource="Clay", stages={{cost={"Clay", "Clay"}, effect={"vp:3"}}, {cost={"Wood", "Wood", "Wood"}, effect={"ScienceChoice"}}, {cost={"Clay", "Clay", "Clay", "Clay"}, effect={"vp:7"}}}})
    table.insert(boardArray, {name=wonders[5], side="B", resource="Wood", stages={{cost={"Wood", "Wood"}, effect={"vp:3"}}, {cost={"Stone", "Stone"}, effect={"BuildFree"}}, {cost={"Ore", "Ore"}, effect={"vp:7"}}}})
    table.insert(boardArray, {name=wonders[6], side="B", resource="Loom", stages={{cost={"Clay", "Clay"}, effect={"vp:3"}}, {cost={"Ore", "Ore", "Ore"}, effect={"shields:2"}}, {cost={"Loom", "Loom"}, effect={"vp:7"}}}})
    table.insert(boardArray, {name=wonders[7], side="B", resource="Stone", stages={{cost={"Stone", "Stone"}, effect={"vp:3"}}, {cost={"Wood", "Wood", "Wood"}, effect={"shields:2"}}, {cost={"Stone", "Stone", "Stone", "Stone"}, effect={"vp:7"}}}})
   
    local myContent = json.encode(boardArray)
    
    -- Save some text content into documents directory
    saveText("Documents:SevenWondersBoardsB", myContent)
end

function createFileTemplate()
    print("...Create File Template")
    local cardArray = {}
    table.insert(cardArray, {name="", ctype="", age=1, resources={""}, rnum=1, cost={}})
   
    local myContent = json.encode(cardArray)
    
    -- Save some text content into documents directory
    saveText("Documents:SevenWondersFile", myContent)
end

-- This function gets called once every frame
--[[
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
end
  ]]
