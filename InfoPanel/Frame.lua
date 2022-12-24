local _, Addon = ...;

local After=C_Timer.After;
local ShoulderAnimationFrame =  Addon.ShoulderAnimationFrame;
local MoveViewAnimationFrame =  Addon.MoveViewAnimationFrame;
local ViewPitchLimitAnimationFrame=Addon.ViewPitchLimitAnimationFrame;
local CameraFocus=Addon.CameraFocus;

function Addon:OnLoad_InfoFrame()
    local frame = CreateFrame("Frame", nil, UIParent);
    frame:EnableGamePadButton(true);
    frame:SetAllPoints();

    local tex = frame:CreateTexture();
    tex:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestLogCampaignHeaders");
    tex:SetTexCoord(0.004, 0.253, 0, 0.225);
    tex:SetSize(265, 55);
    tex:SetPoint("CENTER");
    frame.tex = tex;

    local higlight = frame:CreateTexture();
    higlight:SetTexture("Interface/QuestFrame/UI-QuestLogTitleHighlight", "CLAMP");
    higlight:SetBlendMode("ADD");
    higlight:SetSize(265, 55);
    higlight:SetTexCoord(0.2,0.8,1,0);
    higlight:SetVertexColor(HIGHLIGHT_LIGHT_BLUE:GetRGB());
    higlight:SetPoint("CENTER");
    higlight:Hide();

    local selected=frame:CreateTexture();
    selected:SetAtlas("CampaignHeader_SelectedGlow");
    selected:SetPoint("TOPLEFT",0,50);
    selected:SetSize(265,50);
    
    frame.higlight=higlight;
    
    frame:SetScript("OnMouseDown", function(selfs, arg)
        PlaySound(852);
        if(selfs.higlight:IsShown()) then
            selfs.higlight:Hide();
        else
            selfs.higlight:Show();
        end

        --CameraFocus:Enter();
    end);
end
