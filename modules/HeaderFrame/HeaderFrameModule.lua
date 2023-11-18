local _, AddonData = ...;
local Gpe = _G["Gpe"];

local unpack = unpack;

local HeaderFrameModule = Gpe:GetModule('HeaderFrameModule');


function HeaderFrameModule:OnInitialize()

end

function HeaderFrameModule:OnEnable()
    local headFrame = CreateFrame("Frame", nil, UIParent, "HeaderFrameTemplate");
    headFrame:SetPoint("TOP", UIParent);
    headFrame:InitShowFadeInAndOut();
    headFrame:InitShadowAndAnimation();
    headFrame:ShowShadow();
    self.headFrame = headFrame;

    local bodyFrame = CreateFrame("Frame", nil, UIParent, "BodyFrameTemplate");
    bodyFrame:SetPoint("BOTTOM", UIParent);
    self.bodyFrame = bodyFrame;
end

function HeaderFrameModule:ShowAll()
    self.headFrame:Show();
    self.bodyFrame:Show();
end

function HeaderFrameModule:HideBody()
    self.bodyFrame:Hide();
end 
