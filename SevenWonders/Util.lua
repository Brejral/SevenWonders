-- Util Class
Util = class()

function Util.shuffle(t, cnt)
    -- Shuffle an array 
    local rand = math.random
    local iter = #t
    local j
    
    for i=iter,2,-1 do
        j = rand(i)
        t[i],t[j] = t[j],t[i]
    end
    
    -- Shuffle three times
    cnt = cnt or 0
    if cnt < 3 then
        Util.shuffle(t, cnt+1)
    end
end

function Util.test()
    -- 
end

-- returns two values: effect, count 
-- for "coins:1" or effect=coins, count=1
function Util.getEffect(eff)
    local effect = ""
    local count = 0
    if eff ~= nil then
        local idx = string.find(eff, ":")
        if idx ~= nil then
            count = tonumber(string.sub(eff, idx+1))
            effect = string.sub(eff, 1, idx-1)
        else
            effect = eff
        end
    end
    print(" Effect ("..tostring(eff)..") ("..effect..") "..count)
    return effect,count
end

function Util.getImage(ctype)
    -- 
    img = image(21, 21)
    setContext(img)
    spriteMode(CENTER)
    sprite("Project:Resource Ore",0,0)
    setContext()
    
    return img
end

function Util.func()
    -- 
end

function copy(obj, seen)
    -- copy
    if type(obj) ~= "table" then
        return obj
    end
    if seen and seen[obj] then
        return seen[obj]
    end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k,v in pairs(obj) do
        res[copy(k, s)] = copy(v, s)
    end
    return res
end

function Util.isResourceRaw(resource)
    if resource == "Wood" or 
        resource == "Clay" or 
        resource == "Stone" or 
        resource == "Ore" or 
        resource == "WoodClay" or 
        resource == "StoneClay" or 
        resource == "ClayOre" or 
        resource == "StoneWood" or 
        resource == "WoodOre" or 
        resource == "OreStone"  then
        return true
    end
    
    return false
end

function Util.isResourceMan(resource)
    if resource == "Loom" or resource == "Glass" or resource == "Papyrus" then
        return true
    end
    
    return false
end

function Util.isEqualResource(r1, r2)
    if r1 == "WoodClay" and (r2 == "Wood" or r2 == "Clay" or r2 == "WoodClay") then
        return true
    elseif r1 == "StoneClay" and (r2 == "Stone" or r2 == "Clay" or r2 == "StoneClay") then
        return true
    elseif r1 == "ClayOre" and (r2 == "Clay" or r2 == "Ore" or r2 == "ClayOre") then
        return true
    elseif r1 == "StoneWood" and (r2 == "Stone" or r2 == "Wood" or r2 == "StoneWood") then
        return true
    elseif r1 == "WoodOre" and (r2 == "Wood" or r2 == "Ore" or r2 == "WoodOre") then
        return true
    elseif r1 == "OreStone" and (r2 == "Ore" or r2 == "Stone" or r2 == "OreStone") then
        return true
    elseif r2 == "WoodClay" and (r1 == "Wood" or r1 == "Clay") then
        return true
    elseif r2 == "StoneClay" and (r1 == "Stone" or r1 == "Clay") then
        return true
    elseif r2 == "ClayOre" and (r1 == "Clay" or r1 == "Ore") then
        return true
    elseif r2 == "StoneWood" and (r1 == "Stone" or r1 == "Wood") then
        return true
    elseif r2 == "WoodOre" and (r1 == "Wood" or r1 == "Ore") then
        return true
    elseif r2 == "OreStone" and (r1 == "Ore" or r1 == "Stone") then
        return true
    elseif r1 == r2 then
        return true
    end
    
    return false
end

function Util.isElementResources(t, res)
    for i,v in pairs(t) do
        if Util.isEqualResource(res, v) then
            -- print("isElementResources() "..res.." "..v)
            return true
        end
    end
    return false
end

function Util.removeMatchingResource(t, r)
    for i,v in pairs(t) do
        if Util.isEqualResource(r, v) then
            myDebug(" -- found "..r.." removing "..v)
            -- removeItem(t, v)
            table.remove(t, i)
            return true
        end
    end
    return false    
end

function Util.isElement(t, e)
    for i,v in pairs(t) do
        -- print("isElement() "..e.." "..v)
        if e == v then
            return true
        end
    end
    return false
end

function Util.printTable(t)
        for k,v in pairs(t) do
            print("  k "..k.." v "..v)
        end
end

function indexOf(tab, item)
    if type(tab) ~= "table" then
        return nil
    end
    
    for i,v in pairs(tab) do
        if v == item then
            return i
        end
    end
    
    return nil
end

function removeItem(tab, item)
    if type(tab) == "table" then
        local idx = indexOf(tab, item)
        if idx then
            table.remove(tab, idx)
        end
    end
end

function listItems(t)
    local str = "("
    for i,v in pairs(t) do
        if i==1 then
            str = str..v
        else
            str = str..", "..v
        end
    end
    str = str..")"
    return str
end

