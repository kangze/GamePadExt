local _, AddonData = ...;
MerchantItemMixin = {};


function MerchantItemMixin:OnLoad()
    local shadow = self:CreateShadow();
    local animationIn = shadow:CreateAnimation1(0, 4, 0.1);
    local animationOut = shadow:CreateAnimation1(4, 0, 0.1);
    shadow.animationInFrame = animationIn;
    shadow.animationOutFrame = animationOut;
    self.shadowFrame = shadow;

    local parent = self:GetParent();
    if (not parent.items) then parent.items = {} end

    table.insert(parent.items, self);
end

function MerchantItemMixin:OnLeave()
    self.shadowFrame.animationOutFrame:Show();
    self.leave=1;
end

function MerchantItemMixin:OnEnter()
    self.shadowFrame.animationInFrame:Show();
    self.leave=0;
    local items = self:GetParent().items;
    for i = 1, #items do
        if (items[i] ~= self and items[i].leave ~= 1) then
            items[i].shadowFrame.animationOut:Show();
        end
    end
end
