local _, AddonData = ...;


GpeButtonTemplateMixin = CreateFromMixins({}, GamePadFrameMixin);

function GpeButtonTemplateMixin:OnLoad()
    self.text:SetText(self.buttonText);
    if (self.shadow) then
        self:InitShadowAndAnimation();
    end
end

function GpeButtonTemplateMixin:OnLeave()
    if (self.shadow) then
        self:ShowShadowFadeOut();
    end
end

function GpeButtonTemplateMixin:OnEnter()
    if (self.shadow) then
        self:ShowShadowFadeIn();
    end
end
