local _, AddonData = ...;

HeaderFrameMixin = {};

function HeaderFrameMixin:OnLoad()
    --self:EnableGamePadButton(true);
    local scale = UIParent:GetEffectiveScale();
    local width = GetScreenWidth() * scale
    local height = 30;
    self:SetSize(width, height);
end

function HeaderFrameMixin:OnEnter()

end
