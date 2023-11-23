local _, AddonData = ...;


GpeButtonTemplateMixin = CreateFromMixins({}, GamePadFrameMixin);

function GpeButtonTemplateMixin:OnLoad()
    self.text:SetText(self.buttonText);
    self:InitShadowAndAnimation();
    self:InitShowFadeInAndOut();
end

function GpeButtonTemplateMixin:OnLeave()

end

function GpeButtonTemplateMixin:OnEnter()

end
