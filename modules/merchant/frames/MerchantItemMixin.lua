local _, AddonData = ...;
MerchantItemMixin = {};

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

function MerchantItemMixin:OnGamePadButtonDown(...)
    self.gamePadButtonDownProcessor:Handle(...);
end

function MerchantItemMixin:InitEabledGamePadButton(templateName, group)
    self:EnableGamePadButton(true);
    local processor = GamePadButtonDownProcesser:New(templateName);
    processor:Group(group, self);
    self.gamePadButtonDownProcessor = processor;
end
