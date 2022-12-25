local _, Addon = ...;
local GamePadExtAddon = LibStub("AceAddon-3.0"):NewAddon("GamePadExt", "AceEvent-3.0", "AceConsole-3.0")

Addon.GamePadExtAddon = GamePadExtAddon;

UIParentAlphaAnimtationFrame=Addon.UIParentAlphaAnimtationFrame;
CameraFocus=Addon.CameraFocus;



GamePadExtAddon:RegisterChatCommand("gpe", "HandleCommand");
GamePadExtAddon:RegisterChatCommand("gpe1", "HandleCommand1");
GamePadExtAddon:RegisterChatCommand("gpe2", "HandleCommand2");

function GamePadExtAddon:HandleCommand(input)
    Addon:OpenSettingPanle();
end
function GamePadExtAddon:HandleCommand1(input)
    CameraFocus:Enter();
end

function GamePadExtAddon:HandleCommand2(input)
    local frame = UIParentAlphaAnimtationFrame.New(0.5);
    frame:Show();
end

function GamePadExtAddon:OnInitialize()
    --init the config
    Addon:InitConfig_ActionBar();
    Addon:InitConfig_NamePlate();
    Addon:InitConfig_CastingBar();
    Addon:InitConfig_HeaderExt();
    Addon:InitConfig_BufferFrom();

    local defaults = Addon:GetDefaultProfile();
    --print(defaults.headerExt.playerExt.namefontsize);
    local db = LibStub("AceDB-3.0"):New('GamePadExtDB', defaults, true)
    Addon.db = db;

    --load the addons
    Addon:OnLoad_SettingPanel();
    Addon:OnLoad_HeaderExt();
    Addon:OnLoad_NamePlate();
    Addon:OnLoad_ActionBar();
    Addon:OnLoad_CastingBar()
    Addon:OnLoad_GamePadVirbration();
    Addon:OnLoad_BufferFrom();
    Addon:InitFoints();

    --Info Panel
    Addon:OnLoad_InfoPanel();
    Addon:OnLoad_InfoFrame();

end

function GamePadExtAddon:OnEnable()

end

function GamePadExtAddon:OnDisable()

end
