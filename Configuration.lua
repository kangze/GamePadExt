local _, Addon = ...

local AceGUI = LibStub("AceGUI-3.0");
local config = LibStub("AceConfig-3.0");
local configDialog = LibStub("AceConfigDialog-3.0");




function Addon:InitSettingPanel()
    local db=self.db;
    local options=self:GetDefaultOptions();
    local GamePadExtOptions = {
        type = "group",
        args = {
            plyerframeext = {
                name = "头像增强",
                type = "group",
                args = {
                    arg1 = {
                        name = "玩家头像",
                        type = "group",
                        args = {
                            playerName = {
                                name = "姓名大小",
                                type = "select",
                                values = { [12] = "12 px", [13] = "13 px", [14] = "14 px", [15] = "15 px", [16] = "16 px",
                                    [17] = "17 px" },
                                set = function(info, value)
                                    db.profile.headerExt.playerExt.namefontsize = value;
                                    H:SetPlayerNameSize(value);

                                end,
                                get = function(info)
                                    return db.profile.headerExt.playerExt.namefontsize;
                                end,

                            },
                            playerHealth = {
                                name = "生命大小",
                                type = "select",
                                values = { [12] = "12 px", [13] = "13 px", [14] = "14 px", [15] = "15 px", [16] = "16 px",
                                    [17] = "17 px" },
                                set = function(info, value)
                                    db.profile.headerExt.playerExt.healthfontsize = value;
                                    H:SetPlayerHealthStatusText(value);
                                end,
                                get = function(info)
                                    return db.profile.headerExt.playerExt.healthfontsize;
                                end,

                            },
                        }
                    }
                }
            },
            buffer={
                name="增益",
                type="group",
                args={
                    arg1={
                        name="玩家增益",
                        type="group",
                        args={
                            bufferFrom = {
                                name = "开启或者关闭增益来源",
                                type = "toggle",
                                set = function(info, value)
                                    db.profile.buffer.from = value;
                                    H:SetPlayerNameSize(value);
                                end,
                                get = function(info)
                                    return db.profile.buffer.from;
                                end,

                            },
                        }
                    }
                }
            },
            
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
