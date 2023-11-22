local _, AddonData = ...;
MerchantItemMixin = {};

function MerchantItemMixin:OnLoad()
    self:InitShadowAndAnimation();
    self.buyFrame:InitShowFadeInAndOut();
    self.detailFrame:InitShowFadeInAndOut();

    -- --记录索引
    -- if (not MerchatItemGroups.gamepadenable) then
    --     MerchatItemGroups.gamepadenable = true;
    --     MerchatItemGroups.currentIndex = 0;
    --     MerchatItemGroups.currentGroupIndex = 0;
    -- end
end

function MerchantItemMixin:OnLeave()
    self:ShowShadowFadeOut();
    self:ScaleFadeOut();
end

function MerchantItemMixin:OnEnter()
    self:ShowShadowFadeIn();
    self:ScaleFadeIn();
end

function MerchantItemMixin:OnGamePadButtonDown(...)
    --PADDDOWN PADDUP PADDLEFT PADDRIGHT
    -- PlaySoundFile("Interface\\AddOns\\GamePadExt\\media\\sound\\1.mp3", "Master");
    self.gamePadButtonDownProcessor:Handle(...);


    -- preItem:OnLeave();
    -- currentItem:OnEnter();

    -- --开始购买 X:PAD1 O:PAD2 []:PAD3
    

    -- if (MerchatGamePadButtonEventCallBacks[key]) then
    --     MerchatGamePadButtonEventCallBacks[key](currentItem, preItem);
    -- end
end

function MerchantItemMixin:InitEabledGamePadButton(templateName, group)
    self:EnableGamePadButton(true);
    local processor = GamePadButtonDownProcesser:New(templateName);
    processor:Group(group, self);
    self.gamePadButtonDownProcessor = processor;
end
