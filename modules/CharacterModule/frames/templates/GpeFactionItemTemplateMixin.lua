GpeFactionItemTemplateMixin = {};


function GpeFactionItemTemplateMixin:OnLoad()

end

function GpeFactionItemTemplateMixin:OnEnter()
    self.highlight:Show();
end

function GpeFactionItemTemplateMixin:OnLeave()
    self.highlight:Hide();
end
