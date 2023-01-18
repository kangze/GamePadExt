local _, Addon = ...;

local After = C_Timer.After;
local ShoulderAnimationFrame = Addon.ShoulderAnimationFrame;
local MoveViewAnimationFrame = Addon.MoveViewAnimationFrame;
local ViewPitchLimitAnimationFrame = Addon.ViewPitchLimitAnimationFrame;
local UIParentAlphaAnimtationFrame = Addon.UIParentAlphaAnimtationFrame;
local CameraFocus = Addon.CameraFocus;
local VerticalContainer=Addon.VerticalContainer;
local HorizontalContainer=Addon.HorizontalContainer;
local Expansion=Addon.Expansion;
local Faction=Addon.Faction;
local CreateFrame=CreateFrame;
local UIParent=UIParent;
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
        factionIds = {
            2410, --不朽军团
            2432, --威*娜莉
            2478, --开悟者
            2413, --收割者之庭
            2407, --晋升者
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
    }
    -- {
    --     name = "大地的裂变",
    --     index = 6,
    --     tex = "Campaign_Horde"
    -- },
    -- {
    --     name = "巫妖王之怒",
    --     index = 7,
    --     tex = "Campaign_Alliance"
    -- },
    -- {
    --     name = "燃烧的远征",
    --     index = 8,
    --     tex = "Campaign_Horde"
    -- },
    -- {
    --     name = "经典旧世",
    --     index = 9,
    --     tex = "Campaign_Alliance"
    -- }
}

local indexer={
    current="reputaion_expansion",
    reputation={
        expansion={
            index=0, -- -1等于没有选中
        },
        faction={
            index=-1,  -- 表明选中第一个
        }
    }
}

local HandleGamepadButtonDown=function(self,button)
    if (button ~= "PADDUP" and button ~= "PADDDOWN") then return end
        local indexer= self.indexer;
        local currents=indexer.current:split('_');
        if(currents[1]=="reputation") then
            local frame=self.reputaionContainerFrame;
            if(currents[2]=="expansion") then
                frame=frame.expansionContainerFrame;
            end
        end
        local container = self.expansionContainerFrame;
        local newIndex = 0;
        if (button == "PADDUP") then
            newIndex = container.index - 1;
        else if (button == "PADDDOWN") then
                newIndex = container.index + 1;
            end
        end

        newIndex = newIndex % container.total;
        container.index = newIndex;
        self.focusInfo.expansionIndex = newIndex;
        self:Focus(newIndex);
end


function Addon:OnLoad_InfoFrame()

    local focusInfo = {
        expansions = expansions,
        expansionIndex = 2,
        expansionFactionIndex = 2
    }

    local mainFrame = CreateFrame("Frame");
    local width = UIParent:GetWidth();
    local height = UIParent:GetHeight();
    --mainFrame:SetSize(width, height);
    --mainFrame:SetPoint("TOPLEFT", 0, 0);
    mainFrame:SetAllPoints(UIParent);
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
    mainFrame:Hide();

    --创建横幅 高度45
    
    local headerContainerFrame = HorizontalContainer:Create(mainFrame,45);
    mainFrame.headerContainerFrame=headerContainerFrame;


    local item=CreateFrame("Frame",nil,headerContainerFrame);
    item:SetFrameLevel(1000);
    item:SetWidth(200);
    item:SetHeight(45);
    item:SetPoint("CENTER",-200,0);
    local tex=item:CreateTexture(nil,"OVERLAY");
    --tex:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\1.tga");
    --tex:SetAtlas("TalkingHeads-Horde-TextBackground");
    tex:SetAllPoints();

    --创建版本的主框体
    local expansionContainerFrame = VerticalContainer:Create(mainFrame,600);
    expansionContainerFrame.total = 0;
    expansionContainerFrame.index = focusInfo.expansionIndex;
    expansionContainerFrame.items = {};
    mainFrame.expansionContainerFrame = expansionContainerFrame;

    --创建声望主要框体

    local factionContainerFrame = VerticalContainer:Create(mainFrame,865);
    factionContainerFrame.total = 0;
    factionContainerFrame.index = focusInfo.expansionFactionIndex;
    factionContainerFrame.items = {};
    mainFrame.factionContainerFrame = factionContainerFrame



    --创建每一个资料片
    for i = 0, #expansions-1 do
        local expansionItemFrame = Expansion:Create({index=i,name=expansions[i+1].name,factionIds=expansions[i+1].factionIds})    --self:AppendExpansion(expansionContainerFrame, expansions[i]);
        local offsetY = expansionContainerFrame.total * 52;
        expansionContainerFrame.total=expansionContainerFrame.total+1;

        expansionItemFrame:SetParent(expansionContainerFrame);
        expansionItemFrame:SetPoint("TOPLEFT", expansionContainerFrame, 0, -1 - offsetY);
        
    end

    for i=1,#(expansions[1].factionIds) do
        local factionItemFrame=Faction:Create({factionId=expansions[1].factionIds[i]});
        factionItemFrame:SetParent(factionContainerFrame);
        local offsetY = factionContainerFrame.total * -(22 + 64) - (10 * factionContainerFrame.total);
        factionContainerFrame.total=factionContainerFrame.total+1;
        factionItemFrame:SetPoint("TOPLEFT",factionContainerFrame,0,offsetY);
    end

    self.mainFrame = mainFrame;
    self.focusInfo = focusInfo;
    self:Focus(0);
end

function Addon:AppendFactionItem(factionContainerFrame, factionID)


    --构建图标
    --MajorFactions_Icons_Centaur512
    local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfoByID(factionID);

    local offsetY = factionContainerFrame.total * -(22 + 64) - (10 * factionContainerFrame.total);
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
    item:SetPoint("TOP", factionItemFrame, "BOTTOM", 0, 2);

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
        selfs:tp(selfs);
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

    local tp = function(selfs)
        local function AddRenownRewardsToTooltip(renownRewards)
            GameTooltip_AddHighlightLine(GameTooltip, MAJOR_FACTION_BUTTON_TOOLTIP_NEXT_REWARDS);
            for i, rewardInfo in ipairs(renownRewards) do
                local renownRewardString;
                local icon, name, description = RenownRewardUtil.GetRenownRewardInfo(rewardInfo,
                    GenerateClosure(self.ShowMajorFactionRenownTooltip, self));
                if icon then
                    local file, width, height = icon, 16, 16;
                    local rewardTexture = CreateSimpleTextureMarkup(file, width, height);
                    renownRewardString = rewardTexture .. " " .. name;
                end
                local wrapText = false;
                GameTooltip_AddNormalLine(GameTooltip, renownRewardString, wrapText);
            end
        end

        GameTooltip:SetOwner(selfs, "ANCHOR_RIGHT");
        local majorFactionData = C_MajorFactions.GetMajorFactionData(2503);
        local tooltipTitle = majorFactionData.name;
        GameTooltip_SetTitle(GameTooltip, tooltipTitle, NORMAL_FONT_COLOR);
        GameTooltip_AddColoredLine(GameTooltip, RENOWN_LEVEL_LABEL .. majorFactionData.renownLevel, BLUE_FONT_COLOR);
        GameTooltip_AddBlankLineToTooltip(GameTooltip);
        GameTooltip_AddHighlightLine(GameTooltip, MAJOR_FACTION_RENOWN_TOOLTIP_PROGRESS:format(majorFactionData.name));
        GameTooltip_AddBlankLineToTooltip(GameTooltip);
        local nextRenownRewards = C_MajorFactions.GetRenownRewardsForLevel(2503,
            C_MajorFactions.GetCurrentRenownLevel(2503) + 1);
        if #nextRenownRewards > 0 then
            AddRenownRewardsToTooltip(nextRenownRewards);
        end
        GameTooltip:Show();
    end
    expansionItemFrame.tp = tp;


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
            if (self.mainFrame.factionContainerFrame.items) then
                for k = 1, #self.mainFrame.factionContainerFrame.items do
                    self.mainFrame.factionContainerFrame.items[k]:Hide();
                end
            end
            --垃圾回收,重置计数
            self.mainFrame.factionContainerFrame.total = 0;
            self.mainFrame.factionContainerFrame.items = {};
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
