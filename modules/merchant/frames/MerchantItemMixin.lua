local _, AddonData = ...;

MerchantItemFrames = {};
MerchantItemMixin = CreateFromMixins({}, GamePadFrameMixin);

function MerchantItemMixin:OnLoad()
    self:InitShadowAndAnimation();
    self.buyFrame:InitShowFadeInAndOut();
    self.detailFrame:InitShowFadeInAndOut();
end

function MerchantItemMixin:OnLeave()
    self:ShowShadowFadeOut();
    self:ScaleFadeOut();
end

function MerchantItemMixin:OnEnter()
    self:ShowShadowFadeIn();
    self:ScaleFadeIn();
end
