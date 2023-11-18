BodyFrameMixin = {};


function BodyFrameMixin:OnLoad()
    --self:EnableGamePadButton(true);
    local scale = UIParent:GetEffectiveScale();
    local width = GetScreenWidth() * scale
    local height= GetScreenHeight() * scale - 30;
    self:SetSize(width, height);
end
