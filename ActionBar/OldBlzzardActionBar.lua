local addonName, addonTable = ...

local E=addonTable.E;


local MainMenuBar=MainMenuBar;
local MultiBarBottomLeft=MultiBarBottomLeft;


function E:LoadOldBlizzardActionBar()
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
    C_Timer.NewTimer(2,function()
        MultiBarBottomLeft:ClearAllPoints();
        MultiBarBottomLeft:SetPoint("LEFT",MainMenuBar,"RIGHT",-4,-2)
    end);

    

    self:ApplyCapDecoration(frame);
    self:ApplyCapDecoration(frame,true);
end

--
function E:ApplyCapDecoration(backframe,mirror)
    local cap=CreateFrame("Frame",nil,UIParent);
    cap:SetSize(128,128);
    cap:SetPoint("BOTTOMRIGHT",backframe,"BOTTOMLEFT",35,0);
    if(mirror) then
        cap:SetPoint("BOTTOMLEFT",backframe,"BOTTOMRIGHT",-35,0); 
    end
    cap:SetFrameStrata("HIGH");
    local tex=cap:CreateTexture();
    tex:SetAllPoints(cap);
    tex:SetTexture("Interface/AddOns/GamePadExt/media/texture/UI-MainMenuBar-EndCap-Dwarf","CLAMPTOWHITE");
    local ulx,uly , llx,lly , urx,ury , lrx,lry = 0,  0 , 0, 1 , 1,  0 , 1, 1;
    tex:SetTexCoord(ulx,uly , llx,lly , urx,ury , lrx,lry);
    if(mirror) then
        tex:SetTexCoord(urx,ury , lrx,lry , ulx,uly , llx,lly);    
    end

    --softtootiple 设置
end