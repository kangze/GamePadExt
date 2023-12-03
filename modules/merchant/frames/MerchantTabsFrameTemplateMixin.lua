MerchantTabButtonMixin = CreateFromMixins({}, GpeButtonTemplateMixin);

local default_options = {
    start = 1,
    ends = 8,
    duration = 0.2,
    color = { r = 1, g = 0.5, b = 0.5, a = 1 }
};

function MerchantTabButtonMixin:OnLoad()
    GpeButtonTemplateMixin.OnLoad_Intrinsic(self);
    self:InitShadowAndAnimation(default_options);
    --self:InitShowFadeInAndOut();
end

function MerchantTabButtonMixin:OnEnter()
    GpeButtonTemplateMixin.OnEnter_Intrinsic(self);
end

function MerchantTabButtonMixin:OnLeave()
    GpeButtonTemplateMixin.OnLeave_Intrinsic(self);
end

MerchantTabsFrameMixin = {};

function MerchantTabsFrameMixin:Destroy()
    self.buy:ShowFadeOut();
    self.rebuy:ShowFadeOut();

    self.buy:Hide();
    self.rebuy:Hide();
    self:Hide();
    self.buy=nil;
    self.rebuy=nil;
    self=nil;
end
