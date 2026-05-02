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
local MAX_SEARCH_LENGTH = 96
local DEFAULT_PAGE_SIZE = 18
local MAX_PAGE_SIZE = 72

local validFilters = {
    all = true,
    active = true,
    permanent = true,
    expired = true,
    revoked = true
}

local function TrimSearch(search)
    search = string.Trim(tostring(search or ""))
    if ( #search > MAX_SEARCH_LENGTH ) then
        search = string.sub(search, 1, MAX_SEARCH_LENGTH)
    end

    return search
end

local function NormalizePage(page, pageSize)
    page = math.max(math.floor(tonumber(page) or 1), 1)
    pageSize = math.floor(tonumber(pageSize) or DEFAULT_PAGE_SIZE)
    pageSize = math.Clamp(pageSize, 1, MAX_PAGE_SIZE)

    return page, pageSize
end

local function SendError(client, message, nonce)
    ax.net:Start(client, "admin.bans.error", {
        message = tostring(message or "Unknown ban management error."),
        nonce = tonumber(nonce) or 0
    })
end

local function SendActionResult(client, ok, message, nonce, banData)
    ax.net:Start(client, "admin.bans.action_result", {
        ok = ok == true,
        message = tostring(message or ""),
        nonce = tonumber(nonce) or 0,
        ban = istable(banData) and MODULE:NormalizeBanRow(table.Copy(banData)) or nil
    })
end

local function HasAccess(client, privilege, nonce)
    if ( MODULE:CanAccessBanPrivilege(client, privilege) ) then
        return true
    end

    SendError(client, "You do not have permission to manage bans.", nonce)
    return false
end

local function FetchBanRows(callback)
    if ( !isfunction(callback) ) then return end

    MODULE:EnsureBanTables(function(ok, _, err)
        if ( !ok ) then
            callback(nil, err or "Ban table is not ready.")
            return
        end

        local query = mysql:Select(BAN_TABLE)
            query:OrderByDesc("created_at")
            query:OrderByDesc("id")
            query:Callback(function(result, status)
                if ( status == false or result == false ) then
                    callback(nil, "Failed to query ban rows.")
                    return
                end

                local rows = {}
                result = istable(result) and result or {}

                for i = 1, #result do
                    local row = MODULE:NormalizeBanRow(result[i])
                    if ( row ) then
                        rows[#rows + 1] = row
                    end
                end

                callback(rows)
            end)
        query:Execute()
    end)
end

local function BuildStatus(row)
    local status = MODULE:GetBanStatus(row)
    if ( status == "active" and tonumber(row.expires_at) == 0 ) then
        return "permanent"
    end

    return status
end

local function RowMatchesFilter(row, filter)
    if ( filter == "all" ) then return true end

    return BuildStatus(row) == filter
end

local function RowMatchesSearch(row, search)
    if ( search == "" ) then return true end

    return ax.util:SearchMatches(search,
        row.id,
        row.name,
        row.steamid64,
        row.steamid,
        row.admin_name,
        row.reason,
        row.revoked_by_name,
        row.revoked_reason,
        row.modified_by_name,
        row.modify_reason
    )
end

local function BuildStats(rows)
    local stats = {
        total = 0,
        active = 0,
        permanent = 0,
        expired = 0,
        revoked = 0
    }

    if ( !istable(rows) ) then
        return stats
    end

    stats.total = #rows

    for i = 1, #rows do
        local status = BuildStatus(rows[i])
        if ( status == "permanent" ) then
            stats.permanent = stats.permanent + 1
            stats.active = stats.active + 1
        elseif ( status == "active" ) then
            stats.active = stats.active + 1
        elseif ( status == "expired" ) then
            stats.expired = stats.expired + 1
        elseif ( status == "revoked" ) then
            stats.revoked = stats.revoked + 1
        end
    end

    return stats
end

local function BuildListRowPayload(row)
    local status = BuildStatus(row)

    return {
        id = tonumber(row.id) or 0,
        steamid64 = row.steamid64,
        steamid = row.steamid,
        name = row.name,
        reason = row.reason,
        admin_name = row.admin_name,
        created_at = tonumber(row.created_at) or 0,
        duration = tonumber(row.duration) or 0,
        expires_at = tonumber(row.expires_at) or 0,
        revoked_at = tonumber(row.revoked_at) or 0,
        status = status,
        status_text = string.upper(status),
        is_active = MODULE:IsBanActive(row),
        is_online = player.GetBySteamID64(row.steamid64) != false and ax.util:IsValidPlayer(player.GetBySteamID64(row.steamid64))
    }
end

local function BuildDetailPayload(row, history)
    local payload = BuildListRowPayload(row)

    payload.admin_steamid64 = row.admin_steamid64
    payload.admin_steamid = row.admin_steamid
    payload.revoked_by_steamid64 = row.revoked_by_steamid64
    payload.revoked_by_name = row.revoked_by_name
    payload.revoked_reason = row.revoked_reason
    payload.modified_at = tonumber(row.modified_at) or 0
    payload.modified_by_steamid64 = row.modified_by_steamid64
    payload.modified_by_name = row.modified_by_name
    payload.modify_reason = row.modify_reason
    payload.history = {}

    history = istable(history) and history or {}
    for i = 1, #history do
        local historyRow = MODULE:NormalizeBanRow(history[i])
        if ( historyRow and historyRow.id != payload.id ) then
            payload.history[#payload.history + 1] = BuildListRowPayload(historyRow)
        end

        if ( #payload.history >= 6 ) then
            break
        end
    end

    return payload
end

local function Paginate(rows, page, pageSize)
    local total = istable(rows) and #rows or 0
    local pageCount = math.max(math.ceil(math.max(total, 1) / pageSize), 1)
    page = math.Clamp(page, 1, pageCount)

    local startIndex = ((page - 1) * pageSize) + 1
    local endIndex = math.min(startIndex + pageSize - 1, total)

    local output = {}
    for i = startIndex, endIndex do
        output[#output + 1] = rows[i]
    end

    return output, total, pageCount
end

ax.net:Hook("admin.bans.request_list", function(client, payload)
    payload = istable(payload) and payload or {}

    local nonce = tonumber(payload.nonce) or 0
    if ( !HasAccess(client, "Parallax - View Bans", nonce) ) then return end

    local page, pageSize = NormalizePage(payload.page, payload.page_size)
    local search = TrimSearch(payload.search)
    local filter = tostring(payload.filter or "active")
    if ( !validFilters[filter] ) then
        filter = "active"
    end

    FetchBanRows(function(rows, err)
        if ( !istable(rows) ) then
            SendError(client, err or "Failed to fetch bans.", nonce)
            return
        end

        local stats = BuildStats(rows)
        local filtered = {}

        for i = 1, #rows do
            local row = rows[i]
            if ( RowMatchesFilter(row, filter) and RowMatchesSearch(row, search) ) then
                filtered[#filtered + 1] = row
            end
        end

        local pageRows, totalRows, pageCount = Paginate(filtered, page, pageSize)
        local outRows = {}

        for i = 1, #pageRows do
            outRows[#outRows + 1] = BuildListRowPayload(pageRows[i])
        end

        ax.net:Start(client, "admin.bans.list", {
            nonce = nonce,
            search = search,
            filter = filter,
            page = page,
            page_size = pageSize,
            page_count = pageCount,
            total_rows = totalRows,
            rows = outRows,
            stats = stats,
            generated_at = os.time()
        })
    end)
end)

ax.net:Hook("admin.bans.request_detail", function(client, payload)
    payload = istable(payload) and payload or {}

    local nonce = tonumber(payload.nonce) or 0
    if ( !HasAccess(client, "Parallax - View Bans", nonce) ) then return end

    local banID = math.floor(tonumber(payload.id) or 0)
    if ( banID <= 0 ) then
        SendError(client, "Invalid ban ID.", nonce)
        return
    end

    MODULE:GetBanByID(banID, function(ok, banData, err)
        if ( !ok or !istable(banData) ) then
            SendError(client, err or "Ban not found.", nonce)
            return
        end

        MODULE:GetBanHistory(banData.steamid64, function(historyOk, historyRows)
            if ( !historyOk ) then
                historyRows = {}
            end

            ax.net:Start(client, "admin.bans.detail", {
                nonce = nonce,
                ban = BuildDetailPayload(banData, historyRows)
            })
        end, 8)
    end)
end)

ax.net:Hook("admin.bans.create", function(client, payload)
    payload = istable(payload) and payload or {}

    local nonce = tonumber(payload.nonce) or 0
    if ( !HasAccess(client, "Parallax - Ban Offline Players", nonce) ) then return end

    local identifier = tostring(payload.steamid64 or "")
    local minutes = math.floor(tonumber(payload.minutes) or 0)
    local reason = string.Trim(tostring(payload.reason or ""))

    MODULE:CreateBanBySteamID64(identifier, client, minutes, reason, function(ok, banData, err)
        if ( !ok ) then
            SendActionResult(client, false, err or "Failed to create ban.", nonce, banData)
            return
        end

        local onlineTarget = player.GetBySteamID64(banData.steamid64)
        if ( ax.util:IsValidPlayer(onlineTarget) ) then
            onlineTarget:Kick(MODULE:BuildBanKickMessage(banData))
        end

        SendActionResult(client, true, "Ban #" .. tostring(banData.id) .. " has been created.", nonce, banData)
    end)
end)

ax.net:Hook("admin.bans.modify", function(client, payload)
    payload = istable(payload) and payload or {}

    local nonce = tonumber(payload.nonce) or 0
    if ( !HasAccess(client, "Parallax - Modify Bans", nonce) ) then return end

    local banID = math.floor(tonumber(payload.id) or 0)
    local minutes = math.floor(tonumber(payload.minutes) or 0)
    local reason = string.Trim(tostring(payload.reason or ""))

    MODULE:ModifyBan(banID, client, minutes, reason, function(ok, banData, err)
        if ( !ok ) then
            SendActionResult(client, false, err or "Failed to modify ban.", nonce, banData)
            return
        end

        SendActionResult(client, true, "Ban #" .. tostring(banData.id) .. " has been modified.", nonce, banData)
    end)
end)

ax.net:Hook("admin.bans.revoke", function(client, payload)
    payload = istable(payload) and payload or {}

    local nonce = tonumber(payload.nonce) or 0
    if ( !HasAccess(client, "Parallax - Unban Players", nonce) ) then return end

    local banID = math.floor(tonumber(payload.id) or 0)
    local reason = string.Trim(tostring(payload.reason or ""))

    MODULE:RevokeBan(banID, client, reason, function(ok, banData, err)
        if ( !ok ) then
            SendActionResult(client, false, err or "Failed to revoke ban.", nonce, banData)
            return
        end

        SendActionResult(client, true, "Ban #" .. tostring(banData.id) .. " has been revoked.", nonce, banData)
    end)
end)