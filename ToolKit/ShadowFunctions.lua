local _, AddonData = ...;
local Gpe = _G["Gpe"];

local ShadowFunctions = {};
AddonData.ShadowFunctions = ShadowFunctions;
local linear = AddonData.EasingFunctions.linear;
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
local AnimationFrame = {};

function AnimationFrame.New(duration, callback)
    local frame = CreateFrame("Frame");
    frame.total = 0;
    frame:Hide();
    frame:SetScript("OnUpdate", function(selfs, elapsed)
        selfs.total = selfs.total + elapsed;
        if (selfs.total >= duration) then
            selfs:Hide();
        end
        if (callback) then
            callback(selfs.total)
        end
        
    end);
    return frame;
end

function ShadowFunctions.Create(frame)
    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetFrameStrata(frame:GetFrameStrata())
    shadow:SetFrameLevel(1)
    SetOutside(shadow, frame, 2, 2);
    shadow:SetBackdrop({ edgeFile = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\GlowTex", edgeSize = 3 })
    shadow:SetBackdropColor(0, 0, 0, 0)
    shadow:SetBackdropBorderColor(0, 0, 0, 1);

    --动画效果
    local function callback(total)
        local alpha = linear(total, 3, 8, 0.5);
        print(alpha);
        shadow:ClearBackdrop();
        shadow:SetBackdrop({ edgeFile = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\GlowTex", edgeSize = alpha })
        SetOutside(shadow, frame, alpha - 1, alpha - 1);
        shadow:SetBackdropColor(0, 0, 0, 0)
        shadow:SetBackdropBorderColor(0, 0, 0, 1);
        if (total >= duration or endAlpha == 0) then
            frame:Hide();
        end
    end

    local function callback2(total)
        local alpha = linear(total, 8, 3, 0.5);
        print(alpha);
        shadow:ClearBackdrop();
        shadow:SetBackdrop({ edgeFile = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\GlowTex", edgeSize = alpha })
        SetOutside(shadow, frame, alpha - 1, alpha - 1);
        shadow:SetBackdropColor(0, 0, 0, 0)
        shadow:SetBackdropBorderColor(0, 0, 0, 1);
        if (total >= duration or endAlpha == 0) then
            frame:Hide();
        end
    end

    shadow.animation = AnimationFrame.New(0.4, callback);
    shadow.animation2 = AnimationFrame.New(0.2, callback2);
    return shadow;
end

--shadow专有动画
function ShadowFunctions.CreateAnimation1(frame)
    local function callback(total)
        local alpha = linear(total, 3, 8, 0.5);
        print(alpha);
        shadow:ClearBackdrop();
        shadow:SetBackdrop({ edgeFile = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\GlowTex", edgeSize = alpha })
        SetOutside(shadow, frame, alpha - 1, alpha - 1);
        shadow:SetBackdropColor(0, 0, 0, 0)
        shadow:SetBackdropBorderColor(0, 0, 0, 1);
        if (total >= duration or endAlpha == 0) then
            frame:Hide();
        end
    end
end