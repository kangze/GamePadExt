local _, Addon = ...


local config = {
    profile = {
        actionBar = {
            style = {
                show_old_blizzard_action_bar = true,
            }
        }
    },
    args = {
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
                                local db = Addon.db;
                                db.profile.actionBar.style.show_old_blizzard_action_bar = value;
                            end,
                            get = function(info)
                                local db = Addon.db;
                                return db.profile.actionBar.style.show_old_blizzard_action_bar;
                            end
                        }
                    }
                }
            }
        }
    }
};

Addon.A = config;

function Addon:OnLoad_ActionBar()
    if (self.db.profile.actionBar.style.show_old_blizzard_action_bar) then
        self:OnLoad_OldBlizzardActionBar();
        self:OnLoad_TrackingBar();
    end
end

function Addon:SetNewPanel()
    -- 小眼睛
    -- QueueStatusButton:SetMovable(true);
    -- QueueStatusButton:EnableMouse(true);
    -- QueueStatusButton:RegisterForDrag("LeftButton");
    -- QueueStatusButton:SetScript("OnDragStart", function(self) self:StartMoving() end);
    -- QueueStatusButton:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end);
end
