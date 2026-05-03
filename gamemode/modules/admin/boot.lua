local MODULE = MODULE

MODULE.name = "Admin"
MODULE.description = "Handles admin-related functionality."
MODULE.author = "riggs9162"

ax.admin = MODULE

for lang, phrases in pairs(ax.localization.langs or {}) do
    local configLabel = istable(phrases) and phrases["tab.config"]
    if ( isstring(configLabel) and configLabel != "" ) then
        ax.localisation:AddPhrase(lang, "tab.admin.config", configLabel)
    end
end
