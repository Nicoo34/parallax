local MODULE = MODULE

function MODULE:GetEntityDisplayText(entity)
    if ( !entity:IsDoor() ) then return end

    local name = ax.localization:GetPhrase("door")
    local color = Color(255, 255, 255)

    if ( IsValid(ax.client) and ax.client:HasDoorAccess(entity) ) then
        color = Color(100, 200, 100)
    elseif ( entity:GetRelay("locked", false) ) then
        color = Color(200, 100, 100)
    end

    return name, color
end

function MODULE:GetTargetIDLines(entity)
    if ( !entity:IsDoor() ) then return end

    local lines = {}

    local bLocked = entity:GetRelay("locked", false)
    lines[#lines + 1] = {
        text = bLocked and "Locked" or "Unlocked",
        color = bLocked and Color(200, 80, 80) or Color(180, 220, 180),
    }

    local bPurchased = entity:GetRelay("purchased", false)
    local bOwnable = entity:GetRelay("ownable", true)
    local localChar = IsValid(ax.client) and ax.client:GetCharacter() or nil
    local owner = entity:GetDoorOwner()
    local bOwnedByMe = localChar and owner and owner == localChar

    if ( bPurchased ) then
        if ( bOwnedByMe ) then
            lines[#lines + 1] = {
                text = "Owned by you",
                color = Color(100, 200, 100),
            }
        else
            lines[#lines + 1] = {
                text = "Privately owned",
                color = Color(220, 160, 60),
            }
        end
    elseif ( bOwnable ) then
        local cost = ax.config:Get("doors.purchase_cost", 10)
        lines[#lines + 1] = {
            text = "For sale - " .. ax.currencies:Format(cost),
            color = Color(180, 180, 180),
        }
    else
        lines[#lines + 1] = {
            text = "Not for sale",
            color = Color(140, 140, 140),
        }
    end

    if ( !bOwnedByMe and IsValid(ax.client) and ax.client:HasDoorAccess(entity) ) then
        lines[#lines + 1] = {
            text = "You have access",
            color = Color(100, 160, 220),
        }
    end

    return lines
end
