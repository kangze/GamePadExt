local _, AddonData = ...;
local Gpe = _G["Gpe"];


local edgeFile = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\GlowTex";
local color = {
    r = 0.1, g = 0.2, b = 0.3, a = 1
};
--创建一个阴影frame,然后返回
local function AppendShadow(frame, edgeSize, color)
    local edgeSize = edgeSize or 0;
    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetFrameStrata(frame:GetFrameStrata())
    shadow:SetFrameLevel(2)
    shadow:SetOutside(frame, edgeSize, edgeSize);
    shadow:SetBackdrop({ edgeFile = edgeFile, edgeSize = edgeSize })
    local color = {
        r = 0.1, g = 0.2, b = 0.3, a = 1
    };
    shadow:SetBackdropColor(color.r, color.g, color.b, color.a);
    shadow:SetBackdropBorderColor(color.r, color.g, color.b, color.a);
    frame._shadow = shadow;
    return shadow;
end

local function SetShadowSize(frame, edgeSize)
    frame._shadow:ClearBackdrop();
    frame._shadow:SetOutside(frame, edgeSize, edgeSize);
    local color = {
        r = 0.1, g = 0.2, b = 0.3, a = 1
    };
    frame._shadow:SetBackdrop({ edgeFile = edgeFile, edgeSize = edgeSize })
    frame._shadow:SetBackdropColor(color.r, color.g, color.b, color.a)
    frame._shadow:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
end



Gpe:AddFrameApi("AppendShadow", AppendShadow)
Gpe:AddFrameApi("SetShadowSize", SetShadowSize)
