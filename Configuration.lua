local _, AddonData = ...

local AceGUI = LibStub("AceGUI-3.0");
local config = LibStub("AceConfig-3.0");
local configDialog = LibStub("AceConfigDialog-3.0");


local _G = _G;
local Gpe = _G["Gpe"];


local SettingModule = Gpe:GetModule('SettingModule')


function SettingModule:OnInitialize()
    local options = AddonData.registration.options;
    self.options = options;
end

function SettingModule:OnEnable()
    local db = AddonData.db;
    self.options.args["profiles"] = LibStub("AceDBOptions-3.0"):GetOptionsTable(db);
    config:RegisterOptionsTable("GamePadExt", self.options);
end

function SettingModule:OpenSettingPanle()
    local frame = self:CreateContainer();
    configDialog:Open("GamePadExt", frame);
end

function SettingModule:CreateContainer()
    if (GPESettingContainer) then
        return GPESettingContainer;
    end
    local frame = AceGUI:Create("Frame");
    frame:SetTitle("扩展增强包设置面板");
    frame:SetStatusText("AceGUI-3.0 Example Container Frame");
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end);
    frame:SetLayout("Flow");
    AceGUI:RegisterAsContainer(frame);
    GPESettingContainer = frame;
    frame:Hide();
    return frame;
end
