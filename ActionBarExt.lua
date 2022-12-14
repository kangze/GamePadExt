local addonName, addonTable = ...

local E=addonTable.E;

local StatusTrackingBarManager=StatusTrackingBarManager;
local MainMenuBar=MainMenuBar;
local MultiBarBottomLeft=MultiBarBottomLeft;


function E:ActionBarExt()
    local frame = CreateFrame("Frame", nil, MainMenuBar);
    frame:SetMovable(true);
    frame:SetPoint("TOPLEFT", -7, 4)
    frame:SetFrameStrata("BACKGROUND");
    frame.tex2 = frame:CreateTexture();
    frame.tex2:SetAllPoints(frame);
    frame.tex2:SetTexture("Interface/MAINMENUBAR/MainMenuBar", "CLAMPTOWHITE");
    frame.tex2:SetTexCoord(0.16, 0.94, 0.39, 0.58);
    frame:SetPoint("BOTTOM", MainMenuBar, 162, -3);
    C_Timer.NewTimer(2,function()
        MultiBarBottomLeft:ClearAllPoints();
        MultiBarBottomLeft:SetPoint("LEFT",MainMenuBar,"RIGHT",-4,-2)
    end);

    for k,v in pairs(StatusTrackingBarManager) do
        if(type(v) ~= 'function' and type(v) ~= 'userdata' and v.SetWidth) then 
            v:SetWidth(895) 
        end
    end
    
    StatusTrackingBarManager:ClearAllPoints();
    StatusTrackingBarManager:SetPoint("BOTTOM",-90,50)

    --声望条
    -- local frame1 = CreateFrame("Frame", nil, UIParent);
    -- frame1:SetSize(895, 10);
    -- frame1:SetPoint("BOTTOM", 0, 56)
    -- frame1:SetMovable(true);
    -- frame1:SetPoint("CENTER");
    -- frame1.tex2 = frame:CreateTexture();
    -- frame1.tex2:SetAllPoints(frame1);
    -- frame1.tex2:SetTexture("Interface/MAINMENUBAR/MainMenuBar", "CLAMPTOWHITE");
    -- frame1.tex2:SetSize(895, 450);
    -- frame1.tex2:SetTexCoord(0.16, 0.94, 0.33, 0.38);

    -- StatusTrackingBarManager:SetWidth(895);
    -- StatusTrackingBarManager:ClearAllPoints();
    -- StatusTrackingBarManager:SetParent(UIParent);
    
    -- StatusTrackingBarManager:SetPoint("BOTTOM");
    
    
end

function E:SetNewPanel()
    --MainMenuBar.EndCaps.LeftEndCap:Hide();
    --MainMenuBar.EndCaps.RightEndCap:Hide();

    -- StatusTrackingBarManager:SetMovable(false);
    -- StatusTrackingBarManager:EnableMouse(false);
    -- StatusTrackingBarManager:RegisterForDrag("LeftButton");
    -- StatusTrackingBarManager:SetScript("OnDragStart", function(self) self:StartMoving() end);
    -- StatusTrackingBarManager:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end);
    -- for k,v in pairs(StatusTrackingBarManager) do
    --     if(type(v) ~= 'function' and type(v) ~= 'userdata' and v.SetWidth) then v:SetWidth(895) end
    -- end

    -- 小眼睛
    -- QueueStatusButton:SetMovable(true);
    -- QueueStatusButton:EnableMouse(true);
    -- QueueStatusButton:RegisterForDrag("LeftButton");
    -- QueueStatusButton:SetScript("OnDragStart", function(self) self:StartMoving() end);
    -- QueueStatusButton:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end);

end