local addonName, addonTable = ...

local E=addonTable.E;

function E:OnLoad()
    self:LoadOldBlizzardActionBar();
    self:LoadTrackingBar();
end


function E:SetNewPanel()
    -- 小眼睛
    -- QueueStatusButton:SetMovable(true);
    -- QueueStatusButton:EnableMouse(true);
    -- QueueStatusButton:RegisterForDrag("LeftButton");
    -- QueueStatusButton:SetScript("OnDragStart", function(self) self:StartMoving() end);
    -- QueueStatusButton:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end);

end