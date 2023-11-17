local _, AddonData = ...;
local Gpe = _G["Gpe"];


local edgeFile = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\GlowTex";

--创建一个阴影frame,然后返回
local function CreateShadow(frame, edgeSize, color)
    local edgeSize = edgeSize or 0;
    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetFrameStrata(frame:GetFrameStrata())
    shadow:SetFrameLevel(2)
    shadow:SetOutside(shadow:GetParent(), edgeSize, edgeSize);
    shadow:SetBackdrop({ edgeFile = edgeFile, edgeSize = edgeSize })
    shadow:SetBackdropColor(color.r, color.g, color.b, color.a);
    shadow:SetBackdropBorderColor(color.r, color.g, color.b, color.a);
    return shadow;
end

local function CreateAnimation(frame, start_val, end_val, duration, color)
    local function callback(current)
        local current = OutSine(current, start_val, end_val, duration);
        frame:ClearBackdrop();
        frame:SetOutside(frame:GetParent(), current, current);
        frame:SetBackdrop({ edgeFile = edgeFile, edgeSize = current })
        frame:SetBackdropColor(color.r, color.g, color.b, color.a)
        frame:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
    end
    local animation = CreateAnimationFrame(duration, callback);
    return animation;
end

local function InitShadowAndAnimation(frame)
    local start_val, end_val, duration = AddonData.db.profile.shadow.style.start_val,
        AddonData.db.profile.shadow.style.end_val, AddonData.db.profile.shadow.style.duration;
    local color = AddonData.db.profile.shadow.style.color;
    local shadow = CreateShadow(frame, start_val, color);
    local fadeIn = CreateAnimation(shadow, start_val, end_val, duration, color);
    local fadeOut = CreateAnimation(shadow, end_val, start_val, duration, color);
    shadow._fadeIn = fadeIn;
    shadow._fadeOut = fadeOut;
    frame._shadow = shadow;
end

local function ScaleFadeIn(frame)
    local callback = function(current)
        local current = OutSine(current, 1, 1.04, 0.1);
        frame:SetScale(current);
    end
    local animation = CreateAnimationFrame(0.1, callback);
    animation:Show();
end

local function ScaleFadeOut(frame)
    local callback = function(current)
        local current = OutSine(current, 1.04,1, 0.1);
        frame:SetScale(current);
    end
    local animation = CreateAnimationFrame(0.1, callback);
    animation:Show();
end

local function ShowShadowFadeIn(frame)
    frame._shadow._fadeIn:Show();
end

local function ShowShadowFadeOut(frame)
    frame._shadow._fadeOut:Show();
end

local function ShowShadow(frame)
    frame._shadow:Show();
end

local function InitShowFadeInAndOut(frame)
    local start = 1;
    local ends = 0;
    local duration = 0.2
    local callbackOut = function(current)
        local current = OutSine(current, start, ends, duration);
        frame:SetAlpha(current);
    end;
    local callbackIn = function(current)
        local current = OutSine(current, ends, start, duration);
        frame:SetAlpha(current);
    end;
    local animationOut = CreateAnimationFrame(duration, callbackOut);
    local animationIn = CreateAnimationFrame(duration, callbackIn);
    frame._showFadeOut = animationOut;
    frame._showFadeIn = animationIn;
end

local function ShowFadeIn(frame)
    frame._showFadeIn:Show();
end

local function ShowFadeOut(frame)
    frame._showFadeOut:Show();
end

Gpe:AddFrameApi("InitShadowAndAnimation", InitShadowAndAnimation);
Gpe:AddFrameApi("ShowShadowFadeIn", ShowShadowFadeIn);
Gpe:AddFrameApi("ShowShadowFadeOut", ShowShadowFadeOut);

Gpe:AddFrameApi("InitShowFadeInAndOut", InitShowFadeInAndOut)
Gpe:AddFrameApi("ShowFadeIn", ShowFadeIn)
Gpe:AddFrameApi("ShowFadeOut", ShowFadeOut)
Gpe:AddFrameApi("ShowShadow", ShowShadow)

Gpe:AddFrameApi("ScaleFadeIn", ScaleFadeIn)
Gpe:AddFrameApi("ScaleFadeOut",ScaleFadeOut)
