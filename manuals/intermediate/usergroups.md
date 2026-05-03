# Usergroups

This guide explains **what the Parallax usergroup system is**, **how it works**, and **how to extend it**.
It is written for beginner schema developers and server owners who are new to the framework.

---

## 1. What is a usergroup?

Usergroups are *staff roles* (e.g. `admin`, `superadmin`) used to control who can run admin commands, open admin tools, or manage other players.

Parallax has its own usergroup registry **and** keeps it compatible with:

- Garry's Mod `Player:IsAdmin()` / `Player:IsSuperAdmin()`
- CAMI (Common Admin Mod Interface)

That means you can still use normal GMod admin checks, while Parallax keeps consistent data and hierarchy rules.

---

## 2. Where usergroup data is stored

Parallax persists usergroups in the database table:

```
ax_players.usergroup
```

It is also registered as a player var:

```
ax.player:RegisterVar("usergroup")
```

When a player becomes ready, the admin module calls:

```
ax.admin:SyncPlayerUsergroup(client)
```

This writes the stored group into GMod runtime with `Player:SetUserGroup()`, so all standard GMod checks stay valid.

---

## 3. Built-in usergroups

| Usergroup | Level | Immunity | Inherits | Color |
| --- | ---: | ---: | --- | --- |
| `user` | 0 | 0 | none | `Color(94, 196, 110)` |
| `operator` | 25 | 25 | `user` | `Color(128, 164, 226)` |
| `admin` | 50 | 50 | `operator` | `Color(226, 124, 96)` |
| `superadmin` | 100 | 100 | `admin` | `Color(203, 109, 255)` |

**Level** controls what you can *assign*.
**Immunity** controls who you can *target*.
**Color** controls how the group is accented in the admin usergroups UI.

---

## 4. First-time setup (important!)

### Listen server host
Listen server hosts are automatically forced to `superadmin`.

### Dedicated server
Use the server console to bootstrap your first admin:

```
ax_player_set_usergroup "player" "superadmin"
```

After that, use in-game commands:

```
/PlySetUsergroup "player" "usergroup"
```

---

## 5. Admin commands

### Online changes
```
/PlySetUsergroup "player" "usergroup"
```
Sets an online player's usergroup.

```
/PlyGetUsergroup "player"
```
Shows the player's current group.

### Offline changes
```
/PlySetUsergroupID "steamid64" "usergroup"
```
Updates stored usergroup for an offline player.

### Listing groups
```
/UsergroupList
/UsergroupInfo "usergroup"
```
Prints registered groups and details.

---

## 6. Safety rules

Parallax blocks unsafe actions automatically:

- Players cannot change **their own** usergroup.
- Players cannot manage **equal or higher immunity** targets.
- Players cannot assign a group **above their own level**.
- Listen server hosts are always `superadmin`.
- Ambiguous or unknown usergroup names are rejected.

These checks are enforced inside:

```
ax.admin:CanManageUsergroup(actor, target, usergroup)
```

---

## 7. Creating custom usergroups

You can register custom groups inside your schema or a module:

```lua
ax.admin:RegisterUsergroup("leadadmin", {
    name = "Lead Admin",
    description = "Senior staff with broad access.",
    level = 75,
    immunity = 75,
    inherits = "admin",
    color = Color(255, 190, 80),
})
```

**Recommended fields:**

- `name` → display name
- `description` → optional help text
- `level` → access level (higher = more power)
- `immunity` → targeting protection
- `inherits` → parent group (usually `admin` or `superadmin`)
- `color` → UI accent color shown in the admin usergroups panel
- `bProtected` → prevent removal or downgrade

The `color` field should be a normal GLua `Color(r, g, b)` or `Color(r, g, b, a)` value. It does **not** grant permissions or change hierarchy rules; it only controls display styling. If a custom group does not define a valid color, the admin UI uses a neutral fallback.

---

## 8. Checking usergroup access in code

```lua
local group = ax.admin:GetPlayerUsergroup(player)
local level = ax.admin:GetPlayerUsergroupLevel(player)

if ( ax.admin:UsergroupInherits(group, "admin") ) then
    -- player is admin or higher
end
```

To test if someone can manage a target:

```lua
local ok, err = ax.admin:CanManageUsergroup(actor, target, "admin")
if ( !ok ) then
    actor:Notify(err, "error")
end
```

---

## 9. Summary

- Usergroups are stored in the database and mirrored to GMod runtime.
- Commands are provided to manage groups safely.
- You can register new groups with levels, immunity, inheritance, and UI colors.
- CAMI integration keeps Parallax compatible with external admin mods.

If you're new to Parallax, start with built-in groups and add custom tiers later.
