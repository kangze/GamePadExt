local _, Addon = ...;

function Addon:OnLoad_InfoFrame()
    local frame = CreateFrame("Frame", nil, UIParent);
    frame:EnableGamePadButton(true);
    frame:SetAllPoints();

    local tex = frame:CreateTexture();
    tex:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestLogCampaignHeaders");
    tex:SetTexCoord(0.006, 0.25, 0, 0.2);
    tex:SetSize(265, 50);
    tex:SetPoint("CENTER");
    frame.tex = tex;

    local higlight = frame:CreateTexture();
    higlight:SetTexture("Interface/QuestFrame/UI-QuestLogTitleHighlight", "CLAMP");
    higlight:SetBlendMode("ADD");
    higlight:SetAllPoints(tex);
    higlight:Hide();
    
    frame.higlight=higlight;
    
    frame:SetScript("OnMouseDown", function(selfs, arg)
        if(selfs.higlight:IsShown()) then
            selfs.higlight:Hide();
        else
            selfs.higlight:Show();
        end
    end);
end
