--[[
    Parallax Framework
    Copyright (c) 2025-2026 Parallax Framework Contributors

    This file is part of the Parallax Framework and is licensed under the MIT License.
    You may use, copy, modify, merge, publish, distribute, and sublicense this file
    under the terms of the LICENSE file included with this project.

    Attribution is required. If you use or modify this file, you must retain this notice.
]]

local savedPositions = savedPositions or {}

local function getIdentifier(player)
    return ax.util:IsValidPlayer(player) and player:SteamID64() or nil
end

local function savePosition(player)
    local id = getIdentifier(player)
    if ( !id ) then return end

    if ( !player:Alive() ) then
        player:Spawn()
    end

    savedPositions[id] = {
        pos = player:GetPos(),
        ang = player:EyeAngles()
    }
end

local function restorePosition(player)
    local id = getIdentifier(player)
    if ( !id ) then
        return false, "Invalid player reference"
    end

    local data = savedPositions[id]
    if ( !data or !data.pos or !data.ang ) then
        return false, "No saved position for that player"
    end

    player:SetPos(data.pos)
    player:SetEyeAngles(data.ang)
    return true
end

local function placeNearPlayer(target, reference)
    local forward = reference:EyeAngles():Forward()
    forward.z = 0

    local offset = forward * 64 + Vector(0, 0, 8)
    local destination = target:GetPos() + offset

    reference:SetPos(destination)
    reference:SetEyeAngles(target:EyeAngles())
end

local function bringToPlayer(target, reference)
    local forward = reference:EyeAngles():Forward()
    forward.z = 0

    local offset = forward * 64 + Vector(0, 0, 8)
    local destination = reference:GetPos() + offset

    target:SetPos(destination)
    target:SetEyeAngles(reference:EyeAngles())
end

local function traceDestination(client)
    local trace = util.TraceHull({
        start = client:EyePos(),
        endpos = client:EyePos() + client:EyeAngles():Forward() * 16384,
        filter = client,
        mins = Vector(-16, -16, -4),
        maxs = Vector(16, 16, 64)
    })

    if ( trace.Hit ) then
        return trace.HitPos + trace.HitNormal * 10
    end
end

ax.command:Add("PlyGoto", {
    description = "Teleport yourself to a player",
    adminOnly = true,
    arguments = {
        { name = "player", type = ax.type.player }
    },
    OnRun = function(def, client, target)
        if ( client == target ) then
            return "You cannot teleport to yourself"
        end

        savePosition(client)
        placeNearPlayer(target, client)

        return "Teleported to " .. target:Nick()
    end
})

ax.command:Add("PlyBring", {
    description = "Bring a player to you",
    adminOnly = true,
    arguments = {
        { name = "player", type = ax.type.player }
    },
    OnRun = function(def, client, target)
        if ( client == target ) then
            return "You cannot bring yourself"
        end

        savePosition(target)
        bringToPlayer(target, client)

        return "Brought " .. target:Nick() .. " to your position"
    end
})

ax.command:Add("PlyTeleport", {
    description = "Teleport to where you're looking",
    adminOnly = true,
    OnRun = function(def, client)
        local destination = traceDestination(client)

        if ( !destination ) then
            return "Could not find a valid location to teleport to"
        end

        savePosition(client)
        client:SetPos(destination)

        return "Teleported to target location"
    end
})

ax.command:Add("PlyReturn", {
    description = "Return a player to their previous position",
    adminOnly = true,
    arguments = {
        { name = "player", type = ax.type.player, optional = true }
    },
    OnRun = function(def, client, target)
        target = target or client

        local ok, err = restorePosition(target)
        if ( !ok ) then
            return err or "Unable to return that player"
        end

        return "Returned " .. target:Nick() .. " to their previous position"
    end
})

ax.command:Add("PlySetHealth", {
    description = "Set a player's health",
    adminOnly = true,
    arguments = {
        { name = "player", type = ax.type.player },
        { name = "amount", type = ax.type.number }
    },
    OnRun = function(def, client, target, amount)
        amount = math.Clamp(amount, 0, 2147483647)
        target:SetHealth(amount)

        if ( target == client ) then
            return "Set your health to " .. amount
        else
            return "Set " .. target:Nick() .. "'s health to " .. amount
        end
    end
})

ax.command:Add("PlySetArmor", {
    description = "Set a player's armor",
    adminOnly = true,
    arguments = {
        { name = "player", type = ax.type.player },
        { name = "amount", type = ax.type.number }
    },
    OnRun = function(def, client, target, amount)
        amount = math.Clamp(amount, 0, 2147483647)
        target:SetArmor(amount)

        if ( target == client ) then
            return "Set your armor to " .. amount
        else
            return "Set " .. target:Nick() .. "'s armor to " .. amount
        end
    end
})

ax.command:Add("PlyGiveAmmo", {
    description = "Give ammo to a player",
    adminOnly = true,
    arguments = {
        { name = "player", type = ax.type.player },
        { name = "amount", type = ax.type.number },
        { name = "ammo type", type = ax.type.string, optional = true }
    },
    OnRun = function(def, client, target, amount, ammoType)
        local weapon = target:GetActiveWeapon()

        if ( type(weapon) != "Weapon" ) then
            return target:Nick() .. " has no active weapon"
        end

        ammoType = ammoType or weapon:GetPrimaryAmmoType()

        if ( ammoType == -1 ) then
            return "Invalid ammo type"
        end

        target:GiveAmmo(amount, ammoType, true)

        if ( target == client ) then
            return "Gave yourself " .. amount .. " ammo"
        else
            return "Gave " .. target:Nick() .. " " .. amount .. " ammo"
        end
    end
})

ax.command:Add("PlyFreeze", {
    description = "Freeze or unfreeze a player",
    adminOnly = true,
    arguments = {
        { name = "player", type = ax.type.player }
    },
    OnRun = function(def, client, target)
        if ( target == client ) then
            return "You cannot freeze yourself"
        end

        target:Freeze(!target:IsFrozen())

        local state = target:IsFrozen() and "frozen" or "unfrozen"
        return target:Nick() .. " has been " .. state
    end
})

ax.command:Add("PlyRespawn", {
    description = "Respawn a player",
    adminOnly = true,
    arguments = {
        { name = "player", type = ax.type.player }
    },
    OnRun = function(def, client, target)
        target:Spawn()
        return "Respawned " .. target:Nick()
    end
})

ax.command:Add("PlySlay", {
    description = "Kill a player",
    adminOnly = true,
    arguments = {
        { name = "player", type = ax.type.player }
    },
    OnRun = function(def, client, target)
        target:TakeDamage(target:Health(), client, nil)

        return "Killed " .. target:Nick()
    end
})

ax.command:Add("PlyExit", {
    description = "Force a player to exit their vehicle or chair",
    adminOnly = true,
    arguments = {
        { name = "player", type = ax.type.player }
    },
    OnRun = function(def, client, target)
        if ( !ax.util:IsValidPlayer(target) ) then return end

        if ( target:InVehicle() ) then
            target:ExitVehicle()
            return "Forced " .. target:Nick() .. " to exit their vehicle/seat."
        end

        return target:Nick() .. " is not in a vehicle or chair."
    end
})

ax.command:Add("PlyKick", {
    description = "Kick a player from the server",
    adminOnly = true,
    arguments = {
        { name = "player", type = ax.type.player },
        { name = "reason", type = ax.type.text, optional = true }
    },
    OnRun = function(def, client, target, reason)
        if ( target == client ) then
            return "You cannot kick yourself"
        end

        if ( !isstring(reason) or reason == "" ) then
            reason = "Kicked by " .. client:Nick()
        end

        local targetName = target:Nick()
        target:Kick(reason)

        return "Kicked " .. targetName .. " (" .. reason .. ")"
    end
})

ax.command:Add("PlyBan", {
    description = "Ban a player from the server (minutes; 0 = permanent)",
    adminOnly = true,
    arguments = {
        { name = "player", type = ax.type.player },
        { name = "minutes", type = ax.type.number },
        { name = "reason", type = ax.type.text, optional = true }
    },
    OnRun = function(def, client, target, minutes, reason)
        if ( target == client ) then
            return "You cannot ban yourself"
        end

        minutes = math.Clamp(math.floor(minutes or 0), 0, 2147483647)

        if ( !isstring(reason) or reason == "" ) then
            reason = "Banned by " .. client:Nick()
        end

        local targetName = target:Nick()
        local duration = minutes == 0 and "permanently" or ( minutes .. " minute(s)" )

        target:Ban(minutes, true)
        target:Kick(reason)

        return "Banned " .. targetName .. " " .. duration .. " (" .. reason .. ")"
    end
})

ax.command:Add("Map", {
    description = "Change the map",
    adminOnly = true,
    arguments = {
        { name = "map", type = ax.type.string, required = true },
        { name = "time", type = ax.type.number, required = false }
    },
    OnRun = function(self, client, map, delay)
        if ( !map or map == "" ) then
            return "You must specify a map."
        end

        -- Normalize map name
        map = string.lower(string.Trim(map))

        delay = delay or 15

        -- Check if map exists
        if ( !file.Exists("maps/" .. map .. ".bsp", "GAME") ) then
            return "Map '" .. map .. "' does not exist on the server."
        end

        -- Prevent changing to current map
        if ( game.GetMap() == map ) then
            return "You are already on this map."
        end

        -- Notify players
        for _, other in player.Iterator() do
            other:ChatPrint(client:Nick() .. " is changing the map to " .. map .. " in " .. tostring(delay) .. " second(s)")
        end

        -- Delay slightly to ensure messages send
        timer.Simple(delay, function()
            RunConsoleCommand("changelevel", map)
        end)

        return
    end
})

ax.command:Add("StopSounds", {
    description = "Immediately stops all sounds.",
    adminOnly = true,
    OnRun = function(self, client)
        for _, other in player.Iterator() do
            other:ConCommand("stopsound")
        end
    end
})
