local _, AddonData = ...;
MerchantItemMixin = {};
MerchatItemGroups = {};

function MerchantItemMixin:OnLoad()
    local shadow = self:CreateShadow(2);
    local animationIn = shadow:CreateAnimation1(2, 8, 0.3);
    local animationOut = shadow:CreateAnimation1(8, 2, 0.3);
    shadow.animationInFrame = animationIn;
    shadow.animationOutFrame = animationOut;
    self.shadowFrame = shadow;

    --开启手柄功能
    self:EnableGamePadButton(true);

    --记录索引
    if (not MerchatItemGroups.gamepadenable) then
        MerchatItemGroups.gamepadenable = true;
        MerchatItemGroups.currentIndex = 0;
        MerchatItemGroups.currentGroupIndex = 0;
    end
end

function MerchantItemMixin:OnLeave()
    self.shadowFrame.animationOutFrame:Show();
end

function MerchantItemMixin:OnEnter()
    self.shadowFrame.animationInFrame:Show();
    -- GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    -- GameTooltip:SetHyperlink(self.productName:GetText());
    -- GameTooltip:Show()
end

function MerchantItemMixin:OnGamePadButtonDown(...)
    --PADDDOWN PADDUP PADDLEFT PADDRIGHT
    local key = ...;
    local parent = MerchatItemGroups;

    local groupCount = #parent._group;

    local currentGroupIndex = parent.currentGroupIndex;
    local preGroupIndex = currentGroupIndex;


    if (key == "PADDRIGHT") then
        currentGroupIndex = currentGroupIndex + 1;
        currentGroupIndex = currentGroupIndex % (groupCount);
    elseif (key == "PADDLEFT") then
        print(currentGroupIndex);
        currentGroupIndex = currentGroupIndex - 1;
        currentGroupIndex = currentGroupIndex % (groupCount);
    end




    local count = #parent._group[currentGroupIndex + 1];
    local currentIndex = parent.currentIndex;
    local preIndex = currentIndex;



    if (key == "PADDDOWN") then
        currentIndex = currentIndex + 1;
        currentIndex = currentIndex % count;
    elseif (key == "PADDUP") then
        currentIndex = currentIndex - 1;
        currentIndex = currentIndex % count;
    end




    MerchatItemGroups.currentIndex = currentIndex;
    MerchatItemGroups.currentGroupIndex = currentGroupIndex;

    MerchatItemGroups._group[preGroupIndex + 1][preIndex + 1]:OnLeave();
    MerchatItemGroups._group[currentGroupIndex + 1][currentIndex + 1]:OnEnter();

    --开始购买 X:PAD1 O:PAD2 []:PAD3
    print(key);
    if (key == "PAD1") then
        BuyMerchantItem(currentIndex + 1, 1);
    end

    --关闭所有的窗口
    if (key == "PAD2") then
        print("关闭关闭")
        self:EnableGamePadButton(false);
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
