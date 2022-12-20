local _, Addon = ...

local AceGUI = LibStub("AceGUI-3.0");
local config = LibStub("AceConfig-3.0");
local configDialog = LibStub("AceConfigDialog-3.0");




function Addon:OnLoad_SettingPanel()
    local db=self.db;
    local options=self:GetDefaultOptions();
    local GamePadExtOptions = {
        type = "group",
        args = {
            
           
            
        }
    }
    options["profiles"] = LibStub("AceDBOptions-3.0"):GetOptionsTable(db);
    config:RegisterOptionsTable("GamePadExt", options);
    --configDialog:Open("GamePadExt", frame);
end

function Addon:OpenSettingPanle()
    local frame = CreateContainer();
    configDialog:Open("GamePadExt", frame);
end

function CreateContainer()
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
