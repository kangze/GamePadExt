local _, AddonData = ...;
local Gpe = _G["Gpe"];



local ShadowFunctions = {};
AddonData.ShadowFunctions = ShadowFunctions;

local linear = AddonData.EasingFunctions.outSine;
local linear1 = AddonData.EasingFunctions.inOutSine;
local AnimationFrame = AddonData.AnimationFrame;

local originalCreateFrame = CreateFrame

local edgeFile = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\GlowTex";
_G.test = {};

local start_val = 3;
local end_val = 8;
local duration = 0.3;


--创建一个阴影frame,然后返回
local function CreateShadow(frame, edgeSize)
    local edgeSize = edgeSize or 0;
    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetFrameStrata(frame:GetFrameStrata())
    shadow:SetFrameLevel(2)
    shadow:SetOutside(shadow:GetParent(), edgeSize, edgeSize);
    shadow:SetBackdrop({ edgeFile = edgeFile, edgeSize = edgeSize })
    shadow:SetBackdropColor(0, 0, 0, 0);
    shadow:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
    return shadow;
end



local function CreateAnimation(frame, start_val, end_val, duration)
    local function callback(current)
        local current = linear(current, start_val, end_val, duration);
        frame:ClearBackdrop();
        frame:SetOutside(frame:GetParent(), current, current);
        frame:SetBackdrop({ edgeFile = edgeFile, edgeSize = current })
        frame:SetBackdropColor(0, 0, 0, 0)
        frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
    end
    local animation = AnimationFrame.New(duration, callback);
    return animation;
end

local function InitShadowAndAnimation(frame)
    local shadow = CreateShadow(frame, start_val);
    local fadeIn = CreateAnimation(shadow, start_val, end_val, duration);
    local fadeOut = CreateAnimation(shadow, end_val, start_val, duration);
    shadow._fadeIn = fadeIn;
    shadow._fadeOut = fadeOut;
    frame._shadow = shadow;
end

local function ShowShadowFadeIn(frame)
    frame._shadow._fadeIn:Show();
end

local function ShowShadowFadeOut(frame)
    frame._shadow._fadeOut:Show();
end

Gpe:AddFrameApi("InitShadowAndAnimation",InitShadowAndAnimation);
Gpe:AddFrameApi("ShowShadowFadeIn", ShowShadowFadeIn);
Gpe:AddFrameApi("ShowShadowFadeOut", ShowShadowFadeOut);
