--[[
    Parallax Framework
    Copyright (c) 2025-2026 Parallax Framework Contributors

    This file is part of the Parallax Framework and is licensed under the MIT License.
    You may use, copy, modify, merge, publish, distribute, and sublicense this file
    under the terms of the LICENSE file included with this project.

    Attribution is required. If you use or modify this file, you must retain this notice.
]]

local MODULE = MODULE or {}

function MODULE:CheckPasswordBan(steamID64)
    local banData = self:GetCachedActiveBan(steamID64)
    if ( !banData ) then return end

    return false, self:BuildBanKickMessage(banData)
end

function MODULE:ValidateAuthedBan(client)
    self:ValidateClientBan(client, "PlayerAuthed")
end

function MODULE:ValidateInitialSpawnBan(client)
    self:ValidateClientBan(client, "PlayerInitialSpawn")
end

hook.Add("CheckPassword", "ax.admin.bans.CheckPassword", function(steamID64)
    if ( !istable(MODULE) or !isfunction(MODULE.CheckPasswordBan) ) then return end

    return MODULE:CheckPasswordBan(steamID64)
end)

hook.Add("PlayerAuthed", "ax.admin.bans.PlayerAuthed", function(client)
    if ( !istable(MODULE) or !isfunction(MODULE.ValidateAuthedBan) ) then return end

    MODULE:ValidateAuthedBan(client)
end)

hook.Add("PlayerInitialSpawn", "ax.admin.bans.PlayerInitialSpawn", function(client)
    if ( !istable(MODULE) or !isfunction(MODULE.ValidateInitialSpawnBan) ) then return end

    MODULE:ValidateInitialSpawnBan(client)
end)
