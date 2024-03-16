PropertyItemTemplateMixin = {};

function PropertyItemTemplateMixin:OnLoad()
    local parent = self:GetParent();
    self:SetSize(parent:GetWidth(), 30);
end
