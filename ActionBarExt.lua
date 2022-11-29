local addonName, addonTable = ...

local E=addonTable.E;

local StatusTrackingBarManager=StatusTrackingBarManager;
local MainMenuBar=MainMenuBar;
function E:ActionBarExt()
    local frame = CreateFrame("Frame", nil, UIParent);
    frame:SetSize(895, 58);
    frame:SetMovable(true);
    frame:SetPoint("BOTTOM", 6, 0)
    frame.tex2 = frame:CreateTexture();
    frame.tex2:SetAllPoints(frame);
    frame.tex2:SetTexture("Interface/MAINMENUBAR/MainMenuBar", "CLAMPTOWHITE");
    frame.tex2:SetSize(895, 58);
    frame.tex2:SetTexCoord(0.16, 0.94, 0.39, 0.58);
    frame:SetPoint("BOTTOM", MainMenuBar, 162, -3);
    


    --声望条
    local frame1 = CreateFrame("Frame", nil, UIParent);
    frame1:SetSize(895, 10);
    frame1:SetPoint("BOTTOM", 0, 56)
    frame1:SetMovable(true);
    frame1:SetPoint("CENTER");
    frame1.tex2 = frame:CreateTexture();
    frame1.tex2:SetAllPoints(frame1);
    frame1.tex2:SetTexture("Interface/MAINMENUBAR/MainMenuBar", "CLAMPTOWHITE");
    frame1.tex2:SetSize(895, 450);
    frame1.tex2:SetTexCoord(0.16, 0.94, 0.33, 0.38);

    StatusTrackingBarManager:SetWidth(895);
    StatusTrackingBarManager:ClearAllPoints();
    StatusTrackingBarManager:SetParent(UIParent);
    
    StatusTrackingBarManager:SetPoint("BOTTOM");
    

end