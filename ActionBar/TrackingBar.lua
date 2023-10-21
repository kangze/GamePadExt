local _, Addon = ...
local StatusTrackingBarManager=StatusTrackingBarManager;


function Addon:OnLoad_TrackingBar()
    for _,v in pairs(StatusTrackingBarManager) do
        if(type(v) ~= 'function' and type(v) ~= 'userdata' and v.SetWidth) then 
            v:SetWidth(1000);
            v:ClearAllPoints();
            v:SetPoint("BOTTOM",UIParent,"BOTTOM",0,50);
        end
    end
    

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