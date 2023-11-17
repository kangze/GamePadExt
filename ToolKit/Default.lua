local _, AddonData = ...;
local Gpe = _G["Gpe"];


local sin = math.sin;
local cos = math.cos;
local pow = math.pow;
local pi = math.pi;


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

--宽展内置的frameapi
local function Point(obj, arg1, arg2, arg3, arg4, arg5)
    obj:SetPoint(arg1, arg2 or obj:GetParent(), arg3, arg4, arg5)
end

local function SetOutside(obj, anchor, xOffset, yOffset, anchor2)
    xOffset = xOffset --or E.Border
    yOffset = yOffset --or E.Border
    anchor = anchor or obj:GetParent()
    Point(obj, "TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
    Point(obj, "BOTTOMRIGHT", anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

Gpe:AddFrameApi("Point", Point);
Gpe:AddFrameApi("SetOutside", SetOutside);


---缓动函数
--t: total time elapsed
--b: beginning position
--e: ending position
--d: animation duration
function Linear(t, b, e, d)
    return (e - b) * t / d + b
end

function OutSine(t, b, e, d)
    return (e - b) * sin(t / d * (pi / 2)) + b
end

function InOutSine(t, b, e, d)
    return -(e - b) / 2 * (cos(pi * t / d) - 1) + b
end

function OutQuart(t, b, e, d)
    t = t / d - 1;
    return (b - e) * (pow(t, 4) - 1) + b
end

function OutQuint(t, b, e, d)
    t = t / d
    return (b - e) * (pow(1 - t, 5) - 1) + b
end

function InQuad(t, b, e, d)
    t = t / d
    return (e - b) * pow(t, 2) + b
end

--创建动画帧
function CreateAnimationFrame(duration, callback)
    local frame = CreateFrame("Frame");
    frame.current = 0;
    frame:Hide();
    local updateCallback = function(selfs, elapsed)
        selfs.current = selfs.current + elapsed;
        if (callback) then
            callback(selfs.current)
        end
        if (selfs.current >= duration) then
            selfs:Hide();
            selfs.current = 0;
            return;
        end
    end
    frame:SetScript("OnUpdate", updateCallback);
    return frame;
end
