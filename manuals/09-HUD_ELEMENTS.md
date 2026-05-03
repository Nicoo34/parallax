# HUD Elements and TargetID Tooltips

This manual explains the client-side `ax.elements` library in beginner-friendly terms.
It is mainly for module and schema developers who want to add HUD pieces or add extra
lines under the TargetID tooltip when a player looks at something.

The important file is:

```text
gamemode/framework/libraries/cl_elements.lua
```

## What problem does this solve?

Before `ax.elements`, modules usually added tooltip lines by implementing a paint hook
and manually doing all of this themselves:

- calculate line spacing
- count existing description lines
- draw text shadows
- draw text color and alpha
- wrap long text
- keep the line order correct

That is easy to get wrong and hard for beginners to copy safely.

Now, for normal TargetID tooltip additions, you only return a table of lines.
The framework handles the drawing.

## The simplest tooltip line

Use `GetTargetIDLines(entity)` in your module or schema.

```lua
local MODULE = MODULE

function MODULE:GetTargetIDLines(entity)
    if ( !IsValid(entity) ) then return end
    if ( entity:GetClass() != "my_entity" ) then return end

    return {
        {
            text = "Press E to use this.",
            color = Color(255, 255, 255),
        },
    }
end
```

That is all you need for one line.

The framework will:

- place the line under the TargetID name
- add a shadow
- apply the current TargetID alpha
- wrap long text
- use the configured TargetID line spacing

## Multiple lines

Return more line tables.

```lua
function MODULE:GetTargetIDLines(entity)
    if ( entity:GetClass() != "my_vendor" ) then return end

    return {
        {
            text = "Vendor",
            color = Color(120, 200, 255),
        },
        {
            text = "Sells basic supplies.",
            color = Color(220, 220, 220),
        },
    }
end
```

## Example: door-style tooltip

This is the pattern used by the doors module.

```lua
function MODULE:GetTargetIDLines(entity)
    if ( !entity:IsDoor() ) then return end

    local lines = {}
    local bLocked = entity:GetRelay("locked", false)

    lines[#lines + 1] = {
        text = bLocked and "Locked" or "Unlocked",
        color = bLocked and Color(200, 80, 80) or Color(180, 220, 180),
    }

    if ( entity:GetRelay("purchased", false) ) then
        lines[#lines + 1] = {
            text = "Privately owned",
            color = Color(220, 160, 60),
        }
    else
        lines[#lines + 1] = {
            text = "For sale",
            color = Color(180, 180, 180),
        }
    end

    return lines
end
```

## Line table fields

Each line can use these fields:

```lua
{
    text = "Text to draw",          -- required
    color = Color(255, 255, 255),   -- optional
    font = "ax.small",             -- optional
    maxWidth = 256,                 -- optional, in screen pixels
    bNoWrap = false,                -- optional, disables wrapping
}
```

Most modules only need `text` and `color`.

## Returning plain strings

For very simple cases, a line can be a string.

```lua
function MODULE:GetTargetIDLines(entity)
    if ( entity:GetClass() != "my_entity" ) then return end

    return {
        "A simple white tooltip line.",
    }
end
```

## Changing the main TargetID name

Use `GetEntityDisplayText(entity)` when you want to change the title/name shown above
the extra lines.

```lua
function MODULE:GetEntityDisplayText(entity)
    if ( entity:GetClass() != "my_entity" ) then return end

    return "Storage Crate", Color(150, 220, 255)
end
```

Return values are:

```lua
return displayText, displayColor, bShouldFlash
```

- `displayText` is the title text.
- `displayColor` is the title color.
- `bShouldFlash` makes the title softly pulse toward white.

## Entity-provided extras

If you control the entity itself, you can also define `GetDisplayDescriptionExtras()`
on the entity and return the same simple line tables.

```lua
function ENT:GetDisplayDescriptionExtras()
    return {
        {
            text = "Stored items: " .. self:GetItemCount(),
            color = Color(200, 220, 255),
        },
    }
end
```

This is useful when the tooltip belongs to the entity more than to a module hook.

## Full HUD elements

`GetTargetIDLines` is for adding TargetID tooltip lines. If you need a completely new
HUD element, register one with `ax.elements:Register`.

```lua
ax.elements:Register("myElement", {
    order = 200,
    option = "my_element.enabled",
    Paint = function(self, context)
        draw.SimpleText("Hello HUD", "ax.small", 16, 16, color_white)
    end,
})
```

The `context` table includes:

```lua
context.client     -- Local player
context.width      -- ScrW()
context.height     -- ScrH()
context.frameTime  -- FrameTime()
context.curTime    -- CurTime()
```

For most beginner modules, prefer `GetTargetIDLines` over a full custom HUD element.

## User options

Players can customize TargetID behavior through the regular options system.
The framework includes options for:

- enabling/disabling framework HUD elements
- enabling/disabling TargetID labels
- TargetID trace distance
- fade-in and fade-out speed
- follow speed
- description width
- line spacing
- visibility delay
- player/ragdoll vertical offset
- flashing speed
- showing descriptions
- showing extra lines

## Best practices

### Do

- Use `GetTargetIDLines(entity)` for normal tooltip additions.
- Return simple line tables with `text` and `color`.
- Use localization phrases for player-facing text when possible.
- Use guard clauses so unrelated entities return early.

```lua
function MODULE:GetTargetIDLines(entity)
    if ( !IsValid(entity) ) then return end
    if ( entity:GetClass() != "my_entity" ) then return end

    return {
        {
            text = ax.localization:GetPhrase("my_module.tooltip.ready"),
            color = Color(100, 220, 100),
        },
    }
end
```

### Do not

- Do not use the old `HUDPaintTargetIDExtra` hook. It has been removed.
- Do not manually call `draw.SimpleText` for normal TargetID tooltip lines.
- Do not duplicate line wrapping or line-count logic in modules.
- Do not assume your line is the only line being drawn.

## Migration from old tooltip paint code

Old style:

```lua
function MODULE:HUDPaintTargetIDExtra(entity, x, y, alpha)
    if ( entity:GetClass() != "my_entity" ) then return end

    draw.SimpleText("Ready", "ax.small", x + 1, y + 7, Color(0, 0, 0, alpha / 4), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Ready", "ax.small", x, y + 6, Color(100, 220, 100, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
```

New style:

```lua
function MODULE:GetTargetIDLines(entity)
    if ( entity:GetClass() != "my_entity" ) then return end

    return {
        {
            text = "Ready",
            color = Color(100, 220, 100),
        },
    }
end
```

The new style is shorter, safer, and automatically follows framework settings.