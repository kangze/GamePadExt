local _, AddonData = ...

local _G = _G;

local AceAddon, AceAddonMinor = _G.LibStub('AceAddon-3.0');
local CallbackHandler = _G.LibStub('CallbackHandler-1.0');
local AceDB = _G.LibStub("AceDB-3.0");

--创建插件Addon对象
local Gpe = AceAddon:NewAddon("GamePadExt", "AceEvent-3.0", "AceConsole-3.0")
_G["Gpe"] = Gpe;



--创建ActionBarModule
local ActionBarModule = Gpe:NewModule("ActionBarModule", "AceEvent-3.0", "AceConsole-3.0");
local SettingModule = Gpe:NewModule("SettingModule");
local CastingBarModule = Gpe:NewModule("CastingBarModule");
local SoftTargetToolipModule = Gpe:NewModule("SoftTargetToolipModule", "AceEvent-3.0");
local NamePlateModule = Gpe:NewModule("NamePlateModule","AceEvent-3.0");
local BussniessTradeModule=Gpe:NewModule("BussniessTradeModule","AceEvent-3.0");


function Gpe:OnInitialize()
    --配置配置的默认值存储
    AddonData.registration = { profile = {}, options = { type = "group", args = {} } };
end

function Gpe:OnEnable()
    -- Addon:InitConfig_ActionBar();
    -- Addon:InitConfig_NamePlate();
    -- Addon:InitConfig_CastingBar();
    -- Addon:InitConfig_HeaderExt();
    -- Addon:InitConfig_BufferFrom();

    --配置db
    local db = AceDB:New('GamePadExtDB', { profile = AddonData.registration.profile }, true)
    AddonData.db = db;


    -- --load the addons
    -- Addon:OnLoad_SoftTargetTooltip();
    -- Addon:OnLoad_SettingPanel();
    -- Addon:OnLoad_HeaderExt();
    -- Addon:OnLoad_NamePlate();
    -- Addon:OnLoad_ActionBar();
    -- Addon:OnLoad_CastingBar()
    -- Addon:OnLoad_GamePadVirbration();
    -- Addon:OnLoad_BufferFrom();
    -- Addon:InitFoints();

    -- --Info Panel
    -- Addon:OnLoad_InfoPanel();
    -- Addon:OnLoad_InfoFrame();
end

function Gpe:OnDisable()

end

Gpe:RegisterChatCommand("gpe", "HandleCommand");

function Gpe:HandleCommand(input)
    SettingModule:OpenSettingPanle();
end

function Gpe:RegisterConfig(config)
    if config and config.profile then
        for k, v in pairs(config.profile) do
            AddonData.registration.profile[k] = v;
        end
    end
    if config and config.options then
        for k, v in pairs(config.options) do
            AddonData.registration.options.args[k] = v;
        end
    end
end

function Gpe:Open()
    --CameraFocus:Enter();
    --UIParent.startAlpha=1;
    --UIParent.endAlpha=0;

    Addon.mainFrame.startAlpha = 0;
    Addon.mainFrame.endAlpha = 1;
    --local frame = AlphaAnimationFrame.New(0.5,UIParent);
    local main = AlphaAnimationFrame.New(0.5, Addon.mainFrame);
    --frame:Show();
    main:Show();
end

function Gpe:Close()
    --Addon.mainFrame:Hide();
end
