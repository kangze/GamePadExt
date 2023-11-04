local _, AddonData = ...;
local Gpe = _G["Gpe"];

local MainMenuBar = MainMenuBar;
local MultiBarBottomLeft = MultiBarBottomLeft;

local ActionBarModule = Gpe:GetModule('ActionBarModule')


function ActionBarModule:ApplyOldBlizzardActionBar()
    local frame = CreateFrame("Frame", nil, MainMenuBar);
    frame:SetMovable(true);
    frame:SetPoint("TOPLEFT", -4, 8)
    frame:SetFrameStrata("LOW");
    frame:SetFrameLevel(0);
    frame.tex = frame:CreateTexture();
    frame.tex:SetAllPoints(frame);
    frame.tex:SetTexture("Interface/MAINMENUBAR/MainMenuBar", "CLAMPTOWHITE");
    frame.tex:SetTexCoord(0.16, 0.90, 0.39, 0.58);
    frame:SetPoint("BOTTOM", MainMenuBar, 162, -3);
    MultiBarBottomLeft:ClearAllPoints();
    MultiBarBottomLeft:SetPoint("LEFT", MainMenuBar, "RIGHT", -4, -2)
    self:ApplyCapDecoration(frame);
    self:ApplyCapDecoration(frame, true);
    self.frame = frame;
end

--
function ActionBarModule:ApplyCapDecoration(backframe, mirror)
    local cap = CreateFrame("Frame", nil, UIParent);
    cap:SetSize(128, 128);
    if (mirror) then
        cap:SetPoint("BOTTOMLEFT", backframe, "BOTTOMRIGHT", -35, 0);
    else
        cap:SetPoint("BOTTOMRIGHT", backframe, "BOTTOMLEFT", 35, 0);
    end
    cap:SetFrameStrata("HIGH");
    local tex = cap:CreateTexture();
    tex:SetAllPoints(cap);
    tex:SetTexture("Interface/AddOns/GamePadExt/media/texture/UI-MainMenuBar-EndCap-Dwarf", "CLAMPTOWHITE");
    local ulx, uly, llx, lly, urx, ury, lrx, lry = 0, 0, 0, 1, 1, 0, 1, 1;
    if (mirror) then
        tex:SetTexCoord(urx, ury, lrx, lry, ulx, uly, llx, lly);
    else
        tex:SetTexCoord(ulx, uly, llx, lly, urx, ury, lrx, lry);
    end
end

function ActionBarModule:NoApplyBlizzardBar()
    if (self.frame ~= nil) then
        self.frame:Hide();
        self.frame:ClearAllPoints();
        self.frame = nil;
    end
end
