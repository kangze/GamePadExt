local addonName, addonTable = ...

local A = addonTable.A;


local MainMenuBar = MainMenuBar;
local MultiBarBottomLeft = MultiBarBottomLeft;


function A:LoadOldBlizzardActionBar()
    local frame = CreateFrame("Frame", nil, MainMenuBar);
    frame:SetMovable(true);
    frame:SetPoint("TOPLEFT", -7, 4)
    frame:SetFrameStrata("LOW");
    frame:SetFrameLevel(0);
    frame.tex2 = frame:CreateTexture();
    frame.tex2:SetAllPoints(frame);
    frame.tex2:SetTexture("Interface/MAINMENUBAR/MainMenuBar", "CLAMPTOWHITE");
    frame.tex2:SetTexCoord(0.16, 0.94, 0.39, 0.58);
    frame:SetPoint("BOTTOM", MainMenuBar, 162, -3);
    C_Timer.NewTimer(2, function()
        MultiBarBottomLeft:ClearAllPoints();
        MultiBarBottomLeft:SetPoint("LEFT", MainMenuBar, "RIGHT", -4, -2)
    end);



    self:ApplyCapDecoration(frame);
    self:ApplyCapDecoration(frame, true);

    PlayerCastingBarFrame:HookScript("OnEvent", function(arg)
        arg.Text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE");
        arg.Text:SetPoint("TOP", 0, -12);
        arg:SetHeight(12);
        arg:SetWidth(255);
        arg.Icon:SetWidth(24);
        arg.Icon:SetHeight(24);
        arg.Icon:Show();
        arg.Icon:ClearAllPoints();
        arg.Icon:SetPoint("RIGHT",arg,"LEFT",0,-4);
    end);
end

--
function A:ApplyCapDecoration(backframe, mirror)
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

    --softtootiple 设置
end
