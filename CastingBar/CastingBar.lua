local _, AddonData = ...;
local Gpe = _G["Gpe"];

local unpack = unpack;

local CastingBarModule = Gpe:GetModule('CastingBarModule');
local Masque, MSQ_Version = LibStub("Masque", true);



function CastingBarModule:OnInitialize()
    local config = {
        profile = {
            castingBar = {
                style = {
                    width = 450, --255,
                    height = 18, -- 15,
                    icon = true,
                    iconWidth = 24,
                }
            }
        },
        options = {
            castingBbar = {
                name = "施法条增强",
                type = "group",
                args = {
                    style = {
                        name = "样式",
                        type = "group",
                        args = {
                            width = {
                                name = "长度",
                                type = "range",
                                min = 100,
                                max = 800,
                                step = 20,
                                set = function(info, value)
                                    local db = AddonData.db;
                                    db.profile.castingBar.style.width = value;
                                end,
                                get = function(info)
                                    local db = AddonData.db;
                                    return db.profile.castingBar.style.width;
                                end
                            }
                        }
                    }
                }
            }
        }
    }
    Gpe:RegisterConfig(config);
    if Masque then
        local myGroup = Masque:Group("GamePadExt", "myBar1");
        self.myGroup = myGroup;
    end
end

function CastingBarModule:OnEnable()
    local style = AddonData.db.profile.castingBar.style;
    PlayerCastingBarFrame:Show();
    
    --TODO:必须是一个Button才能AddButton
    local module=self;
    PlayerCastingBarFrame:HookScript("OnEvent", function(arg)
        arg.Text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE");
        arg.Text:SetPoint("TOP", 0, -12);
        arg:SetHeight(style.height);
        arg:SetWidth(style.width);
        if (style.icon) then
            arg.Icon:HookScript("OnEvent",function(arg1)
                module.myGroup:AddButton(arg1);
            end);
            arg.Icon:Show();
            arg.Icon:SetWidth(style.iconWidth*3);
            arg.Icon:SetHeight(style.iconWidth*3);
            arg.Icon:ClearAllPoints();
            arg.Icon:SetPoint("RIGHT", arg, "LEFT", -2, -5);
        end
    end);
end
