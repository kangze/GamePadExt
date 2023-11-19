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

local function ShowShadow(frame)
    frame._shadow:Show();
end

Gpe:AddFrameApi("ShowShadow", ShowShadow)
Gpe:AddFrameApi("ShowShadow", ShowShadow)



