local _, AddonData = ...;
local Gpe = _G["Gpe"];

local ShadowFunctions = {};
AddonData.ShadowFunctions = ShadowFunctions;

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

function ShadowFunctions.Create(frame)
    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetFrameStrata(frame:GetFrameStrata())
    shadow:SetFrameLevel(1)
    SetOutside(shadow, frame, 2, 2);
    shadow:SetBackdrop({ edgeFile = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\GlowTex", edgeSize = 3 })
    shadow:SetBackdropColor(0, 0, 0, 0)
    shadow:SetBackdropBorderColor(0, 0, 0, 1);
end
