local _, Addon = ...;

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
}


local VerticalContainer   = {};
local HorizontalContainer = {};

function VerticalContainer:Create(parent, offsetX)
    local width, height = parent:GetWidth(), parent:GetHeight();
    local container = CreateFrame("Frame", nil, parent);
    container:SetSize(265, height - 45);
    container:SetPoint("TOPLEFT", parent, offsetX, -45);
    container.background = container:CreateTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestMapLogAtlas");
    container.background:SetAtlas("QuestBG-Fey");
    --container.background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\QuestMapLogAtlas");
    --container.background:SetTexCoord(0.28, 0.564, 0.454, 0.912);
    container.background:SetAllPoints();
    return container;
end

function HorizontalContainer:Create(parent)
    local width, height = parent:GetWidth(), parent:GetHeight();
    local container = CreateFrame("Frame", nil, parent);
    container:SetSize(width, 45);
    container:SetPoint("TOPLEFT", parent, 0, 0);

    --background
    container.tex_background = container:CreateTexture(nil, "BACKGROUND");
    container.tex_background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\TalkingHeads");
    container.tex_background:SetAllPoints();
    container.tex_background:SetTexCoord(0.017, 0.767, 0.2, 0.29);

    --camp_item
    container.tex_camp = container:CreateTexture(nil, "ARTWORK");
    --headerContainerFrame.background2:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\UI-Classes-Circles");
    container.tex_camp:SetPoint("TOPLEFT", 0, 0);
    container.tex_camp:SetSize(45, 45);
    --UI_AllianceIcon-round
    --interface/icons/ClassIcon_Mage
    SetPortraitToTexture(container.tex_camp, "interface/icons/UI_AllianceIcon-round");

    --camp_circle
    container.tex_camp_circle = container:CreateTexture(nil, "ARTWORK");
    container.tex_camp_circle:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\Artifacts-PerkRing-Final-Mask");
    container.tex_camp_circle:SetPoint("TOPLEFT", 0, 0);
    container.tex_camp_circle:SetSize(45, 45);
    container.tex_camp_circle:SetTexCoord(0.12, 0.89, 0.12, 0.87);

    
    --class
    container.tex_class = container:CreateTexture(nil, "ARTWORK");
    --headerContainerFrame.background2:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\UI-Classes-Circles");
    container.tex_class:SetPoint("TOPLEFT", 45, 0);
    container.tex_class:SetSize(45, 45);
    --UI_AllianceIcon-round
    --interface/icons/ClassIcon_Mage
    SetPortraitToTexture(container.tex_class, "interface/icons/ClassIcon_Mage");
    
    --class_circle
    container.tex_class_circle = container:CreateTexture(nil, "ARTWORK");
    container.tex_class_circle:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\Artifacts-PerkRing-Final-Mask");
    container.tex_class_circle:SetPoint("TOPLEFT", 45, 0);
    container.tex_class_circle:SetSize(45, 45);
    container.tex_class_circle:SetTexCoord(0.12, 0.89, 0.12, 0.87);



    --class_ext
    container.tex_class_ext = container:CreateTexture(nil, "ARTWORK");
    container.tex_class_ext:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\artifactbook-priest-cover");
    container.tex_class_ext:SetPoint("CENTER", 0, 0);
    container.tex_class_ext:SetSize(45, 45);
    --headerContainerFrame.background6:SetTexCoord(0.12,0.89,0.12,0.87);
end

Addon.VerticalContainer = VerticalContainer;
Addon.HorizontalContainer = HorizontalContainer;
