local _, Addon = ...;
local GamePadExtAddon = LibStub("AceAddon-3.0"):NewAddon("GamePadExt", "AceEvent-3.0", "AceConsole-3.0")

Addon.GamePadExtAddon = GamePadExtAddon;

AlphaAnimationFrame=Addon.AlphaAnimationFrame;
CameraFocus=Addon.CameraFocus;

_G.GamePadExtAddon=GamePadExtAddon;


GamePadExtAddon:RegisterChatCommand("gpe", "HandleCommand");

function GamePadExtAddon:HandleCommand(input)
    Addon:OpenSettingPanle();
end
function GamePadExtAddon:Open()
    --CameraFocus:Enter();
    --UIParent.startAlpha=1;
    --UIParent.endAlpha=0;

    Addon.mainFrame.startAlpha=0;
    Addon.mainFrame.endAlpha=1;
    --local frame = AlphaAnimationFrame.New(0.5,UIParent);
    local main = AlphaAnimationFrame.New(0.5,Addon.mainFrame);
    --frame:Show();
    main:Show();
end

function GamePadExtAddon:Close()
    Addon.mainFrame:Hide();
end

function GamePadExtAddon:OnInitialize()

    --StaticPopup1.Show=StaticPopup1.Hide;

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
