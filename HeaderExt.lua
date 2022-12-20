local _,Addon = ...;


function Addon:InitConfig_HeaderExt()
    local db=Addon.db;
    local this=self;
    local config = {
        default_profile = {
            headerExt = {
                playerExt = {
                    namefontsize = 12,
                    healthfontsize = 11,
                }
            },
        },
        options = {
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
                                    this:SetPlayerNameSize(value);

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
                                    this:SetPlayerHealthStatusText(value);
                                end,
                                get = function(info)
                                    return db.profile.headerExt.playerExt.healthfontsize;
                                end,

                            },
                        }
                    }
                }
            },
        }
    };
    self:RegisterConfig(config);
end


function Addon:OnLoad_HeaderExt()
    local db = Addon.db;
    self:SetPlayerNameSize(db.profile.headerExt.playerExt.namefontsize);
    self:SetPlayerHealthStatusText(db.profile.headerExt.playerExt.healthfontsize);
end

function Addon:SetPlayerNameSize(size)
    PlayerName:SetFont("Fonts\\FRIZQT__.TTF", size, "OUTLINE");
end

function H:SetPlayerHealthStatusText(size)
    local HealthBar = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar;
    if (HealthBar.LeftText) then
        HealthBar.LeftText:SetFont("Fonts\\FRIZQT__.TTF", size, "");
    end
    if (HealthBar.RightText) then
        HealthBar.RightText:SetFont("Fonts\\FRIZQT__.TTF", size, "");
    end
    if (HealthBar.TextString) then
        HealthBar.TextString:SetFont("Fonts\\FRIZQT__.TTF", size, "");
    end
end
