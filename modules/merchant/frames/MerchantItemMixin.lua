local _, AddonData = ...;

MerchantItemFrames = {};
MerchantItemMixin = CreateFromMixins({}, GamePadFrameMixin);

local enter_shadow_animation = function(frame)
    return function(current)
        frame:SetShadowSize(current);
    end
end

function MerchantItemMixin:OnLoad()
    self:AppendShadow(2,nil);
    self.enter_shadowAinimation = Animation:new(0.3, 2, 10, enter_shadow_animation(self), nil, EasingFunctions.OutSine);
    self.leave_shadowAinimation = Animation:new(0.3, 10, 2, enter_shadow_animation(self), nil, EasingFunctions.OutSine);
end

function MerchantItemMixin:OnLeave()
    self.leave_shadowAinimation:Play();
end

function MerchantItemMixin:OnEnter()
    self.enter_shadowAinimation:Play();
end
