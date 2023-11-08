local _, AddonData = ...;
MerchantItemMixin = {};


function MerchantItemMixin:OnLoad()
    AddonData.ShadowFunctions.Create(self);
end
