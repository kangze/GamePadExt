local addonName, addonTable = ...;
local E = addonTable.E;
local F =addonTable.F;
local H =addonTable.H;
local B=addonTable.B;
local N=addonTable.N;
local GamePadExtAddon = LibStub("AceAddon-3.0"):NewAddon("GamePadExt", "AceEvent-3.0","AceConsole-3.0")
local unpack = unpack;

GamePadExtAddon:RegisterChatCommand("gpe", "HandleCommand");

addonTable.GamePadExtAddon=GamePadExtAddon;


function GamePadExtAddon:HandleCommand(input)
    F:OpenSettingPanle();
end


PlayerCastingBarFrame:HookScript("OnEvent", function(arg)
    arg.Text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE");
    arg.Text:SetPoint("TOP", 0, -12);
    arg.Icon:Show();    
end);



WorldMapFrame:HookScript("OnShow", function(arg)
    arg:SetScale(1.3);
end);

CharacterFrame:HookScript("OnShow", function(arg)
    arg:SetScale(1.12);
end);

--AchievementFrame:SetScale(1.2); //有点问题
--DressUpFrame:SetScale(1.5);



--PlayerFrameHealthBarText:SetFont("Fonts\\FRIZQT__.TTF", 11, "");
--PlayerFrameHealthBarText:SetPoint("TOP", 0, -5);


--PlayerFrameManaBarText:SetFont("Fonts\\FRIZQT__.TTF", 10, "");
--PlayerFrameManaBarText:SetPoint("TOP", 0, -2);
-- PlayerFrame:HookScript("OnLoad",function(arg)

-- end);


--PartyMemberFrameMixin
-- hooksecurefunc(PartyFrame, "Layout", function(self)
--     print(1);
--     local memberFrame = self.PartyMemberFramePool:Acquire();
--     if (memberFrame ~= nil) then
--         print(memberFrame.Name:GetText())
--         memberFrame:HookScript("OnShow", function(arg)
--             arg.Name:SetFont("Fonts\\FRIZQT__.TTF", 5, "");
--         end);
--     end
--     --memberFrame.Name:SetFont("Fonts\\FRIZQT__.TTF",5,"");

-- end);

local function SetFont(obj, font, size, style, sr, sg, sb, sa, sox, soy, r, g, b)
    if not obj then return end

    -- convert because of bad values between versions
    if (style == 'NONE' or not style) and 1 then
        style = ''
    elseif (style == '' or not style) and not 1 then
        style = 'NONE'
    end

    obj:SetFont(font, size, style)

    if sr and sg and sb then
        obj:SetShadowColor(sr, sg, sb, sa)
    end

    if sox and soy then
        obj:SetShadowOffset(sox, soy)
    end

    if r and g and b then
        obj:SetTextColor(r, g, b)
    elseif r then
        obj:SetAlpha(r)
    end
end

function GamePadExtAddon:OnInitialize()

    F:InitSettingPanel();
    
    H:InitHeaderExt();
    N:InitNamePlate();
    E:ActionBarExt();
    E:InitGamePadVirbration();
    B:InitBuffFrom();



    _G.AchievementFont_Small:SetFont("Fonts\\FRIZQT__.ttf", 14, "OUTLINE");
    _G.QuestFont:SetFont("Fonts\\FRIZQT__.ttf", 17, "")
    _G.QuestFont_Huge:SetFont("Fonts\\FRIZQT__.ttf", 24, "")
    _G.QuestFont_Large:SetFont("Fonts\\FRIZQT__.ttf", 17, "")
    _G.QuestFont_Shadow_Small:SetFont("Fonts\\FRIZQT__.ttf", 14, "OUTLINE")
    _G.QuestFont_Super_Huge:SetFont("Fonts\\FRIZQT__.ttf", 28, "OUTLINE")
    --_G.GameFontNormalSmall:SetFont("Fonts\\FRIZQT__.ttf",9,"OUTLINE")

    -- SetFont(_G.QuestFont,							NORMAL, size)								-- 13
    -- SetFont(_G.QuestFont_Enormous, 					NORMAL, stock and enormous or 24)			-- 30  Garrison Titles
    -- SetFont(_G.QuestFont_Huge,						NORMAL, stock and huge or 15)				-- 18  Quest rewards title(Rewards)
    -- SetFont(_G.QuestFont_Large,						NORMAL, stock and large or 14)				-- 14
    -- SetFont(_G.QuestFont_Shadow_Huge,				NORMAL, stock and huge or 15)				-- 18  Quest Title
    -- SetFont(_G.QuestFont_Shadow_Small,				NORMAL, stock and size or 14)				-- 14
    -- SetFont(_G.QuestFont_Super_Huge,				NORMAL, stock and mega or 22)				-- 24
    --SetFont(_G.AchievementFont_Small,				NORMAL, 18)	-- 10  Achiev dates
    --SetFont(_G.BossEmoteNormalHuge,					NORMAL, 24)							-- Talent Title
    -- SetFont(_G.CoreAbilityFont,						NORMAL, 26)							-- 32  Core abilities(title)
    -- SetFont(_G.DestinyFontHuge,						NORMAL, 32)							-- Garrison Mission Report
    -- SetFont(_G.DestinyFontMed,						NORMAL, 14)							-- Added in 7.3.5 used for ?
    -- SetFont(_G.Fancy12Font,							NORMAL, 12)							-- Added in 7.3.5 used for ?
    -- SetFont(_G.Fancy14Font,							NORMAL, 14)							-- Added in 7.3.5 used for ?
    -- SetFont(_G.Fancy22Font,							NORMAL, stock and 22 or 20)			-- Talking frame Title font
    -- SetFont(_G.Fancy24Font,							NORMAL, stock and 24 or 20)			-- Artifact frame - weapon name
    -- SetFont(_G.FriendsFont_11,						NORMAL, 11)
    -- SetFont(_G.FriendsFont_Large,					NORMAL, stock and large or size)	-- 14
    -- SetFont(_G.FriendsFont_Normal,					NORMAL, size)						-- 12
    -- SetFont(_G.FriendsFont_Small,					NORMAL, stock and small or size)	-- 10
    -- SetFont(_G.FriendsFont_UserText,				NORMAL, size)						-- 11
    -- SetFont(_G.Game10Font_o1,						NORMAL, 10, 'OUTLINE')
    -- SetFont(_G.Game120Font,							NORMAL, 120)
    -- SetFont(_G.Game12Font,							NORMAL, 12)							-- PVP Stuff
    -- SetFont(_G.Game13FontShadow,					NORMAL, stock and 13 or 14)			-- InspectPvpFrame
    -- SetFont(_G.Game15Font_o1,						NORMAL, 15)							-- CharacterStatsPane (ItemLevelFrame)
    -- SetFont(_G.Game16Font,							NORMAL, 16)							-- Added in 7.3.5 used for ?
    -- SetFont(_G.Game18Font,							NORMAL, 18)							-- MissionUI Bonus Chance
    -- SetFont(_G.Game24Font,							NORMAL, 24)							-- Garrison Mission level (in detail frame)
    -- SetFont(_G.Game30Font,							NORMAL, 30)							-- Mission Level
    -- SetFont(_G.Game40Font,							NORMAL, 40)
    -- SetFont(_G.Game42Font,							NORMAL, 42)							-- PVP Stuff
    -- SetFont(_G.Game46Font,							NORMAL, 46)							-- Added in 7.3.5 used for ?
    -- SetFont(_G.Game48Font,							NORMAL, 48)
    -- SetFont(_G.Game48FontShadow,					NORMAL, 48)
    -- SetFont(_G.Game60Font,							NORMAL, 60)
    -- SetFont(_G.Game72Font,							NORMAL, 72)
    -- SetFont(_G.GameFont_Gigantic,					NORMAL, 32)							-- Used at the install steps
    -- SetFont(_G.GameFontHighlightMedium,				NORMAL, stock and medium or 15)		-- 14  Fix QuestLog Title mouseover
    -- SetFont(_G.GameFontHighlightSmall2,				NORMAL, stock and small or size)	-- 11  Skill or Recipe description on TradeSkill frame
    -- SetFont(_G.GameFontNormalHuge2,					NORMAL, stock and huge or 24)		-- 24  Mythic weekly best dungeon name
    -- SetFont(_G.GameFontNormalLarge,					NORMAL, stock and large or 16)		-- 16
    -- SetFont(_G.GameFontNormalLarge2,				NORMAL, stock and large or 15)		-- 18  Garrison Follower Names
    -- SetFont(_G.GameFontNormalMed1,					NORMAL, stock and medium or 14)		-- 13  WoW Token Info
    -- SetFont(_G.GameFontNormalMed2,					NORMAL, stock and medium or medium)	-- 14  Quest tracker
    -- SetFont(_G.GameFontNormalMed3,					NORMAL, stock and medium or 15)		-- 14
    -- SetFont(_G.GameFontNormalSmall2,				NORMAL, stock and small or 12)		-- 11  MissionUI Followers names
    -- SetFont(_G.GameTooltipHeader,					NORMAL, size)						-- 14
    -- SetFont(_G.InvoiceFont_Med,						NORMAL, stock and size or 12)		-- 12  Mail
    -- SetFont(_G.InvoiceFont_Small,					NORMAL, stock and small or size)	-- 10  Mail
    -- SetFont(_G.MailFont_Large,						NORMAL, 14)							-- 10  Mail
    -- SetFont(_G.Number11Font,						NORMAL, 11)
    -- SetFont(_G.Number11Font,						NUMBER, 11)
    -- SetFont(_G.Number12Font,						NORMAL, 12)
    -- SetFont(_G.Number12Font_o1,						NUMBER, 12, 'OUTLINE')
    -- SetFont(_G.Number13Font,						NUMBER, 13)
    -- SetFont(_G.Number13FontGray,					NUMBER, 13)
    -- SetFont(_G.Number13FontWhite,					NUMBER, 13)
    -- SetFont(_G.Number13FontYellow,					NUMBER, 13)
    -- SetFont(_G.Number14FontGray,					NUMBER, 14)
    -- SetFont(_G.Number14FontWhite,					NUMBER, 14)
    -- SetFont(_G.Number15Font,						NORMAL, 15)
    -- SetFont(_G.Number18Font,						NUMBER, 18)
    -- SetFont(_G.Number18FontWhite,					NUMBER, 18)
    -- SetFont(_G.NumberFont_Outline_Huge,				NUMBER, stock and huge or 28, thick)		-- 30
    -- SetFont(_G.NumberFont_Outline_Large,			NUMBER, stock and large or 15, outline)		-- 16
    -- SetFont(_G.NumberFont_Outline_Med,				NUMBER, medium, 'OUTLINE')					-- 14
    -- SetFont(_G.NumberFont_OutlineThick_Mono_Small,	NUMBER, size, 'OUTLINE')					-- 12
    -- SetFont(_G.NumberFont_Shadow_Med,				NORMAL, stock and medium or size)			-- 14  Chat EditBox
    -- SetFont(_G.NumberFont_Shadow_Small,				NORMAL, stock and small or size)			-- 12
    -- SetFont(_G.NumberFontNormalSmall,				NORMAL, stock and small or 11, 'OUTLINE')	-- 12  Calendar, EncounterJournal
    -- SetFont(_G.PriceFont,							NORMAL, 13)
    -- SetFont(_G.PVPArenaTextString,					NORMAL, 22, outline)
    -- SetFont(_G.PVPInfoTextString,					NORMAL, 22, outline)
    -- SetFont(_G.QuestFont,							NORMAL, size)								-- 13
    -- SetFont(_G.QuestFont_Enormous, 					NORMAL, stock and enormous or 24)			-- 30  Garrison Titles
    -- SetFont(_G.QuestFont_Huge,						NORMAL, stock and huge or 15)				-- 18  Quest rewards title(Rewards)
    -- SetFont(_G.QuestFont_Large,						NORMAL, stock and large or 14)				-- 14
    -- SetFont(_G.QuestFont_Shadow_Huge,				NORMAL, stock and huge or 15)				-- 18  Quest Title
    -- SetFont(_G.QuestFont_Shadow_Small,				NORMAL, stock and size or 14)				-- 14
    -- SetFont(_G.QuestFont_Super_Huge,				NORMAL, stock and mega or 22)				-- 24
    -- SetFont(_G.ReputationDetailFont,				NORMAL, size)								-- 10  Rep Desc when clicking a rep
    -- SetFont(_G.SpellFont_Small,						NORMAL, 10)
    -- SetFont(_G.SubSpellFont,						NORMAL, 10)									-- Spellbook Sub Names
    -- SetFont(_G.SubZoneTextFont,						NORMAL, 24, outline)						-- 26  World Map(SubZone)
    -- SetFont(_G.SubZoneTextString,					NORMAL, 25, outline)						-- 26
    -- SetFont(_G.SystemFont_Huge1, 					NORMAL, 20)									-- Garrison Mission XP
    -- SetFont(_G.SystemFont_Huge1_Outline,			NORMAL, 18, outline)						-- 20  Garrison Mission Chance
    -- SetFont(_G.SystemFont_Huge2,					NORMAL, 22)									-- 22  Mythic+ Score
    -- SetFont(_G.SystemFont_Large,					NORMAL, stock and 16 or 15)
    -- SetFont(_G.SystemFont_Med1,						NORMAL, size)								-- 12
    -- SetFont(_G.SystemFont_Med3,						NORMAL, medium)								-- 14
    -- SetFont(_G.SystemFont_Outline,					NORMAL, stock and size or 13, outline)		-- 13  Pet level on World map
    -- SetFont(_G.SystemFont_Outline_Small,			NUMBER, stock and small or size, 'OUTLINE')	-- 10
    -- SetFont(_G.SystemFont_OutlineThick_Huge2,		NORMAL, stock and huge or 20, thick)		-- 22
    -- SetFont(_G.SystemFont_OutlineThick_WTF,			NORMAL, stock and enormous or 32, outline)	-- 32  World Map
    -- SetFont(_G.SystemFont_Shadow_Huge1,				NORMAL, 20, outline)						-- Raid Warning, Boss emote frame too
    -- SetFont(_G.SystemFont_Shadow_Huge3,				NORMAL, 22)									-- 25  FlightMap
    -- SetFont(_G.SystemFont_Shadow_Huge4,				NORMAL, 27, nil, nil, nil, nil, nil, 1, -1)
    -- SetFont(_G.SystemFont_Shadow_Large,				NORMAL, 15)
    -- SetFont(_G.SystemFont_Shadow_Large2,			NORMAL, 18)									-- Auction House ItemDisplay
    -- SetFont(_G.SystemFont_Shadow_Large_Outline,		NUMBER, 20, 'OUTLINE')						-- 16
    -- SetFont(_G.SystemFont_Shadow_Med1,				NORMAL, size)								-- 12
    -- SetFont(_G.SystemFont_Shadow_Med2,				NORMAL, stock and medium or 14.3)			-- 14  Shows Order resourses on OrderHallTalentFrame
    -- SetFont(_G.SystemFont_Shadow_Med3,				NORMAL, medium)								-- 14
    -- SetFont(_G.SystemFont_Shadow_Small,				NORMAL, small)								-- 10
    -- SetFont(_G.SystemFont_Small,					NORMAL, stock and small or size)			-- 10
    -- SetFont(_G.SystemFont_Tiny,						NORMAL, stock and tiny or size)				-- 09
    -- SetFont(_G.Tooltip_Med,							NORMAL, size)								-- 12
    -- SetFont(_G.Tooltip_Small,						NORMAL, stock and small or size)			-- 10
    -- SetFont(_G.ZoneTextString,						NORMAL, stock and enormous or 32, outline)


end

function GamePadExtAddon:OnEnable()
    --GamePadExt:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
end

function GamePadExtAddon:OnDisable()
    --GamePadExt:UnregisterEvent("CURRENCY_DISPLAY_UPDATE");
end

--init the
function GamePadExtAddon:InitActionBar()
    --创建动作条
    local frame = CreateFrame("Frame", nil, UIParent);
    frame:SetSize(800, 45);
    frame:SetMovable(true);
    frame:SetPoint("BOTTOM", 0, 10)
    -- frame.tex=frame:CreateTexture();
    -- frame.tex:SetAllPoints(frame);
    -- frame.tex:SetTexture("Interface/MAINMENUBAR/MainMenuBar","CLAMPTOWHITE");
    -- frame.tex:SetSize(950,88);
    -- frame.tex:SetTexCoord(0.03,0.15,0.33,0.62);
    --frame.tex:SetColorTexture(1, 1, 1, 0.5);



    frame.tex2 = frame:CreateTexture();
    frame.tex2:SetAllPoints(frame);
    frame.tex2:SetTexture("Interface/MAINMENUBAR/MainMenuBar", "CLAMPTOWHITE");
    frame.tex2:SetSize(800, 45);
    frame.tex2:SetTexCoord(0.16, 0.94, 0.39, 0.58);
    --frame.tex2:Hide();
end
