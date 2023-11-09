local _, AddonData = ...;
local Gpe = _G["Gpe"];


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
