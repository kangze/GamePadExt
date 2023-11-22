local _, AddonData = ...;
MerchantItemMixin = {};
MerchatItemGroups = {};
MerchatGamePadButtonEventCallBacks = {};

function MerchantItemMixin:OnLoad()
    self:InitShadowAndAnimation();
    self.buyFrame:InitShowFadeInAndOut();
    self.detailFrame:InitShowFadeInAndOut();
    self:EnableGamePadButton(true);

    --记录索引
    if (not MerchatItemGroups.gamepadenable) then
        MerchatItemGroups.gamepadenable = true;
        MerchatItemGroups.currentIndex = 0;
        MerchatItemGroups.currentGroupIndex = 0;
    end
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
    PlaySoundFile("Interface\\AddOns\\GamePadExt\\media\\sound\\1.mp3", "Master");
    local key = ...;
    print(key);
    local parent = MerchatItemGroups;

    local groupCount = #parent._group;
    local currentGroupIndex = parent.currentGroupIndex;
    local preGroupIndex = currentGroupIndex;

    local count = #parent._group[currentGroupIndex + 1];
    local currentIndex = parent.currentIndex;
    local preIndex = currentIndex;


    if (key == "PADDRIGHT") then
        currentGroupIndex = currentGroupIndex + 1;
        currentGroupIndex = currentGroupIndex % (groupCount);
    elseif (key == "PADDLEFT") then
        currentGroupIndex = currentGroupIndex - 1;
        currentGroupIndex = currentGroupIndex % (groupCount);
    end

    currentIndex = math.min(currentIndex, #parent._group[currentGroupIndex + 1] - 1);

    if (key == "PADDDOWN") then
        currentIndex = currentIndex + 1;
        currentIndex = currentIndex % count;
    elseif (key == "PADDUP") then
        currentIndex = currentIndex - 1;
        currentIndex = currentIndex % count;
    end

    MerchatItemGroups.currentIndex = currentIndex;
    MerchatItemGroups.currentGroupIndex = currentGroupIndex;

    local preItem = MerchatItemGroups._group[preGroupIndex + 1][preIndex + 1];
    local currentItem = MerchatItemGroups._group[currentGroupIndex + 1][currentIndex + 1];

    preItem:OnLeave();
    currentItem:OnEnter();

    --开始购买 X:PAD1 O:PAD2 []:PAD3
    if (key == "PAD1") then
        --BUG:有一个分组的情况要进行一个考虑
        BuyMerchantItem(currentIndex + 1, 1);
    end

    if (MerchatGamePadButtonEventCallBacks[key]) then
        MerchatGamePadButtonEventCallBacks[key](currentItem, preItem);
    end
end

--主要区分左右排列，二组永远在第一组右边
function MerchantItemMixin:Group(name)
    local group = MerchatItemGroups._group;
    local groupNames = MerchatItemGroups._groupNames;
    if (not group) then
        group = {};
        groupNames = {};
        MerchatItemGroups._group = group;
        MerchatItemGroups._groupNames = groupNames;
    end
    if (not table.isInTable(groupNames, name)) then
        table.insert(group, {});
        table.insert(groupNames, name);
    end

    table.insert(group[#group], self);
end

function MerchantItemMixin:RegisterGamePadButtonDown(key, callback)
    MerchatGamePadButtonEventCallBacks[key] = callback;
end

function MerchantItemMixin:InitEabledGamePadButton(templateName, group)
    self:EnableGamePadButton(true);
    local processor = GamePadButtonDownProcesser:New(templateName);
    processor:Group(group, self);
    self.gamePadButtonDownProcessor = processor;
end
