local _, AddonData = ...;
local Gpe = _G["Gpe"];

local unpack = unpack;

local MaskFrameModule = Gpe:GetModule('MaskFrameModule');


function MaskFrameModule:OnInitialize()

end

function MaskFrameModule:OnEnable()
    local headFrame = CreateFrame("Frame", nil, nil, "HeaderFrameTemplate");
    headFrame:SetPoint("TOP", UIParent, 0, 0);

    headFrame:InitShowFadeInAndOut();
    headFrame:InitShadowAndAnimation();
    headFrame:ShowShadow();
    self.headFrame = headFrame;

    local bodyFrame = CreateFrame("Frame", nil, nil, "BodyFrameTemplate");
    bodyFrame:ClearAllPoints();
    bodyFrame:SetPoint("TOP", headFrame, "BOTTOM", 0, 0);
    self.bodyFrame = bodyFrame;
end

function MaskFrameModule:ShowAll()
    self.headFrame:Show();
    self.bodyFrame:Show();
end

function MaskFrameModule:HideBody()
    self.bodyFrame:Hide();
end

function MaskFrameModule:GetHeaderFrame()
    return self.headFrame
end

function MaskFrameModule:SetBackground()
    self.bodyFrame:SetFrameStrata("BACKGROUND");
end

function MaskFrameModule:SetFullScreen()
    self.bodyFrame:SetFrameStrata("FULLSCREEN");
end
