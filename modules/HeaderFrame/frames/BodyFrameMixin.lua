BodyFrameMixin = {};


function BodyFrameMixin:OnLoad()
    --self:EnableGamePadButton(true);
    local width = UIParent:GetWidth();
    local height = UIParent:GetHeight();
    self:SetSize(width, height - 45);
end
