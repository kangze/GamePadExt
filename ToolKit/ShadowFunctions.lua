local _, AddonData = ...;
local Gpe = _G["Gpe"];



local ShadowFunctions = {};
AddonData.ShadowFunctions = ShadowFunctions;

local linear = AddonData.EasingFunctions.outSine;
local linear1 = AddonData.EasingFunctions.inOutSine;
local AnimationFrame = AddonData.AnimationFrame;

local edgeFile = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\GlowTex";
_G.test = {};

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

--创建一个阴影frame,然后返回
local function CreateShadow(frame)
    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetFrameStrata(frame:GetFrameStrata())
    shadow:SetFrameLevel(1)
    SetOutside(shadow, frame, 2, 2);
    shadow:SetBackdrop({ edgeFile = edgeFile, edgeSize = 2 })
    shadow:SetBackdropColor(0, 0, 0, 0)
    shadow:SetBackdropBorderColor(0, 0, 0, 1);

    frame.shadowFrame = shadow;
    return shadow;
end

Gpe:AddFrameApi()

--shadow专有动画,所以可以直接调用.shadow属性
function ShadowFunctions.CreateAnimation(frame, start_val, end_val, duration)
    local function callback(current)
        local current = linear(current, start_val, end_val, duration);
        frame.shadowFrame:ClearBackdrop();
        SetOutside(frame.shadowFrame, frame, current, current);
        frame.shadowFrame:SetBackdrop({ edgeFile = edgeFile, edgeSize = current })
        frame.shadowFrame:SetBackdropColor(0, 0, 0, 0)
        frame.shadowFrame:SetBackdropBorderColor(0, 0, 0, 1);
    end
    local animation = AnimationFrame.New(duration, callback);
    return animation;
end
