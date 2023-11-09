local _, AddonData = ...;
local Gpe = _G["Gpe"];



local ShadowFunctions = {};
AddonData.ShadowFunctions = ShadowFunctions;

local linear = AddonData.EasingFunctions.outSine;
local linear1 = AddonData.EasingFunctions.inOutSine;
local AnimationFrame = AddonData.AnimationFrame;

local edgeFile = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\GlowTex";
_G.test = {};


--创建一个阴影frame,然后返回
local function CreateShadow(frame)
    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetFrameStrata(frame:GetFrameStrata())
    shadow:SetFrameLevel(2)
    shadow:SetOutside(frame, 0, 0);
    shadow:SetBackdrop({ edgeFile = edgeFile, edgeSize = 0 })
    shadow:SetBackdropColor(0, 0, 0, 0)
    shadow:SetBackdropBorderColor(0, 0, 0, 1);
    return shadow;
end



--shadow专有动画,所以可以直接调用.shadow属性
local function CreateAnimation1(frame, start_val, end_val, duration)
    local function callback(current)
        local current = linear(current, start_val, end_val, duration);
        frame:ClearBackdrop();
        frame:SetOutside(frame:GetParent(), current, current);
        frame:SetBackdrop({ edgeFile = edgeFile, edgeSize = current })
        frame:SetBackdropColor(0, 0, 0, 0)
        frame:SetBackdropBorderColor(0, 0, 0, 1);
    end
    local animation = AnimationFrame.New(duration, callback);
    return animation;
end

Gpe:AddFrameApi("CreateShadow", CreateShadow);
Gpe:AddFrameApi("CreateAnimation1", CreateAnimation1);
