--[[
    Parallax Framework
    Copyright (c) 2025-2026 Parallax Framework Contributors

    This file is part of the Parallax Framework and is licensed under the MIT License.
    You may use, copy, modify, merge, publish, distribute, and sublicense this file
    under the terms of the LICENSE file included with this project.

    Attribution is required. If you use or modify this file, you must retain this notice.
]]

local MODULE = MODULE or {}

local BAN_TABLE = "ax_bans"
local MAX_REASON_LENGTH = 512
local MAX_MINUTES = 35791394 -- Keeps duration within a signed 32-bit second range.

MODULE.banTableReady = MODULE.banTableReady or false
MODULE.banTableCallbacks = MODULE.banTableCallbacks or {}
MODULE.banActiveCache = MODULE.banActiveCache or {}

local function TrimText(value, fallback, maxLength)
    value = string.Trim(tostring(value or ""))
    if ( value == "" ) then
        value = fallback or ""
    end

    maxLength = tonumber(maxLength) or MAX_REASON_LENGTH
    if ( #value > maxLength ) then
        value = string.sub(value, 1, maxLength)
    end

    return value
end

local function GetSteamIDFrom64(steamID64)
    if ( !isstring(steamID64) or steamID64 == "" or !isfunction(util.SteamIDFrom64) ) then
        return ""
    end

    local bSuccess, steamID = pcall(util.SteamIDFrom64, steamID64)
    if ( bSuccess and isstring(steamID) ) then
        return steamID
    end

    return ""
end

local function GetActorData(actor)
    if ( ax.util:IsValidPlayer(actor) ) then
        return {
            steamid64 = actor:SteamID64(),
            steamid = actor:SteamID(),
            name = actor:SteamName()
        }
    end

    return {
        steamid64 = "0",
        steamid = "Console",
        name = "Console"
    }
end

local function NormalizeMinutes(minutes)
    minutes = math.floor(tonumber(minutes) or 0)
    return math.Clamp(minutes, 0, MAX_MINUTES)
end

local function NormalizeBanRow(row)
    if ( !istable(row) ) then return nil end

    row.id = math.floor(tonumber(row.id) or 0)
    row.created_at = math.floor(tonumber(row.created_at) or 0)
    row.duration = math.floor(tonumber(row.duration) or 0)
    row.expires_at = math.floor(tonumber(row.expires_at) or 0)
    row.revoked_at = math.floor(tonumber(row.revoked_at) or 0)
    row.modified_at = math.floor(tonumber(row.modified_at) or 0)
    row.steamid64 = tostring(row.steamid64 or "")
    row.steamid = tostring(row.steamid or "")
    row.name = tostring(row.name or "Unknown")
    row.admin_steamid64 = tostring(row.admin_steamid64 or "0")
    row.admin_steamid = tostring(row.admin_steamid or "")
    row.admin_name = tostring(row.admin_name or "Console")
    row.reason = tostring(row.reason or "No reason provided.")
    row.revoked_by_steamid64 = tostring(row.revoked_by_steamid64 or "")
    row.revoked_by_name = tostring(row.revoked_by_name or "")
    row.revoked_reason = tostring(row.revoked_reason or "")
    row.modified_by_steamid64 = tostring(row.modified_by_steamid64 or "")
    row.modified_by_name = tostring(row.modified_by_name or "")
    row.modify_reason = tostring(row.modify_reason or "")

    return row
end

local function NotifyCallback(callback, ok, result, err)
    if ( isfunction(callback) ) then
        callback(ok, result, err)
    end
end

function MODULE:NormalizeBanRow(row)
    return NormalizeBanRow(row)
end

function MODULE:NormalizeBanIdentifier(identifier)
    if ( ax.util:IsValidPlayer(identifier) ) then
        return identifier:SteamID64()
    end

    identifier = string.Trim(tostring(identifier or ""))
    if ( identifier == "" ) then return nil end

    if ( ax.type:Sanitise(ax.type.steamid64, identifier) ) then
        return identifier
    end

    if ( ax.type:Sanitise(ax.type.steamid, identifier) and isfunction(util.SteamIDTo64) ) then
        local steamID64 = util.SteamIDTo64(identifier)
        if ( ax.type:Sanitise(ax.type.steamid64, steamID64) ) then
            return steamID64
        end
    end

    return nil
end

function MODULE:IsBanActive(banData, unixTime)
    banData = NormalizeBanRow(banData)
    if ( !banData ) then return false end
    if ( banData.revoked_at > 0 ) then return false end

    unixTime = math.floor(tonumber(unixTime) or os.time())
    return banData.expires_at == 0 or banData.expires_at > unixTime
end

function MODULE:GetBanStatus(banData, unixTime)
    banData = NormalizeBanRow(banData)
    if ( !banData ) then return "unknown" end

    if ( banData.revoked_at > 0 ) then
        return "revoked"
    end

    if ( self:IsBanActive(banData, unixTime) ) then
        return "active"
    end

    return "expired"
end

function MODULE:FormatBanDuration(seconds)
    seconds = math.max(0, math.floor(tonumber(seconds) or 0))
    if ( seconds == 0 ) then return "Permanent" end

    local days = math.floor(seconds / 86400)
    seconds = seconds % 86400

    local hours = math.floor(seconds / 3600)
    seconds = seconds % 3600

    local minutes = math.floor(seconds / 60)

    local parts = {}
    if ( days > 0 ) then parts[#parts + 1] = tostring(days) .. "d" end
    if ( hours > 0 ) then parts[#parts + 1] = tostring(hours) .. "h" end
    if ( minutes > 0 ) then parts[#parts + 1] = tostring(minutes) .. "m" end

    if ( #parts == 0 ) then
        return "<1m"
    end

    return table.concat(parts, " ")
end

function MODULE:FormatBanTime(unixTime)
    unixTime = math.floor(tonumber(unixTime) or 0)
    if ( unixTime <= 0 ) then return "Never" end

    return os.date("%Y-%m-%d %H:%M:%S", unixTime)
end

function MODULE:BuildBanKickMessage(banData)
    banData = NormalizeBanRow(banData)
    if ( !banData ) then
        return "You are banned from this server."
    end

    local expires = banData.expires_at == 0 and "Never (permanent)" or self:FormatBanTime(banData.expires_at)

    return "You are banned from this server.\n"
        .. "Reason: " .. banData.reason .. "\n"
        .. "Expires: " .. expires .. "\n"
        .. "Ban ID: #" .. tostring(banData.id)
end

function MODULE:FormatBanSummary(banData)
    banData = NormalizeBanRow(banData)
    if ( !banData ) then return "Invalid ban row" end

    local state = "expired"
    if ( banData.revoked_at > 0 ) then
        state = "revoked"
    elseif ( self:IsBanActive(banData) ) then
        state = "active"
    end

    local expires = banData.expires_at == 0 and "Never" or self:FormatBanTime(banData.expires_at)

    return string.format(
        "#%d [%s] %s banned by %s on %s, expires %s: %s",
        banData.id,
        state,
        banData.name,
        banData.admin_name,
        self:FormatBanTime(banData.created_at),
        expires,
        banData.reason
    )
end

function MODULE:CanAccessBanPrivilege(client, privilege, target)
    if ( !ax.util:IsValidPlayer(client) ) then
        return true
    end

    if ( istable(CAMI) and isfunction(CAMI.PlayerHasAccess) ) then
        local hasAccess = CAMI.PlayerHasAccess(client, privilege, nil, target)
        if ( hasAccess != nil ) then
            return hasAccess == true
        end
    end

    return client:IsAdmin()
end

function MODULE:CreateBanTables(callback)
    if ( !istable(mysql) or !mysql:IsConnected() ) then
        NotifyCallback(callback, false, nil, "Database is not connected.")
        return
    end

    local query = mysql:Create(BAN_TABLE)
        query:Create("id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
        query:Create("steamid64", "VARCHAR(17) NOT NULL")
        query:Create("steamid", "VARCHAR(32) NOT NULL DEFAULT ''")
        query:Create("name", "VARCHAR(255) NOT NULL DEFAULT ''")
        query:Create("admin_steamid64", "VARCHAR(17) NOT NULL DEFAULT '0'")
        query:Create("admin_steamid", "VARCHAR(32) NOT NULL DEFAULT ''")
        query:Create("admin_name", "VARCHAR(255) NOT NULL DEFAULT 'Console'")
        query:Create("reason", "VARCHAR(512) NOT NULL DEFAULT ''")
        query:Create("created_at", "INT(11) UNSIGNED NOT NULL DEFAULT 0")
        query:Create("duration", "INT(11) UNSIGNED NOT NULL DEFAULT 0")
        query:Create("expires_at", "INT(11) UNSIGNED NOT NULL DEFAULT 0")
        query:Create("revoked_at", "INT(11) UNSIGNED NOT NULL DEFAULT 0")
        query:Create("revoked_by_steamid64", "VARCHAR(17) NOT NULL DEFAULT ''")
        query:Create("revoked_by_name", "VARCHAR(255) NOT NULL DEFAULT ''")
        query:Create("revoked_reason", "VARCHAR(512) NOT NULL DEFAULT ''")
        query:Create("modified_at", "INT(11) UNSIGNED NOT NULL DEFAULT 0")
        query:Create("modified_by_steamid64", "VARCHAR(17) NOT NULL DEFAULT ''")
        query:Create("modified_by_name", "VARCHAR(255) NOT NULL DEFAULT ''")
        query:Create("modify_reason", "VARCHAR(512) NOT NULL DEFAULT ''")
        query:PrimaryKey("id")
        query:Callback(function(_, status)
            self.banTableReady = status != false

            if ( !self.banTableReady ) then
                NotifyCallback(callback, false, nil, "Failed to create ban table.")
                return
            end

            self:RefreshActiveBanCache(function()
                NotifyCallback(callback, true)
            end)
        end)
    query:Execute()
end

function MODULE:EnsureBanTables(callback)
    if ( self.banTableReady ) then
        NotifyCallback(callback, true)
        return
    end

    self.banTableCallbacks[#self.banTableCallbacks + 1] = callback
    if ( self.banTableCreating ) then return end

    self.banTableCreating = true
    self:CreateBanTables(function(ok, _, err)
        self.banTableCreating = false

        local callbacks = self.banTableCallbacks or {}
        self.banTableCallbacks = {}

        for i = 1, #callbacks do
            NotifyCallback(callbacks[i], ok, nil, err)
        end
    end)
end

function MODULE:RefreshActiveBanCache(callback)
    if ( !istable(mysql) or !mysql:IsConnected() ) then
        NotifyCallback(callback, false, nil, "Database is not connected.")
        return
    end

    local unixTime = os.time()
    local query = "SELECT * FROM `" .. BAN_TABLE .. "` WHERE `revoked_at` = 0 AND (`expires_at` = 0 OR `expires_at` > ?)"
    mysql:RawQuery(query, function(result, status)
        if ( status == false or result == false ) then
            NotifyCallback(callback, false, nil, "Failed to refresh ban cache.")
            return
        end

        self.banActiveCache = {}

        result = istable(result) and result or {}
        for i = 1, #result do
            local row = NormalizeBanRow(result[i])
            if ( row and self:IsBanActive(row, unixTime) ) then
                self.banActiveCache[row.steamid64] = row
            end
        end

        NotifyCallback(callback, true, self.banActiveCache)
    end, nil, {unixTime})
end

function MODULE:GetCachedActiveBan(identifier)
    local steamID64 = self:NormalizeBanIdentifier(identifier)
    if ( !steamID64 ) then return nil end

    local banData = self.banActiveCache[steamID64]
    if ( self:IsBanActive(banData) ) then
        return banData
    end

    self.banActiveCache[steamID64] = nil
    return nil
end

function MODULE:GetBanByID(banID, callback)
    banID = math.floor(tonumber(banID) or 0)
    if ( banID <= 0 ) then
        NotifyCallback(callback, false, nil, "Invalid ban ID.")
        return
    end

    self:EnsureBanTables(function(ok, _, err)
        if ( !ok ) then
            NotifyCallback(callback, false, nil, err)
            return
        end

        local query = mysql:Select(BAN_TABLE)
            query:Where("id", banID)
            query:Limit(1)
            query:Callback(function(result, status)
                if ( status == false or result == false ) then
                    NotifyCallback(callback, false, nil, "Failed to query ban.")
                    return
                end

                local row = istable(result) and NormalizeBanRow(result[1]) or nil
                if ( !row ) then
                    NotifyCallback(callback, false, nil, "Ban not found.")
                    return
                end

                NotifyCallback(callback, true, row)
            end)
        query:Execute()
    end)
end

function MODULE:GetActiveBan(identifier, callback)
    local steamID64 = self:NormalizeBanIdentifier(identifier)
    if ( !steamID64 ) then
        NotifyCallback(callback, false, nil, "Invalid SteamID64.")
        return
    end

    local cachedBan = self:GetCachedActiveBan(steamID64)
    if ( cachedBan ) then
        NotifyCallback(callback, true, cachedBan)
        return
    end

    self:EnsureBanTables(function(ok, _, err)
        if ( !ok ) then
            NotifyCallback(callback, false, nil, err)
            return
        end

        local unixTime = os.time()
        local query = "SELECT * FROM `" .. BAN_TABLE .. "` WHERE `steamid64` = ? AND `revoked_at` = 0 AND (`expires_at` = 0 OR `expires_at` > ?) ORDER BY `created_at` DESC, `id` DESC LIMIT 1"
        mysql:RawQuery(query, function(result, status)
            if ( status == false or result == false ) then
                NotifyCallback(callback, false, nil, "Failed to query active ban.")
                return
            end

            local row = istable(result) and NormalizeBanRow(result[1]) or nil
            if ( !row or !self:IsBanActive(row, unixTime) ) then
                self.banActiveCache[steamID64] = nil
                NotifyCallback(callback, true, nil)
                return
            end

            self.banActiveCache[steamID64] = row
            NotifyCallback(callback, true, row)
        end, nil, {steamID64, unixTime})
    end)
end

function MODULE:GetBanHistory(identifier, callback, limit)
    local steamID64 = self:NormalizeBanIdentifier(identifier)
    if ( !steamID64 ) then
        NotifyCallback(callback, false, nil, "Invalid SteamID64.")
        return
    end

    self:EnsureBanTables(function(ok, _, err)
        if ( !ok ) then
            NotifyCallback(callback, false, nil, err)
            return
        end

        local query = mysql:Select(BAN_TABLE)
            query:Where("steamid64", steamID64)
            query:OrderByDesc("created_at")
            query:OrderByDesc("id")

            limit = math.floor(tonumber(limit) or 25)
            if ( limit > 0 ) then
                query:Limit(math.Clamp(limit, 1, 100))
            end

            query:Callback(function(result, status)
                if ( status == false or result == false ) then
                    NotifyCallback(callback, false, nil, "Failed to query ban history.")
                    return
                end

                local rows = {}
                result = istable(result) and result or {}

                for i = 1, #result do
                    rows[#rows + 1] = NormalizeBanRow(result[i])
                end

                NotifyCallback(callback, true, rows)
            end)
        query:Execute()
    end)
end

function MODULE:CreateBanBySteamID64(identifier, admin, minutes, reason, callback, data)
    local steamID64 = self:NormalizeBanIdentifier(identifier)
    if ( !steamID64 ) then
        NotifyCallback(callback, false, nil, "Invalid SteamID64.")
        return
    end

    data = istable(data) and data or {}
    minutes = NormalizeMinutes(minutes)
    reason = TrimText(reason, "No reason provided.")

    local actorData = GetActorData(admin)
    local now = os.time()
    local duration = minutes == 0 and 0 or minutes * 60
    local expiresAt = duration == 0 and 0 or now + duration
    local name = TrimText(data.name, "Unknown", 255)
    local steamID = TrimText(data.steamid, GetSteamIDFrom64(steamID64), 32)

    self:GetActiveBan(steamID64, function(ok, activeBan, err)
        if ( !ok ) then
            NotifyCallback(callback, false, nil, err)
            return
        end

        if ( activeBan ) then
            NotifyCallback(callback, false, activeBan, "That player is already banned (#" .. tostring(activeBan.id) .. ").")
            return
        end

        local query = mysql:Insert(BAN_TABLE)
            query:Insert("steamid64", steamID64)
            query:Insert("steamid", steamID)
            query:Insert("name", name)
            query:Insert("admin_steamid64", actorData.steamid64)
            query:Insert("admin_steamid", actorData.steamid)
            query:Insert("admin_name", actorData.name)
            query:Insert("reason", reason)
            query:Insert("created_at", now)
            query:Insert("duration", duration)
            query:Insert("expires_at", expiresAt)
            query:Insert("revoked_at", 0)
            query:Insert("revoked_by_steamid64", "")
            query:Insert("revoked_by_name", "")
            query:Insert("revoked_reason", "")
            query:Insert("modified_at", 0)
            query:Insert("modified_by_steamid64", "")
            query:Insert("modified_by_name", "")
            query:Insert("modify_reason", "")
            query:Callback(function(_, status, lastID)
                if ( status == false ) then
                    NotifyCallback(callback, false, nil, "Failed to create ban.")
                    return
                end

                local banData = NormalizeBanRow({
                    id = lastID,
                    steamid64 = steamID64,
                    steamid = steamID,
                    name = name,
                    admin_steamid64 = actorData.steamid64,
                    admin_steamid = actorData.steamid,
                    admin_name = actorData.name,
                    reason = reason,
                    created_at = now,
                    duration = duration,
                    expires_at = expiresAt,
                    revoked_at = 0,
                    revoked_by_steamid64 = "",
                    revoked_by_name = "",
                    revoked_reason = "",
                    modified_at = 0,
                    modified_by_steamid64 = "",
                    modified_by_name = "",
                    modify_reason = ""
                })

                self.banActiveCache[steamID64] = banData
                hook.Run("OnPlayerBanned", steamID64, banData, admin)

                NotifyCallback(callback, true, banData)
            end)
        query:Execute()
    end)
end

function MODULE:CreateBan(target, admin, minutes, reason, callback, options)
    if ( !ax.util:IsValidPlayer(target) ) then
        NotifyCallback(callback, false, nil, "Invalid target player.")
        return
    end

    options = istable(options) and options or {}

    self:CreateBanBySteamID64(target:SteamID64(), admin, minutes, reason, function(ok, banData, err)
        if ( ok and options.bKick == true and ax.util:IsValidPlayer(target) ) then
            target:Kick(self:BuildBanKickMessage(banData))
        end

        NotifyCallback(callback, ok, banData, err)
    end, {
        steamid = target:SteamID(),
        name = target:SteamName()
    })
end

function MODULE:RevokeBan(banID, admin, reason, callback)
    banID = math.floor(tonumber(banID) or 0)
    if ( banID <= 0 ) then
        NotifyCallback(callback, false, nil, "Invalid ban ID.")
        return
    end

    reason = TrimText(reason, "Unbanned by admin.")
    local actorData = GetActorData(admin)
    local now = os.time()

    self:GetBanByID(banID, function(ok, banData, err)
        if ( !ok ) then
            NotifyCallback(callback, false, nil, err)
            return
        end

        if ( !self:IsBanActive(banData, now) ) then
            NotifyCallback(callback, false, banData, "That ban is not active.")
            return
        end

        local query = mysql:Update(BAN_TABLE)
            query:Update("revoked_at", now)
            query:Update("revoked_by_steamid64", actorData.steamid64)
            query:Update("revoked_by_name", actorData.name)
            query:Update("revoked_reason", reason)
            query:Where("id", banID)
            query:Callback(function(_, status)
                if ( status == false ) then
                    NotifyCallback(callback, false, nil, "Failed to revoke ban.")
                    return
                end

                banData.revoked_at = now
                banData.revoked_by_steamid64 = actorData.steamid64
                banData.revoked_by_name = actorData.name
                banData.revoked_reason = reason

                self.banActiveCache[banData.steamid64] = nil
                hook.Run("OnPlayerUnbanned", banData.steamid64, banData, admin)

                NotifyCallback(callback, true, banData)
            end)
        query:Execute()
    end)
end

function MODULE:UnbanSteamID64(identifier, admin, reason, callback)
    local steamID64 = self:NormalizeBanIdentifier(identifier)
    if ( !steamID64 ) then
        NotifyCallback(callback, false, nil, "Invalid SteamID64.")
        return
    end

    self:GetActiveBan(steamID64, function(ok, banData, err)
        if ( !ok ) then
            NotifyCallback(callback, false, nil, err)
            return
        end

        if ( !banData ) then
            NotifyCallback(callback, false, nil, "That SteamID64 does not have an active ban.")
            return
        end

        self:RevokeBan(banData.id, admin, reason, callback)
    end)
end

function MODULE:ModifyBan(banID, admin, minutes, reason, callback)
    banID = math.floor(tonumber(banID) or 0)
    if ( banID <= 0 ) then
        NotifyCallback(callback, false, nil, "Invalid ban ID.")
        return
    end

    minutes = NormalizeMinutes(minutes)
    reason = TrimText(reason, "")

    local actorData = GetActorData(admin)
    local now = os.time()
    local duration = minutes == 0 and 0 or minutes * 60
    local expiresAt = duration == 0 and 0 or now + duration

    self:GetBanByID(banID, function(ok, banData, err)
        if ( !ok ) then
            NotifyCallback(callback, false, nil, err)
            return
        end

        if ( !self:IsBanActive(banData, now) ) then
            NotifyCallback(callback, false, banData, "Only active bans can be modified.")
            return
        end

        local newReason = reason != "" and reason or banData.reason
        local modifyReason = reason != "" and reason or "Duration modified."

        local query = mysql:Update(BAN_TABLE)
            query:Update("reason", newReason)
            query:Update("duration", duration)
            query:Update("expires_at", expiresAt)
            query:Update("modified_at", now)
            query:Update("modified_by_steamid64", actorData.steamid64)
            query:Update("modified_by_name", actorData.name)
            query:Update("modify_reason", modifyReason)
            query:Where("id", banID)
            query:Callback(function(_, status)
                if ( status == false ) then
                    NotifyCallback(callback, false, nil, "Failed to modify ban.")
                    return
                end

                banData.reason = newReason
                banData.duration = duration
                banData.expires_at = expiresAt
                banData.modified_at = now
                banData.modified_by_steamid64 = actorData.steamid64
                banData.modified_by_name = actorData.name
                banData.modify_reason = modifyReason

                self.banActiveCache[banData.steamid64] = banData
                hook.Run("OnPlayerBanModified", banData.steamid64, banData, admin)

                NotifyCallback(callback, true, banData)
            end)
        query:Execute()
    end)
end

function MODULE:ValidateClientBan(client, source)
    if ( !ax.util:IsValidPlayer(client) ) then return end

    self:GetActiveBan(client:SteamID64(), function(ok, banData)
        if ( !ok or !banData or !ax.util:IsValidPlayer(client) ) then return end

        ax.util:PrintWarning("Kicking banned player " .. client:SteamName() .. " from " .. tostring(source or "unknown") .. ".")
        client:Kick(self:BuildBanKickMessage(banData))
    end)
end

hook.Add("OnDatabaseTablesCreated", "ax.admin.bans.tables", function()
    if ( !istable(MODULE) or !isfunction(MODULE.EnsureBanTables) ) then return end

    MODULE:EnsureBanTables()
end)

timer.Simple(0, function()
    if ( !istable(MODULE) or !isfunction(MODULE.EnsureBanTables) ) then return end
    if ( !istable(mysql) or !mysql:IsConnected() ) then return end

    MODULE:EnsureBanTables()
end)
