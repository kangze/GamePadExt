local _, AddonData = ...;


GpeButtonTemplateMixin = CreateFromMixins({}, GamePadFrameMixin);

function GpeButtonTemplateMixin:OnLoad()
    self.text:SetText(self.buttonText);
    self:InitShadowAndAnimation();
    self:InitShowFadeInAndOut();
end

function GpeButtonTemplateMixin:OnLeave()
    self:ShowShadowFadeOut();
    self:ScaleFadeOut();
end

function GpeButtonTemplateMixin:OnEnter()
    self:ShowShadowFadeIn();
    self:ScaleFadeIn();
end
