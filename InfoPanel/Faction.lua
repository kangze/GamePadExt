local _,Addon=...;

local Faction={};



function Faction:Create(config)
    --构建图标
    --MajorFactions_Icons_Centaur512
    local factionId=config.factionId;
    local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfoByID(factionId);

    local frame = CreateFrame("Frame");
    frame:SetSize(265, 64);

    --background
    frame.tex_background = frame:CreateTexture();
    frame.tex_background:SetTexture("Interface\\AddOns\\GamePadExt\\media\\texture\\UI-Character-Reputation-DetailBackground");
    frame.tex_background:SetAllPoints();
    frame.tex_background:SetTexCoord(0, 0.74, 0, 1);

    --faction icon
    frame.tex_icon = frame:CreateTexture();
    frame.tex_icon:SetAtlas("MajorFactions_Icons_Expedition512")
    frame.tex_icon:SetPoint("LEFT", 0, 0);
    frame.tex_icon:SetSize(64, 64);


    --faction name
    frame.font_name = frame:CreateFontString(nil, "OVERLAY", "GameTooltipText");
    frame.font_name:SetPoint("TOPLEFT", 64, -5);
    frame.font_name:SetText(name);

    --faction description
    frame.font_description = frame:CreateFontString(nil, "OVERLAY", "GameTooltipText");
    frame.font_description:SetText(description);
    frame.font_description:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    frame.font_description:SetPoint("LEFT", 64, -5);
    frame.font_description:SetSize(200, 64);
    frame.font_description:SetMaxLines(3);


    --statusbar
    local statusbar = CreateFrame("Frame", nil, frame);
    statusbar:SetSize(265, 20);
    statusbar:SetPoint("TOP", frame, "BOTTOM", 0, 2);

    --statusbar background
    statusbar.background = statusbar:CreateTexture();
    statusbar.background:SetAtlas("ui-castingbar-background"); --背景
    statusbar.background:SetAllPoints();

    --statusbar border
    statusbar.border = statusbar:CreateTexture();
    statusbar.border:SetAtlas("ui-castingbar-frame"); --边框
    statusbar.border:SetAllPoints();

    --statusbar highlight
    statusbar.highlight = statusbar:CreateTexture();
    statusbar.highlight:SetAtlas("ui-castingbar-full-glow-standard"); --高亮边框
    statusbar.highlight:SetAllPoints();

    --statusbar texture
    statusbar.tex = statusbar:CreateTexture();
    statusbar.tex:SetAtlas("ui-castingbar-full-applyingcrafting")
    statusbar.tex:SetPoint("LEFT", 2, 0);
    statusbar.tex:SetSize(100, 17);
    return frame;
end

Addon.Faction=Faction;