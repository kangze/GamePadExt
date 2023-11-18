local _, AddonData = ...;
local Gpe = _G["Gpe"];

local SoftTargetToolipModule = Gpe:GetModule('SoftTargetToolipModule')

function SoftTargetToolipModule:OnLoad_SoftTargetTooltip()
    self:RegisterEvent("PLAYER_SOFT_INTERACT_CHANGED", self.SoftTargetChanged2)
    self:RegisterEvent("PLAYER_SOFT_ENEMY_CHANGED", self.SoftTargetChanged)
end

function SoftTargetToolipModule:SoftTargetChanged(eventName, ...)
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    GameTooltip:SetUnit("softenemy");
    GameTooltip:Show()
end

function SoftTargetToolipModule:SoftTargetChanged2(eventName, ...)
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
