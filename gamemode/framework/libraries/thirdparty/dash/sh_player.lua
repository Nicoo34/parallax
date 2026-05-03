-- https://github.com/SuperiorServers/dash/blob/master/lua/dash/extensions/player.lua

local ENTITY = FindMetaTable("Entity")
local GetTable = ENTITY.GetTable

function player.GetStaff()
    local staff = {}

    for _, v in player.Iterator() do
        if v:IsAdmin() then
            staff[#staff + 1] = v
        end
    end

    return staff
end

local player = ax.player.meta or FindMetaTable("Player")

--- Player metatable fallback indexer.
-- Looks up keys on `ax.player.meta`, then the base Entity metatable, then the player's entity table.
-- This keeps Parallax player extensions compatible with standard entity methods and per-player stored fields.
-- @realm shared
-- @param key any The field or method key being indexed.
-- @return any The resolved value, or nil if no value exists.
function player:__index(key)
    local val = player[key] or ENTITY[key]
    if ( val != nil ) then return val end

    if ( isfunction(GetTable) ) then
        local tbl = GetTable(self)
        if ( istable(tbl) ) then
            return tbl[key]
        end
    end

    return nil
end

if ( CLIENT ) then return end

-- Fix for https://github.com/Facepunch/garrysmod-issues/issues/2447
local telequeue = {}
local setpos = ENTITY.SetPos

--- Queues a server-side player position update until `FinishMove`.
-- Overrides the raw Entity:SetPos behavior for players to avoid Garry's Mod issue #2447 by applying the position during movement finalization.
-- @realm server
-- @param pos Vector The target world position.
-- @usage client:SetPos(spawnPosition)
function player:SetPos(pos)
    telequeue[self] = pos
end

hook.Add("FinishMove", "SetPos.FinishMove", function(pl)
    if ( telequeue[pl] ) then
        setpos(pl, telequeue[pl])
        telequeue[pl] = nil
        return true
    end
end)
