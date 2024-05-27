local _, AddonData = ...;
local Gpe = _G["Gpe"];

local SoftTargetToolipModule = Gpe:GetModule('SoftTargetToolipModule')

function SoftTargetToolipModule:OnInitialize()
    print("test");
    self:RegisterEvent("PLAYER_SOFT_INTERACT_CHANGED")
    self:RegisterEvent("PLAYER_SOFT_ENEMY_CHANGED")
end

function SoftTargetToolipModule:PLAYER_SOFT_INTERACT_CHANGED(eventName, ...)
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
    GameTooltip:SetUnit("softenemy");
    GameTooltip:Show()
end

function SoftTargetToolipModule:PLAYER_SOFT_ENEMY_CHANGED(eventName, ...)
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    local name = UnitName("softinteract");
    local level = UnitLevel("softinteract");
    print(12);
    if (level == 0 and name) then
        GameTooltip:SetText(name);
        GameTooltip:Show()
    else
        GameTooltip:SetUnit("softenemy");
        GameTooltip:Show();
    end
end
