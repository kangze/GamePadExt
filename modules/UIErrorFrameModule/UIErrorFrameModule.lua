local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local UIErrorFrameModule = Gpe:GetModule('UIErrorFrameModule');

local MaskFrameModule = Gpe:GetModule('MaskFrameModule');

function UIErrorFrameModule:OnInitialize()

end

function UIErrorFrameModule:OnEnable()

end

function UIErrorFrameModule:AddMessage(message)
    local frame = CreateFrame("Frame", nil, UIParent, "ErrorFrameTemplate");
    frame:SetPoint("TOP", 0, 0);
    frame.message:SetText(message);
    frame:Show();
    frame.show_animation:Play();
end
