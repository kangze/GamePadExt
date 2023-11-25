local _, AddonData = ...;
local Gpe = _G["Gpe"];


local edgeFile = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\GlowTex";


local default_options = {
    start = 3,
    ends = 8,
    duration = 0.3,
    color = { r = 0.5, g = 0.5, b = 0.5, a = 1 }
};

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

--初始化阴影和阴影动画
local function InitShadowAndAnimation(frame, options)
    -- local start_val, end_val, duration = AddonData.db.profile.shadow.style.start_val,
    --     AddonData.db.profile.shadow.style.end_val, AddonData.db.profile.shadow.style.duration;

    local option = options or default_options;
    local color = AddonData.db.profile.shadow.style.color;
    local shadow = CreateShadow(frame, option.start, color);
    local fadeIn = CreateAnimation(shadow, option.start, option.ends, option.duration, option.color);
    local fadeOut = CreateAnimation(shadow, option.ends, option.start, option.duration, option.color);
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

local function ShowShadow(frame)
    frame._shadow:Show();
end

Gpe:AddFrameApi("ShowShadowFadeIn", ShowShadowFadeIn);
Gpe:AddFrameApi("ShowShadowFadeOut", ShowShadowFadeOut);
Gpe:AddFrameApi("InitShadowAndAnimation", InitShadowAndAnimation);
Gpe:AddFrameApi("ShowShadow", ShowShadow);
