local _, AddonData = ...;
MerchantItemMixin = {};


function MerchantItemMixin:OnLoad()
    local shadow = self:CreateShadow();
    local animationIn = shadow:CreateAnimation1(2, 4, 0.2);
    local animationOut = shadow:CreateAnimation1(4, 2, 0.2);
    shadow.animationInFrame = animationIn;
    shadow.animationOutFrame = animationOut;
    self.shadowFrame = shadow;
    print(1);
end

function MerchantItemMixin:OnLeave()
    self.shadowFrame.animationOutFrame:Show();
end

function MerchantItemMixin:OnEnter()
    self.shadowFrame.animationInFrame:Show();
end
