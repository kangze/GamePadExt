local _, AddonData = ...;
MerchantItemMixin = {};


function MerchantItemMixin:OnLoad()
    AddonData.ShadowFunctions.Create(self);
    self.shadowFrame.animationInFrame=AddonData.ShadowFunctions.CreateAnimation(self,2,4,0.2);
    self.shadowFrame.animationOutFrame=AddonData.ShadowFunctions.CreateAnimation(self,4,2,0.2);
    _G.test = self;
end

function MerchantItemMixin:OnLeave()
    self.shadowFrame.animationOutFrame:Show();
end

function MerchantItemMixin:OnEnter()
    self.shadowFrame.animationInFrame:Show();
end
