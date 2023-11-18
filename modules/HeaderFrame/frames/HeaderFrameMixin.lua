local _, AddonData = ...;

HeaderFrameMixin = {};

function HeaderFrameMixin:OnLoad()
    --self:EnableGamePadButton(true);
    local width = UIParent:GetWidth();
    self:SetSize(width, 45);
    
end

function HeaderFrameMixin:OnEnter()
    
end
