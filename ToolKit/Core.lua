local _, AddonData = ...;
local Gpe = _G["Gpe"];





local ToolKitModule = Gpe:GetModule('ToolKitModule');

--全局基础组件的配置
function ToolKitModule:OnInitialize()
    local config = {
        profile = {
            shadow = {
                style = {
                    start_val = 3,
                    end_val = 8,
                    duration = 0.3,
                    color = { r = 0.5, g = 0.5, b = 0.5, a = 1 }
                }
            }
        },
        options = {
            shadow = {
                name = "阴影",
                type = "group",
                args = {
                    style = {
                        name = "样式",
                        type = "group",
                        args = {
                            start_val = {
                                name = "开始值",
                                type = "range",
                                min = 0,
                                max = 30,
                                step = 1,
                                set = function(info, value)
                                    local db = AddonData.db;
                                    db.profile.shadow.style.start_val = value;
                                end,
                                get = function(info)
                                    local db = AddonData.db;
                                    return db.profile.shadow.style.start_val;
                                end
                            },
                            end_val = {
                                name = "结束值",
                                type = "range",
                                min = 0,
                                max = 30,
                                step = 1,
                                set = function(info, value)
                                    local db = AddonData.db;
                                    db.profile.shadow.style.end_val = value;
                                end,
                                get = function(info)
                                    local db = AddonData.db;
                                    return db.profile.shadow.style.end_val;
                                end
                            },
                            duration = {
                                name = "持续时间",
                                type = "range",
                                min = 0,
                                max = 1,
                                step = 0.1,
                                set = function(info, value)
                                    local db = AddonData.db;
                                    db.profile.shadow.style.duration = value;
                                end,
                                get = function(info)
                                    local db = AddonData.db;
                                    return db.profile.shadow.style.duration;
                                end
                            },
                            color = {
                                name = "颜色",
                                type = "color",
                                hasAlpha = true,
                                set = function(info, r, g, b, a)
                                    local db = AddonData.db;
                                    db.profile.shadow.style.color.r = r;
                                    db.profile.shadow.style.color.g = g;
                                    db.profile.shadow.style.color.b = b;
                                    db.profile.shadow.style.color.a = a;
                                end,
                                get = function(info)
                                    local db = AddonData.db;
                                    local color = db.profile.shadow.style.color;
                                    return color.r, color.g, color.b, color.a;
                                end
                            }
                        }
                    }
                }
            }
        }
    }
    Gpe:RegisterConfig(config);
end



--基础API
function Gpe:AddApi(frameType, name, func)
    self:AddFrameApi(name, func);
end

function Gpe:AddFrameApi(name, func)
    local frame = CreateFrame("Frame");
    local mk = getmetatable(frame).__index;
    if not mk[name] then mk[name] = func end
end





