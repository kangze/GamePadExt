local _, Addon = ...;


local function SoftTargetChanged(eventName, ...)
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    GameTooltip:SetUnit("softenemy");
    GameTooltip:Show()
end

local function SoftTargetChanged2(eventName, ...)
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    local name = UnitName("softinteract");
    local level = UnitLevel("softinteract");
    if (level == 0) then
        GameTooltip:SetText(name);
        GameTooltip:Show()
    else
        GameTooltip:SetUnit("softinteract");
        GameTooltip:Show();
    end
end



function Addon:OnLoad_SoftTargetTooltip()
    local GamePadExtAddon = Addon.GamePadExtAddon;
    GamePadExtAddon:RegisterEvent("PLAYER_SOFT_INTERACT_CHANGED", SoftTargetChanged2)
    GamePadExtAddon:RegisterEvent("PLAYER_SOFT_ENEMY_CHANGED", SoftTargetChanged)
end
