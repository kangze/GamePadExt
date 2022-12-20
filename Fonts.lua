local addonName, addonTable = ...;
local E = addonTable.E;



function E:InitFoints()
    PlayerName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");

    --PlayerFrameHealthBarTextLeft:SetFont("Fonts\\FRIZQT__.TTF", 11, "");
    --PlayerFrameHealthBarTextRight:SetFont("Fonts\\FRIZQT__.TTF", 11, "");

    _G.AchievementFont_Small:SetFont("Fonts\\FRIZQT__.ttf", 14, "OUTLINE");
    _G.QuestFont:SetFont("Fonts\\FRIZQT__.ttf", 17, "")
    _G.QuestFont_Huge:SetFont("Fonts\\FRIZQT__.ttf", 24, "")
    _G.QuestFont_Large:SetFont("Fonts\\FRIZQT__.ttf", 17, "")
    _G.QuestFont_Shadow_Small:SetFont("Fonts\\FRIZQT__.ttf", 14, "OUTLINE")
    _G.QuestFont_Super_Huge:SetFont("Fonts\\FRIZQT__.ttf", 28, "OUTLINE")
end
