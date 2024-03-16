GpeEquipmentTemplateMixin = {};

function GpeEquipmentTemplateMixin:OnLoad()

end

function GpeEquipmentTemplateMixin:OnEnter()
    self.button.PushedTexture:Show();
end

function GpeEquipmentTemplateMixin:OnLeave()
    self.button.PushedTexture:Hide();
end
