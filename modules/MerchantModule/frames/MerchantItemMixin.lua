local _, AddonData = ...;

MerchantItemFrames = {};
MerchantItemMixin = CreateFromMixins({}, GamePadFrameMixin);

local enter_shadow_animation = function(frame)
    return function(current)
        frame:SetShadowSize(current);
    end
end

function MerchantItemMixin:OnLoad()
    self:AppendShadow(2, nil);
    self.enter_shadowAinimation = Animation:new(0.3, 2, 10, enter_shadow_animation(self), nil, EasingFunctions.OutSine);
    self.buyFrame.enter_animation = Animation:new(0.3, 0, 1, function(current) self.buyFrame:SetAlpha(current) end, nil,
        EasingFunctions.OutSine);
    self.detailFrame.enter_animation = Animation:new(0.3, 0, 1, function(current) self.detailFrame:SetAlpha(current) end,
        nil, EasingFunctions.OutSine);
end

function MerchantItemMixin:OnLeave()
    self.enter_shadowAinimation:PlayReverse();
    self.buyFrame.enter_animation:PlayReverse();
    self.detailFrame.enter_animation:PlayReverse();
end

function MerchantItemMixin:OnEnter()
    self.enter_shadowAinimation:Play();
    self.buyFrame.enter_animation:Play();
    self.detailFrame.enter_animation:Play();
end
