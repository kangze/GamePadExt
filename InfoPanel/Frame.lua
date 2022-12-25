local _, Addon = ...;

local After=C_Timer.After;
local ShoulderAnimationFrame =  Addon.ShoulderAnimationFrame;
local MoveViewAnimationFrame =  Addon.MoveViewAnimationFrame;
local ViewPitchLimitAnimationFrame=Addon.ViewPitchLimitAnimationFrame;
local UIParentAlphaAnimtationFrame=Addon.UIParentAlphaAnimtationFrame;
local CameraFocus=Addon.CameraFocus;

--Campaign_Dragonflight
    --Campaign_Shadowlands
    --Campaign_Alliance
    --Campaign_Horde
local expansions={
    {
        name="巨龙时代",
        tex="Campaign_Dragonflight",
    },
    {
        name="暗影国度",
        tex="Campaign_Shadowlands",
    },
    {
        name="争霸艾泽拉斯",
        tex="Campaign_Alliance"
    },
    {
        name="军团再临",
        tex="Campaign_Horde"
    },
    {
        name="德拉诺之王",
        tex="Campaign_Alliance"
    },
    {
        name="熊猫人之谜",
        tex="Campaign_Horde"
    },
    {
        name="大地的裂变",
        tex="Campaign_Horde"
    },
    {
        name="巫妖王之怒",
        tex="Campaign_Alliance"
    },
    {
        name="燃烧的远征",
        tex="Campaign_Horde"
    },
    {
        name="经典旧世",
        tex="Campaign_Alliance"
    }
}


function Addon:OnLoad_InfoFrame()

    

    

    local mainFrame=CreateFrame("Frame");
    local width=UIParent:GetWidth();
    local height=UIParent:GetHeight();
    mainFrame:SetSize(width,height);
    mainFrame:SetPoint("TOPLEFT",0,0);

    --
    --GetFactionInfoByID

    --local ids=C_MajorFactions.GetMajorFactionIDs();
    -- local data=C_MajorFactions.GetMajorFactionData(2510);
    -- print(data.name);
    -- print(id);
    -- print(data.expansionID);

    
    

    --创建版本的主框体
    local factionFrame=CreateFrame("Frame",nil,mainFrame);
    factionFrame:SetSize(265,height);
    factionFrame:SetPoint("TOPLEFT",mainFrame,200,0);
    factionFrame.background=factionFrame:CreateTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestMapLogAtlas");
    factionFrame.background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestMapLogAtlas");
    factionFrame.background:SetTexCoord(0.28,0.564,0.454,0.912);
    factionFrame.background:SetAllPoints();
    factionFrame.total=0;

    --创建声望主要框体

    local factionItemFrame=CreateFrame("Frame",nil,mainFrame);
    factionItemFrame:SetSize(265,height);
    factionItemFrame:SetPoint("TOPLEFT",mainFrame,465,0);
    factionItemFrame.background=factionItemFrame:CreateTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestMapLogAtlas");
    factionItemFrame.background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestMapLogAtlas");
    factionItemFrame.background:SetTexCoord(0.28,0.564,0.454,0.912);
    factionItemFrame.background:SetAllPoints();
    factionItemFrame.total=0;

    

    --创建每一个项,
    --巨龙时代 expansion_id:9
    local factionIDs=C_MajorFactions.GetMajorFactionIDs(9);
    for i=1,#expansions do
        AppendDragonFlight(factionFrame,expansions[i]);
    end

    for i=1,#factionIDs do
        AppendFactionItem(factionItemFrame,factionIDs[i]);
    end
    
    
end


function AppendFactionItem(factionItemFrame,factionID)


    --构建图标
    --MajorFactions_Icons_Centaur512
    local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus =GetFactionInfoByID(factionID);

    local offsetY=factionItemFrame.total*-(22+64);
    local factionFrame=CreateFrame("Frame",nil,factionItemFrame);
    factionFrame:SetSize(265,64);
    factionFrame:SetPoint("TOPLEFT",factionItemFrame,0,offsetY);

    factionFrame.background=factionFrame:CreateTexture();
    factionFrame.background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\UI-Character-Reputation-DetailBackground");
    factionFrame.background:SetAllPoints();
    factionFrame.background:SetTexCoord(0,0.74,0,1);

    factionFrame.icon=factionFrame:CreateTexture();
    factionFrame.icon:SetAtlas("MajorFactions_Icons_Expedition512")
    factionFrame.icon:SetPoint("LEFT",0,0);
    factionFrame.icon:SetSize(64,64);


    --构建名称
    factionFrame.font_name=factionFrame:CreateFontString(nil,"OVERLAY","GameTooltipText");
    factionFrame.font_name:SetPoint("TOPLEFT",64,-5);
    factionFrame.font_name:SetText(name);

    factionFrame.description=factionFrame:CreateFontString(nil,"OVERLAY","GameTooltipText");
    factionFrame.description:SetText(description);
    factionFrame.description:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    factionFrame.description:SetPoint("LEFT",64,-5);
    factionFrame.description:SetSize(200,64);
    factionFrame.description:SetMaxLines(3);


    local item=CreateFrame("Frame",nil,factionItemFrame);
    
    item:SetSize(265,20);
    item:SetPoint("TOPLEFT",factionItemFrame,0,offsetY-64);
    item.background=item:CreateTexture();
    item.background:SetAtlas("ui-castingbar-background"); --背景
    item.background:SetAllPoints();

    item.border=item:CreateTexture();
    item.border:SetAtlas("ui-castingbar-frame");  --边框
    item.border:SetAllPoints();

    item.highlight=item:CreateTexture();
    item.highlight:SetAtlas("ui-castingbar-full-glow-standard");  --高亮边框
    item.highlight:SetAllPoints();

    item.tex=item:CreateTexture();
    item.tex:SetAtlas("ui-castingbar-full-applyingcrafting")
    item.tex:SetPoint("LEFT",2,0);
    item.tex:SetSize(100,17);

    

    factionItemFrame.total=factionItemFrame.total+1;
end

function AppendDragonFlight(factionFrame,expansion)    
    local offsetY=factionFrame.total*52;
    local factionItemFrame = CreateFrame("Frame", nil, factionFrame);
    factionItemFrame:SetSize(265,55);
    factionItemFrame:SetPoint("TOPLEFT",factionFrame,0,-1-offsetY);
    factionItemFrame.background = factionItemFrame:CreateTexture();
    -- factionItemFrame.background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestLogCampaignHeaders");
    -- factionItemFrame.background:SetTexCoord(0.004, 0.253, 0, 0.225);
    
    factionItemFrame.background:SetAtlas(expansion.tex);
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


    factionItemFrame.font_name=factionItemFrame:CreateFontString(nil,"OVERLAY","GameTooltipText");
    factionItemFrame.font_name:SetPoint("CENTER");
    factionItemFrame.font_name:SetText(expansion.name);

    

    
    factionItemFrame:SetScript("OnEnter", function(selfs, arg)
        PlaySound(852);
        selfs.tex_selectedGlow:Show();
        -- local animationGroup=selfs:CreateAnimationGroup();
        -- local tran1=animationGroup:CreateAnimation("translation");
        -- tran1:SetDuration(1);
        -- tran1:SetOrder(1);
        -- tran1:SetOffset(0, -8);
        -- animationGroup:Play();

        -- local al = UIParentAlphaAnimtationFrame.New(0.5);
        -- al:Show();
    end);

    factionItemFrame:SetScript("OnLeave",function(selfs,arg)
        PlaySound(852);
        selfs.tex_selectedGlow:Hide();
    end);

    factionFrame.total=factionFrame.total+1;
end
