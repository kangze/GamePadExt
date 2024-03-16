PropertyItemTemplateMixin = {};

function PropertyItemTemplateMixin:OnLoad()
    local parent = self:GetParent();
    self:SetSize(parent:GetWidth(), 50);
    self.propertyTooltip:SetWidth(parent:GetWidth() * 0.9);
end
