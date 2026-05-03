--[[
    Parallax Framework
    Copyright (c) 2025-2026 Parallax Framework Contributors

    This file is part of the Parallax Framework and is licensed under the MIT License.
    You may use, copy, modify, merge, publish, distribute, and sublicense this file
    under the terms of the LICENSE file included with this project.

    Attribution is required. If you use or modify this file, you must retain this notice.
]]

local player = ax.player.meta or FindMetaTable("Player")

player.BanInternal = player.BanInternal or player.Ban

--- Creates a Parallax-managed ban for this player.
-- Overrides Garry's Mod's native Player:Ban so every ban is persisted in ax_bans.
-- @realm server
-- @param minutes number Ban duration in minutes. Use 0 for permanent.
-- @param bKick boolean Whether to kick the player after creating the ban.
-- @param reason string Optional ban reason.
-- @param admin Player|nil Optional admin responsible for the ban.
-- @param callback function|nil Optional callback receiving (ok, banData, err).
function player:Ban(minutes, bKick, reason, admin, callback)
    if ( !ax.util:IsValidPlayer(self) ) then return false end

    local banModule = ax.admin
    if ( !istable(banModule) or !isfunction(banModule.CreateBan) ) then
        ax.util:PrintError("[ADMIN] Player:Ban called before the ban module was ready.\n")
        return false
    end

    banModule:CreateBan(self, admin, minutes, reason, callback, {
        bKick = bKick == true
    })

    return true
end
