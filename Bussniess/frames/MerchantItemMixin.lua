local _, AddonData = ...;
MerchantItemMixin = {};

function MerchantItemMixin:OnLoad()
    local shadow = self:CreateShadow(2);
    local animationIn = shadow:CreateAnimation1(2, 8, 0.3);
    local animationOut = shadow:CreateAnimation1(8, 2, 0.3);
    shadow.animationInFrame = animationIn;
    shadow.animationOutFrame = animationOut;
    self.shadowFrame = shadow;

    local parent = self:GetParent();

    --自己保存一份集合
    if (not parent.items) then parent.items = {} end
    table.insert(parent.items, self);

    --开启手柄功能
    parent:EnableGamePadButton(true);

    --记录索引
    if (not parent.gamepadenable) then
        parent.gamepadenable = true;
        parent.currentIndex = 0;
        parent.currentGroupIndex = 1;
    end
end

function MerchantItemMixin:OnLeave()
    self.shadowFrame.animationOutFrame:Show();
end

function MerchantItemMixin:OnEnter()
    self.shadowFrame.animationInFrame:Show();
end

function MerchantItemMixin:OnGamePadButtonDown(...)
    --PADDDOWN PADDUP PADDLEFT PADDRIGHT
    local key = ...;
    local parent = self:GetParent();

    local groupCount = #parent._group;

    local currentGroupIndex = parent.currentGroupIndex;
    local preGroupIndex = currentGroupIndex;


    if (key == "PADDRIGHT") then
        currentGroupIndex = currentGroupIndex % (groupCount);
        currentGroupIndex = currentGroupIndex + 1;
    elseif (key == "PADDLEFT") then
        print(currentGroupIndex);
        currentGroupIndex = currentGroupIndex % (groupCount);
        currentGroupIndex = currentGroupIndex -1;
    end


    parent.currentGroupIndex = currentGroupIndex;

    print(currentGroupIndex);
    local count = #parent._group[currentGroupIndex];
    local currentIndex = parent.currentIndex;
    local preIndex = currentIndex;

    --换页
    -- if (parent.currentGroupIndex ~= preGroupIndex) then
    --     currentIndex = 1;
    --     preIndex = 0;
    -- end

    if (key == "PADDDOWN") then
        currentIndex = currentIndex % count;
        currentIndex = currentIndex + 1;
    elseif (key == "PADDUP") then
        currentIndex = currentIndex - 1;
        currentIndex = currentIndex % count;
    end

    parent.currentIndex = currentIndex;
    if (preIndex ~= 0 and preGroupIndex ~= 0) then
        parent._group[preGroupIndex][preIndex]:OnLeave();
    end
    parent._group[currentGroupIndex][currentIndex]:OnEnter();
end

--主要区分左右排列，二组永远在第一组右边
function MerchantItemMixin:Group(name)
    local parent = self:GetParent();
    local group = parent._group;
    local groupNames = parent._groupNames;
    if (not group) then
        group = {};
        groupNames = {};
        parent._group = group;
        parent._groupNames = groupNames;
    end
    if (not table.isInTable(groupNames, name)) then
        table.insert(group, {});
        table.insert(groupNames, name);
    end

    table.insert(group[#group], self);
end
