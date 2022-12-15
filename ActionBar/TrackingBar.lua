local addonName, addonTable = ...

local E=addonTable.E;
local StatusTrackingBarManager=StatusTrackingBarManager;

function E:LoadTrackingBar()
    for _,v in pairs(StatusTrackingBarManager) do
        if(type(v) ~= 'function' and type(v) ~= 'userdata' and v.SetWidth) then 
            v:SetWidth(895);
        end
    end

    StatusTrackingBarManager:ClearAllPoints();
    StatusTrackingBarManager:SetPoint("BOTTOM",-90,50);

    -- set trackingBarManager movable
    -- StatusTrackingBarManager:SetMovable(false);
    -- StatusTrackingBarManager:EnableMouse(false);
    -- StatusTrackingBarManager:RegisterForDrag("LeftButton");
    -- StatusTrackingBarManager:SetScript("OnDragStart", function(self) self:StartMoving() end);
    -- StatusTrackingBarManager:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end);
    -- for k,v in pairs(StatusTrackingBarManager) do
    --     if(type(v) ~= 'function' and type(v) ~= 'userdata' and v.SetWidth) then v:SetWidth(895) end
    -- end
end