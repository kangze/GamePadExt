local addonName, addonTable = ...


local db=addonTable.D;
local A={
    profile={
        actionBar={
            style={
                show_old_blizzard_action_bar=true,
            }   
        }
    },
    args={
        actionBar={
            name="动作条",
            type="group",
            args={
                style={
                    name="样式",
                    type="group",
                    args={
                        show_old_blizzard_action_bar={
                            name="显示旧的暴雪动作条",
                            type="toggle",
                            set=function(info,value)
                                db.profile.actionBar.style.show_old_blizzard_action_bar=value;
                                --E:LoadOldBlizzardActionBar();
                            end,
                            get=function(info)
                                return db.profile.actionBar.style.show_old_blizzard_action_bar;
                            end
                        }
                    }
                }
            }
        }
    }
};

addonTable.A=A;



function A:OnLoad()
    self:LoadOldBlizzardActionBar();
    self:LoadTrackingBar();
end


function A:SetNewPanel()
    -- 小眼睛
    -- QueueStatusButton:SetMovable(true);
    -- QueueStatusButton:EnableMouse(true);
    -- QueueStatusButton:RegisterForDrag("LeftButton");
    -- QueueStatusButton:SetScript("OnDragStart", function(self) self:StartMoving() end);
    -- QueueStatusButton:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end);

end