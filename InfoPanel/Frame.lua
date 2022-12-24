local _, Addon = ...;

local After=C_Timer.After;
local ShoulderAnimationFrame =  Addon.ShoulderAnimationFrame;
local MoveViewAnimationFrame =  Addon.MoveViewAnimationFrame;
local ViewPitchLimitAnimationFrame=Addon.ViewPitchLimitAnimationFrame;
local CameraFocus=Addon.CameraFocus;

function Addon:OnLoad_InfoFrame()

    

    local mainFrame=CreateFrame("Frame",nil,UIParent);
    mainFrame:SetAllPoints();

    --
    --GetFactionInfoByID

    --local ids=C_MajorFactions.GetMajorFactionIDs();
    local data=C_MajorFactions.GetMajorFactionData(2510);
    print(data.name);
    print(id);
    print(data.expansionID);
    

    --创建声望主框体
    local factionFrame=CreateFrame("Frame",nil,mainFrame);
    factionFrame:SetSize(280,800);
    factionFrame:SetPoint("LEFT",mainFrame,800,0);
    factionFrame.background=factionFrame:CreateTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestMapLogAtlas");
    factionFrame.background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestMapLogAtlas");
    factionFrame.background:SetTexCoord(0.28,0.564,0.454,0.912);
    factionFrame.background:SetAllPoints();
    factionFrame.total=0;

    

    --创建每一个项
    AppendDragonFlight(factionFrame);
    AppendDragonFlight(factionFrame);
    AppendDragonFlight(factionFrame);
    AppendDragonFlight(factionFrame);
    AppendDragonFlight(factionFrame);

   
    
end


function AppendDragonFlight(factionFrame)
    local offsetY=factionFrame.total*52;
    local factionItemFrame = CreateFrame("Frame", nil, factionFrame);
    factionItemFrame:SetSize(265,55);
    factionItemFrame:SetPoint("TOPLEFT",factionFrame,2,-1-offsetY);
    factionItemFrame.background = factionItemFrame:CreateTexture();
    factionItemFrame.background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestLogCampaignHeaders");
    factionItemFrame.background:SetTexCoord(0.004, 0.253, 0, 0.225);
    factionItemFrame.background:SetAllPoints();

    factionItemFrame.tex_highlight = factionItemFrame:CreateTexture();
    factionItemFrame.tex_highlight:SetTexture("Interface/QuestFrame/UI-QuestLogTitleHighlight", "CLAMP");
    factionItemFrame.tex_highlight:SetBlendMode("BLEND");
    factionItemFrame.tex_highlight:SetSize(265, 47);
    factionItemFrame.tex_highlight:SetTexCoord(0.2,0.8,1,0);
    factionItemFrame.tex_highlight:SetVertexColor(HIGHLIGHT_LIGHT_BLUE:GetRGB());
    factionItemFrame.tex_highlight:SetPoint("TOPLEFT",factionItemFrame);
    factionItemFrame.tex_highlight:Hide();

    factionItemFrame.tex_selectedGlow=factionItemFrame:CreateTexture();
    factionItemFrame.tex_selectedGlow:SetAtlas("CampaignHeader_SelectedGlow");
    factionItemFrame.tex_selectedGlow:SetBlendMode("ADD");
    factionItemFrame.tex_selectedGlow:SetPoint("TOPLEFT",0,-3);
    factionItemFrame.tex_selectedGlow:SetSize(265,55);
    factionItemFrame.tex_selectedGlow:Hide();
    factionItemFrame:CreateAnimationGroup();

    

    
    factionItemFrame:SetScript("OnEnter", function(selfs, arg)
        PlaySound(852);
        selfs.tex_selectedGlow:Show();
        local animationGroup=selfs:CreateAnimationGroup();
        local tran1=animationGroup:CreateAnimation("translation");
        tran1:SetDuration(1);
        tran1:SetOrder(1);
        tran1:SetOffset(0, -8);
        animationGroup:Play();
    end);

    factionItemFrame:SetScript("OnLeave",function(selfs,arg)
        PlaySound(852);
        selfs.tex_selectedGlow:Hide();
    end);

    factionFrame.total=factionFrame.total+1;
end
