-- Main
-- Seven Wonders
-- supportedOrientations(LANDSCAPE_RIGHT)
supportedOrientations(LANDSCAPE_LEFT)
-- debugResources = false
parameter.action("Print Players", printPlayers)
parameter.boolean("debugResources", false)

function printPlayers()
    myGame:printPlayers()
end

function myDebug(msg)
    if debugResources then print(msg) end
end

-- Use this function to perform your initial setup
function setup()
    displayMode(FULLSCREEN)
    local names = {"Tim", "Tyler", "Bryce", "Kendall", "Brenda", "Grandma", "Cassie"}
    local wonders = {"Rhodes", "Alexandria", "Ephesus", "Babylon", "Olympia", "Halicarnassus", "Giza"}
    print("7 Wonders!")
    local numPlayers = 3
    local myPlayers = {}
    Util.shuffle(names, 3)
    Util.shuffle(wonders, 3)
    for i=1,numPlayers do
        myPlayers[i] = Player({name=names[i], board=wonders[i]})
    end
    myGame = Game({players = myPlayers})
    print("Done!")
end

-- This function gets called once every frame
function draw()
    -- Do your drawing here
    myGame:draw()
    
    myGame:touched(CurrentTouch) 
end
