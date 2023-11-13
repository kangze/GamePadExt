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



--shadow专有动画,所以可以直接调用.shadow属性
local function CreateAnimation1(frame, start_val, end_val, duration)
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

local function ShowShadowAnimation(frame, options, isFadeIn)
    if (not frame._shadow) then
        local shadow = frame:CreateShadow();
        frame._shadow = shadow;
    end

    local animationKey = isFadeIn and "_fadeIn" or "_fadeOut"
    if (frame._shadow[animationKey]) then
        frame._shadow[animationKey]:Show();
        return;
    end

    options = options or {}
    local start_val = isFadeIn and (options.start_val or 2) or (options.start_val or 8)
    local end_val = isFadeIn and (options.end_val or 8) or (options.end_val or 2)
    local duration = options.duration or 0.3

    frame._shadow[animationKey] = frame._shadow:CreateAnimation1(start_val, end_val, duration)
    frame._shadow[animationKey]:Show();
end

local function ShowShadowFadeIn(frame, options)
    ShowShadowAnimation(frame, options, true)
end

local function ShowShadowFadeOut(frame, options)
    ShowShadowAnimation(frame, options, false)
end


Gpe:AddFrameApi("CreateShadow", CreateShadow);
Gpe:AddFrameApi("CreateAnimation1", CreateAnimation1);
Gpe:AddFrameApi("ShowShadowFadeIn", ShowShadowFadeIn);
Gpe:AddFrameApi("ShowShadowFadeOut", ShowShadowFadeOut);


