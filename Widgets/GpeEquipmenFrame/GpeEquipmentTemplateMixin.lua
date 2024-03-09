GpeEquipmentTemplateMixin = {};

function GpeEquipmentTemplateMixin:OnLoad()

end

function GpeEquipmentTemplateMixin:OnEnter()
    self.PushedTexture:Show();
end

function GpeEquipmentTemplateMixin:OnLeave()
    self.PushedTexture:Hide();
end
