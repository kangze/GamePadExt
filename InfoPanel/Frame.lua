local _, Addon = ...;

local After = C_Timer.After;
local ShoulderAnimationFrame = Addon.ShoulderAnimationFrame;
local MoveViewAnimationFrame = Addon.MoveViewAnimationFrame;
local ViewPitchLimitAnimationFrame = Addon.ViewPitchLimitAnimationFrame;
local UIParentAlphaAnimtationFrame = Addon.UIParentAlphaAnimtationFrame;
local CameraFocus = Addon.CameraFocus;

--Campaign_Dragonflight
--Campaign_Shadowlands
--Campaign_Alliance
--Campaign_Horde
local expansions = {
    {
        name = "巨龙时代",
        index = 0,
        tex = "Campaign_Dragonflight",
        factionIds = {
            2503, --马鲁克半人马
            2507, --龙鳞探险队
            2510, --瓦德拉肯联军,
            2511, --伊斯卡拉海象人
            2517, --拉希奥
            2518, --萨贝里安
        }
    },
    {
        name = "暗影国度",
        index = 1,
        tex = "Campaign_Shadowlands",
        factionIds={
            2410,   --不朽军团
            2432,   --威*娜莉
            2478,   --开悟者
            2413,   --收割者之庭
            2407,   --晋升者
        }
    },
    {
        name = "争霸艾泽拉斯",
        index = 2,
        tex = "Campaign_Alliance"
    },
    {
        name = "军团再临",
        index = 3,
        tex = "Campaign_Horde"
    },
    {
        name = "德拉诺之王",
        index = 4,
        tex = "Campaign_Alliance"
    },
    {
        name = "熊猫人之谜",
        index = 5,
        tex = "Campaign_Horde"
    },
    {
        name = "大地的裂变",
        index = 6,
        tex = "Campaign_Horde"
    },
    {
        name = "巫妖王之怒",
        index = 7,
        tex = "Campaign_Alliance"
    },
    {
        name = "燃烧的远征",
        index = 8,
        tex = "Campaign_Horde"
    },
    {
        name = "经典旧世",
        index = 9,
        tex = "Campaign_Alliance"
    }
}


function Addon:OnLoad_InfoFrame()

    local focusInfo = {
        expansions = expansions,
        expansionIndex = 2,
        expansionFactionIndex = 2
    }

    local mainFrame = CreateFrame("Frame");
    local width = UIParent:GetWidth();
    local height = UIParent:GetHeight();
    mainFrame:SetSize(width, height);
    mainFrame:SetPoint("TOPLEFT", 0, 0);
    mainFrame:EnableGamePadButton(true);
    mainFrame:SetScript("OnGamePadButtonDown", function(arg1, arg2)
        --PADDUP PADDDOWN
        if (arg2 ~= "PADDUP" and arg2 ~= "PADDDOWN") then return end

        local container = arg1.expansionContainerFrame;
        local newIndex = 0;
        if (arg2 == "PADDUP") then
            newIndex = container.index - 1;
        else if (arg2 == "PADDDOWN") then
                newIndex = container.index + 1;
            end
        end

        newIndex = newIndex % container.total;
        container.index = newIndex;
        self.focusInfo.expansionIndex = newIndex;
        self:Focus(newIndex);
    end);
    --mainFrame:Hide();

    --创建横幅 高度45
    local headerContainerFrame=CreateFrame("Frame",nil,mainFrame);
    headerContainerFrame:SetSize(width,45);
    headerContainerFrame:SetPoint("TOPLEFT",mainFrame,0,0);

    -------阵营
    --背景1
    headerContainerFrame.background=headerContainerFrame:CreateTexture(nil,"BACKGROUND");
    headerContainerFrame.background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\TalkingHeads");
    headerContainerFrame.background:SetAllPoints();
    --headerContainerFrame.background:SetAtlas("TalkingHeads-Alliance-TextBackground");
    headerContainerFrame.background:SetTexCoord(0.017,0.767,0.2,0.29);

    headerContainerFrame.background2=headerContainerFrame:CreateTexture(nil,"ARTWORK");
    --headerContainerFrame.background2:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\UI-Classes-Circles");
    headerContainerFrame.background2:SetPoint("TOPLEFT",0,0);
    headerContainerFrame.background2:SetSize(45,45);
    --UI_AllianceIcon-round
    --interface/icons/ClassIcon_Mage
    SetPortraitToTexture(headerContainerFrame.background2,"interface/icons/UI_AllianceIcon-round");
    --背景3
    headerContainerFrame.background3=headerContainerFrame:CreateTexture(nil,"ARTWORK");
    headerContainerFrame.background3:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\Artifacts-PerkRing-Final-Mask");
    headerContainerFrame.background3:SetPoint("TOPLEFT",0,0);
    headerContainerFrame.background3:SetSize(45,45);
    headerContainerFrame.background3:SetTexCoord(0.12,0.89,0.12,0.87);

    ---------职业

    headerContainerFrame.background4=headerContainerFrame:CreateTexture(nil,"ARTWORK");
    --headerContainerFrame.background2:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\UI-Classes-Circles");
    headerContainerFrame.background4:SetPoint("TOPLEFT",45,0);
    headerContainerFrame.background4:SetSize(45,45);
    --UI_AllianceIcon-round
    --interface/icons/ClassIcon_Mage
    SetPortraitToTexture(headerContainerFrame.background4,"interface/icons/ClassIcon_Mage");
    --背景3
    headerContainerFrame.background5=headerContainerFrame:CreateTexture(nil,"ARTWORK");
    headerContainerFrame.background5:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\Artifacts-PerkRing-Final-Mask");
    headerContainerFrame.background5:SetPoint("TOPLEFT",45,0);
    headerContainerFrame.background5:SetSize(45,45);
    headerContainerFrame.background5:SetTexCoord(0.12,0.89,0.12,0.87);

    --创建版本的主框体
    local expansionContainerFrame = CreateFrame("Frame", nil, mainFrame);
    expansionContainerFrame:SetSize(265, height-45);
    expansionContainerFrame:SetPoint("TOPLEFT", mainFrame, 0, -45);
    expansionContainerFrame.background = expansionContainerFrame:CreateTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestMapLogAtlas");
    expansionContainerFrame.background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestMapLogAtlas");
    expansionContainerFrame.background:SetTexCoord(0.28, 0.564, 0.454, 0.912);
    expansionContainerFrame.background:SetAllPoints();
    expansionContainerFrame.total = 0;
    expansionContainerFrame.index = focusInfo.expansionIndex;
    expansionContainerFrame.items = {};
    mainFrame.expansionContainerFrame = expansionContainerFrame;

    --创建声望主要框体

    local factionContainerFrame = CreateFrame("Frame", nil, mainFrame);
    factionContainerFrame:SetSize(265, height);
    factionContainerFrame:SetPoint("TOPLEFT", mainFrame, 265, -45);
    factionContainerFrame.background = factionContainerFrame:CreateTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestMapLogAtlas");
    factionContainerFrame.background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestMapLogAtlas");
    factionContainerFrame.background:SetTexCoord(0.28, 0.564, 0.454, 0.912);
    factionContainerFrame.background:SetAllPoints();
    factionContainerFrame.total = 0;
    factionContainerFrame.index = focusInfo.expansionFactionIndex;
    factionContainerFrame.items = {};
    mainFrame.factionContainerFrame = factionContainerFrame



    --创建每一个项,
    for i = 1, #expansions do
        local expansionItemFrame = self:AppendExpansion(expansionContainerFrame, expansions[i]);
        expansionItemFrame.factionIds = expansions[i].factionIds;
        if (expansions[i].factionIds) then
            for j = 1, #expansions[i].factionIds do
                --self:AppendFactionItem(factionContainerFrame, expansions[i].factionIds[j]);
            end
        end

    end

    self.mainFrame = mainFrame;
    self.focusInfo = focusInfo;
    self:Focus(0);
end

function Addon:AppendFactionItem(factionContainerFrame, factionID)


    --构建图标
    --MajorFactions_Icons_Centaur512
    local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfoByID(factionID);

    local offsetY = factionContainerFrame.total * -(22 + 64)-(10*factionContainerFrame.total);
    local factionItemFrame = CreateFrame("Frame", nil, factionContainerFrame);
    factionItemFrame:SetSize(265, 64);
    factionItemFrame:SetPoint("TOPLEFT", factionContainerFrame, 0, offsetY);

    factionItemFrame.background = factionItemFrame:CreateTexture();
    factionItemFrame.background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\UI-Character-Reputation-DetailBackground");
    factionItemFrame.background:SetAllPoints();
    factionItemFrame.background:SetTexCoord(0, 0.74, 0, 1);

    factionItemFrame.icon = factionItemFrame:CreateTexture();
    factionItemFrame.icon:SetAtlas("MajorFactions_Icons_Expedition512")
    factionItemFrame.icon:SetPoint("LEFT", 0, 0);
    factionItemFrame.icon:SetSize(64, 64);


    --构建名称
    factionItemFrame.font_name = factionItemFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText");
    factionItemFrame.font_name:SetPoint("TOPLEFT", 64, -5);
    factionItemFrame.font_name:SetText(name);

    factionItemFrame.description = factionItemFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText");
    factionItemFrame.description:SetText(description);
    factionItemFrame.description:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    factionItemFrame.description:SetPoint("LEFT", 64, -5);
    factionItemFrame.description:SetSize(200, 64);
    factionItemFrame.description:SetMaxLines(3);


    local item = CreateFrame("Frame", nil, factionItemFrame);

    item:SetSize(265, 20);
    item:SetPoint("TOP",factionItemFrame,"BOTTOM", 0,2);

    item.background = item:CreateTexture();
    item.background:SetAtlas("ui-castingbar-background"); --背景
    item.background:SetAllPoints();

    item.border = item:CreateTexture();
    item.border:SetAtlas("ui-castingbar-frame"); --边框
    item.border:SetAllPoints();

    item.highlight = item:CreateTexture();
    item.highlight:SetAtlas("ui-castingbar-full-glow-standard"); --高亮边框
    item.highlight:SetAllPoints();

    item.tex = item:CreateTexture();
    item.tex:SetAtlas("ui-castingbar-full-applyingcrafting")
    item.tex:SetPoint("LEFT", 2, 0);
    item.tex:SetSize(100, 17);

    factionContainerFrame.total = factionContainerFrame.total + 1;
    table.insert(factionContainerFrame.items, factionItemFrame);
    return factionItemFrame;
end

function Addon:AppendExpansion(expansionContainerFrame, expansion)
    local offsetY = expansionContainerFrame.total * 52;
    local expansionItemFrame = CreateFrame("Frame", nil, expansionContainerFrame);
    expansionItemFrame.index = expansion.index;
    expansionItemFrame:SetSize(265, 55);
    expansionItemFrame:SetPoint("TOPLEFT", expansionContainerFrame, 0, -1 - offsetY);
    expansionItemFrame.background = expansionItemFrame:CreateTexture();
    -- factionItemFrame.background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestLogCampaignHeaders");
    -- factionItemFrame.background:SetTexCoord(0.004, 0.253, 0, 0.225);

    expansionItemFrame.background:SetAtlas(expansion.tex);
    expansionItemFrame.background:SetAllPoints();


    expansionItemFrame.tex_highlight = expansionItemFrame:CreateTexture();
    -- factionItemFrame.background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestLogCampaignHeaders");
    -- factionItemFrame.background:SetTexCoord(0.004, 0.253, 0, 0.225);

    expansionItemFrame.tex_highlight:SetAtlas(expansion.tex);
    expansionItemFrame.tex_highlight:SetAllPoints();
    expansionItemFrame.tex_highlight:Hide();

    -- factionItemFrame.tex_highlight = factionItemFrame:CreateTexture();
    -- factionItemFrame.tex_highlight:SetTexture("Interface/QuestFrame/UI-QuestLogTitleHighlight", "CLAMP");
    -- factionItemFrame.tex_highlight:SetBlendMode("BLEND");
    -- factionItemFrame.tex_highlight:SetSize(265, 47);
    -- factionItemFrame.tex_highlight:SetTexCoord(0.2,0.8,1,0);
    -- factionItemFrame.tex_highlight:SetVertexColor(HIGHLIGHT_LIGHT_BLUE:GetRGB());
    -- factionItemFrame.tex_highlight:SetPoint("TOPLEFT",factionItemFrame);
    -- factionItemFrame.tex_highlight:Hide();

    expansionItemFrame.tex_selectedGlow = expansionItemFrame:CreateTexture();
    expansionItemFrame.tex_selectedGlow:SetAtlas("CampaignHeader_SelectedGlow");
    expansionItemFrame.tex_selectedGlow:SetBlendMode("ADD");
    expansionItemFrame.tex_selectedGlow:SetPoint("TOPLEFT", 0, -3);
    expansionItemFrame.tex_selectedGlow:SetSize(265, 55);
    expansionItemFrame.tex_selectedGlow:Hide();


    expansionItemFrame.font_name = expansionItemFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText");
    expansionItemFrame.font_name:SetPoint("CENTER");
    expansionItemFrame.font_name:SetText(expansion.name);

    expansionItemFrame:SetScript("OnEnter", function(selfs, arg)
        self:Focus(selfs.index);

        --DEMO:
        -- local animationGroup=selfs:CreateAnimationGroup();
        -- local tran1=animationGroup:CreateAnimation("translation");
        -- tran1:SetDuration(1);
        -- tran1:SetOrder(1);
        -- tran1:SetOffset(0, -8);
        -- animationGroup:Play();

        -- local al = UIParentAlphaAnimtationFrame.New(0.5);
        -- al:Show();
    end);

    expansionItemFrame:SetScript("OnLeave", function(selfs, arg)
        self:Focus(nil);
    end);


    expansionContainerFrame.total = expansionContainerFrame.total + 1;
    table.insert(expansionContainerFrame.items, expansionItemFrame);
    return expansionItemFrame;
end

function Addon:Focus(expansionIndex)
    PlaySound(852);
    local expansionItems = self.mainFrame.expansionContainerFrame.items;
    for i = 1, #expansionItems do
        local item = expansionItems[i];
        if (expansionIndex == item.index) then
            item.tex_selectedGlow:Show();
            item.tex_highlight:Show();
            --加载声望
            if(self.mainFrame.factionContainerFrame.items) then 
                for k=1,#self.mainFrame.factionContainerFrame.items do
                    self.mainFrame.factionContainerFrame.items[k]:Hide();
                end
            end;
            --垃圾回收,重置计数
            self.mainFrame.factionContainerFrame.total=0;
            self.mainFrame.factionContainerFrame.items={};
            if (expansionItems[i].factionIds) then
                for j = 1, #expansionItems[i].factionIds do
                    self:AppendFactionItem(self.mainFrame.factionContainerFrame, expansionItems[i].factionIds[j])
                end
            end
        else
            item.tex_selectedGlow:Hide();
            item.tex_highlight:Hide();
        end
    end
end
