local _, AddonData = ...;
local Gpe = _G["Gpe"];

local db = AddonData.db;

local ActionBarModule = Gpe:GetModule('ActionBarModule')


function ActionBarModule:OnInitialize()
    --配置db
    local config = {
        profile = {
            actionBar = {
                style = {
                    show_old_blizzard_action_bar = true,
                }
            }
        },
        options = {
            actionBar = {
                name = "动作条",
                type = "group",
                args = {
                    style = {
                        name = "样式",
                        type = "group",
                        args = {
                            show_old_blizzard_action_bar = {
                                name = "显示旧的暴雪动作条",
                                type = "toggle",
                                set = function(info, value)
                                    local db = AddonData.db;
                                    db.profile.actionBar.style.show_old_blizzard_action_bar = value;
                                    self:ShowBlizzardStyleActionBar(value);
                                end,
                                get = function(info)
                                    local db = AddonData.db;
                                    return db.profile.actionBar.style.show_old_blizzard_action_bar;
                                end
                            }
                        }
                    }
                }
            }
        }
    };
    Gpe:RegisterConfig(config);
end

function ActionBarModule:OnEnable()
    self:ShowBlizzardStyleActionBar(AddonData.db.profile.actionBar.style.show_old_blizzard_action_bar)
end

function ActionBarModule:ShowBlizzardStyleActionBar(enable)
    if (enable) then
        self:ApplyOldBlizzardActionBar();
        self:AdjustTrackingBar();
    else
        self:NoApplyBlizzardBar();
    end
end
