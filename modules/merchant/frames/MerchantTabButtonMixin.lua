MerchantTabButtonMixin = {};
local default_options = {
    start = 1,
    ends = 4,
    duration = 0.2,
    color = { r = 0.5, g = 0.5, b = 0.5, a = 1 }
};

function MerchantTabButtonMixin:OnLoad()
    self.text:SetText(self.buttonText);
    self:InitShadowAndAnimation(default_options);
end

function MerchantTabButtonMixin:OnLeave()
    self:ShowShadowFadeOut();
end

function MerchantTabButtonMixin:OnEnter()
    self:ShowShadowFadeIn();
end

MerchantTabsFrameMixin = CreateFromMixins({}, GamePadFrameMixin);

function MerchantTabsFrameMixin:GetGamePadFrames()
    local frames = {};
    table.insert(frames, self.buy);
    table.insert(frames, self.rebuy);
    return frames;
end
