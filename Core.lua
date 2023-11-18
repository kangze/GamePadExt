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
local NamePlateModule = Gpe:NewModule("NamePlateModule", "AceEvent-3.0");
local MerchantModule = Gpe:NewModule("MerchantModule", "AceEvent-3.0", "AceHook-3.0");
local ToolKitModule = Gpe:NewModule("ToolKitModule");

--配置配置的默认值存储
AddonData.registration = { profile = {}, options = { type = "group", args = {} } };


function Gpe:OnInitialize()
    --配置db
    local db = AceDB:New('GamePadExtDB', { profile = AddonData.registration.profile }, true)
    AddonData.db = db;
end

function Gpe:OnEnable()
    
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


