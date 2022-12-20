local addonName, Addon = ...;
local E = Addon.E;
local F =Addon.F;
local H =Addon.H;
local B=Addon.B;
local N=Addon.N;
local A=Addon.A;
local GamePadExtAddon = LibStub("AceAddon-3.0"):NewAddon("GamePadExt", "AceEvent-3.0","AceConsole-3.0")

Addon.GamePadExtAddon=GamePadExtAddon;



GamePadExtAddon:RegisterChatCommand("gpe", "HandleCommand");
function GamePadExtAddon:HandleCommand(input)
    Addon:OpenSettingPanle();
end


CharacterFrame:HookScript("OnShow", function(arg)
    arg:SetScale(1.12);
end);


-- local defaults = {
--     profile = {
--         headerExt = {
--             playerExt = {
--                 namefontsize = 12,
--                 healthfontsize = 11,
--             }
--         },
--         buffer={
--             from=true
--         }
--     }
-- }
-- for k,v in pairs(A.profile) do
--     defaults.profile[k]=v;
-- end


function GamePadExtAddon:OnInitialize()
    --init the config
    Addon:InitConfig_ActionBar();
    Addon:InitConfig_NamePlate();
    Addon:InitConfig_CastingBar();
    local defaults=Addon:GetDefaultProfile();

    local db = LibStub("AceDB-3.0"):New('GamePadExtDB', defaults, true)
    Addon.db = db;

    --load the addons
    Addon:InitSettingPanel();
    H:InitHeaderExt();
    Addon:InitNamePlate();
    Addon:OnLoad_ActionBar();
    Addon:OnLoad_CastingBar()
    E:InitGamePadVirbration();
    B:InitBuffFrom();
    
end

function GamePadExtAddon:OnEnable()
    
end

function GamePadExtAddon:OnDisable()
    
end