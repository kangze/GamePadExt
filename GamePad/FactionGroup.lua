local _, addon = ...


local FactionGroupMixin = {};

--name:Faction
local function CreateFactionGroup(index, frame, parentFrame, description)
    local group = addon.CreateGamePadGroup("Faction", index, frame, parentFrame, description);
    group.leftGroupName = "Expansion";
    group.rightGroupName = "FactionItem";

    for k, v in pairs(FactionGroupMixin) do
        group[k] = v;
    end
    return group;
end

function FactionGroupMixin:NavgateY(y)
    local name = "";
    if (y < 0) then
        name = self.leftGroupName;
    else
        name = self.rightGroupName;
    end
    local group = addon.GetGamePadGroup(name, 1);
    if (group) then
        group:OnEnter();
    end
end

addon.CreateFactionGroup = CreateFactionGroup;
