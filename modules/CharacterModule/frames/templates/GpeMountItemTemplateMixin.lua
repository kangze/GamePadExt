GpeMountItemTemplateMixin = {};


function GpeMountItemTemplateMixin:OnLoad()
end

function GpeMountItemTemplateMixin:OnEnter()
    self.highlight:Show();
end

function GpeMountItemTemplateMixin:OnLeave()
    self.highlight:Hide();
end
