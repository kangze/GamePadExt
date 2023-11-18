local _, AddonData = ...;
local Gpe = _G["Gpe"];

local unpack = unpack;

local HeaderFrameModule = Gpe:GetModule('HeaderFrameModule');


function HeaderFrameModule:OnInitialize()

end

function HeaderFrameModule:OnEnable()
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

function HeaderFrameModule:ShowAll()
    self.headFrame:Show();
    self.bodyFrame:Show();
end

function HeaderFrameModule:HideBody()
    self.bodyFrame:Hide();
end

function HeaderFrameModule:GetHeaderFrame()
    return self.headFrame
end

function HeaderFrameModule:SetBackground()
    self.bodyFrame:SetFrameStrata("BACKGROUND");
end

function HeaderFrameModule:SetFullScreen()
    self.bodyFrame:SetFrameStrata("FULLSCREEN");
end
