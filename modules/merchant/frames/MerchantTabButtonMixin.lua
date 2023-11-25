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

    self:InitEnableGamePadButton("BuyItem", "group", 1, function() end);
    self:RegisterBuyItem();
end

function MerchantTabButtonMixin:OnLeave()
    self:ShowShadowFadeOut();
end

function MerchantTabButtonMixin:OnEnter()
    self:ShowShadowFadeIn();
end

function MerchantTabButtonMixin:RegisterBuyItem(frame)
    local proccessor = self.gamePadButtonDownProcessor;
    proccessor:Register("PADRTRIGGER,PADLTRIGGER", function(currentItem, preItem)
        if (preItem and preItem.OnLeave) then
            preItem:OnLeave();
        end
        if (currentItem and currentItem.OnEnter) then
            currentItem:OnEnter();
        end
    end);
end
