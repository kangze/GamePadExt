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
end

MerchantTabsFrameMixin = CreateFromMixins({}, GamePadFrameMixin);

function MerchantTabsFrameMixin:GetGamePadFrames()
    local frames = {};
    table.insert(frames, self.buy);
    table.insert(frames, self.rebuy);
    table.insert(frames, self.rebuy2);
    return frames;
end
