local _,Addon=...;

local Faction={};



function Faction:Create(config)
    local factionId=config.factionId;
    local minValue=0;
    local maxValue=0;
    local currentValue=0;
    local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfoByID(factionId);
    minValue=0;
    maxValue=barMax;
    currentValue=barValue;
    local frame = CreateFrame("Frame",nil,UIParent,"FactionTemplate");
    if(C_Reputation.IsMajorFaction(config.factionId)) then
        local level=C_MajorFactions.GetCurrentRenownLevel(config.factionId);
        local data = C_MajorFactions.GetMajorFactionData(config.factionId)
        maxValue=2500;
        currentValue=data.renownReputationEarned;
        frame.font_level:SetText(level);
    end
    frame.font_name:SetText(name);
    frame.statusbaar:SetMinMaxValues(minValue,maxValue);
    frame.statusbaar:SetValue(currentValue);
    return frame;
end

Addon.Faction=Faction;