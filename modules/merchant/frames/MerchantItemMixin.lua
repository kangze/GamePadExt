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
end

function MerchantItemMixin:OnEnter()
    self:ShowShadowFadeIn();
end
