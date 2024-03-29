GamePadInitorNames = {
    MerchantTabFrame = {
        Name = "MerchantTabFrame",
        Level = 100,
    },
    MerchantBuyFrame = {
        Name = "MerchantBuyFrame",
        Level = 1,
    },
    MerchantBuyBackFrame = {
        Name = "MerchantBuyBackFrame",
        Level = 2,
    },

    CharacterTabFrame = {
        Name = "CharacterTabFrame",
        Level = 99,
    },

    CharacterEquipmentFrame = {
        Name = "CharacterEquipmentFrame",
        Level = 5,
    },
    CharacterFactionFrame = {
        Name = "CharacterFactionFrame",
        Level = 4,
    },
    CharacterCurrencyFrame = {
        Name = "CharacterCurrencyFrame",
        Level = 3,
    },

}

GamePadInitor = {
    classname = nil,
    groups = {},
    groupNames = {},
    currentGroupIndex = 0,
    currentIndex = 0,
    handlers = {},
    core = nil,
    region = nil,
    currentItem = nil,
    preItem = nil,
    instances = {},
};
GamePadInitor.__index = GamePadInitor;

function GamePadInitor:Init(classname, level)
    local self = setmetatable({}, GamePadInitor);
    self.classname = classname;
    self.groups = {};
    self.groupNames = {};
    self.handlers = {};

    local frame = CreateFrame("Frame", nil, nil);
    frame:SetPoint("CENTER", UIParent, "CENTER");
    frame:SetSize(1, 1);
    frame:SetFrameLevel(level);
    frame:EnableGamePadButton(true);
    frame:SetScript("OnGamePadButtonDown", function(...) return self:Handle(...) end);
    self.core = frame;
    if (not GamePadInitor.instances[classname]) then
        GamePadInitor.instances[classname] = self;
    end
    return self;
end

function GamePadInitor:Add(element, groupName, associateName)
    if (not table.isInTable(self.groupNames, groupName)) then
        table.insert(self.groups, {});
        table.insert(self.groupNames, groupName);
    end

    table.insert(self.groups[#self.groups], element);

    local index = 0;
    for i = 1, #self.groups do
        for j = 1, #self.groups[i] do
            index = index + 1;
        end
    end
    element.index = index;
    element.associateName = associateName;
    if (element.index == 1) then
        if (element.OnEnter) then
            element:OnEnter();
        end
        self.currentItem = element;
        self.preItem = element;
    end
end

-- function GamePadInitor:Add(element, groupName, associateName)
--     if (not table.isInTable(self.groupNames, groupName)) then
--         self.groups[#self.groups + 1] = {element}
--         table.insert(self.groupNames, groupName);
--     else
--         table.insert(self.groups[#self.groups], element);
--     end

--     element.index = #self.groups * #self.groups[#self.groups]
--     element.associateName = associateName;
--     if (element.index == 1) then
--         if (element.OnEnter) then
--             -- 这里似乎缺少了一些代码
--         end
--     end
-- end

function GamePadInitor:SetRegion(frame)
    self.region = frame;
    frame.gamePadInitor = self;
end

function GamePadInitor:Register(keys, callback)
    local keys_arr = string.split(keys, ",");
    for _, key in ipairs(keys_arr) do
        if not self.handlers[key] then
            self.handlers[key] = {};
        end
        table.insert(self.handlers[key], { callback = callback, needNotNil = false });
    end
    return self;
end

function GamePadInitor:RegisterItem(keys, callback)
    local keys_arr = string.split(keys, ",");
    for _, key in ipairs(keys_arr) do
        if not self.handlers[key] then
            self.handlers[key] = {};
        end
        table.insert(self.handlers[key], { callback = callback, needNotNil = true });
    end
    return self;
end

function GamePadInitor:ComputeIndex(...)
    local key = ...;
    local currentIndex = self.currentIndex;
    local currentGroupIndex = self.currentGroupIndex;

    local preIndex = currentIndex;
    local preGroupIndex = currentGroupIndex;

    local count = #self.groups[currentGroupIndex + 1];
    local groupCount = #self.groups;

    if (key == "PADDRIGHT") then
        currentGroupIndex = currentGroupIndex + 1;
        currentGroupIndex = currentGroupIndex % (groupCount);
    elseif (key == "PADDLEFT") then
        currentGroupIndex = currentGroupIndex - 1;
        currentGroupIndex = currentGroupIndex % (groupCount);
    end

    currentIndex = math.min(currentIndex, #self.groups[currentGroupIndex + 1] - 1);

    if (key == "PADDDOWN") then
        currentIndex = currentIndex + 1;
        currentIndex = currentIndex % count;
    elseif (key == "PADDUP") then
        currentIndex = currentIndex - 1;
        currentIndex = currentIndex % count;
    end

    self.currentIndex = currentIndex;
    self.currentGroupIndex = currentGroupIndex;


    local preItem = self.groups[preGroupIndex + 1][preIndex + 1];
    local currentItem = self.groups[currentGroupIndex + 1][currentIndex + 1];

    self.currentItem = currentItem;
    self.preItem = preItem;

    currentItem.currentIndex = currentIndex;

    return currentItem, preItem;
end

--只处理方向键的定位处理
function GamePadInitor:Handle(...)
    local _, key = ...;
    local preItem = self.preItem;
    local currentItem = self.currentItem;

    if (key == "PADDLEFT" or key == "PADDRIGHT" or key == "PADDUP" or key == "PADDDOWN") then
        currentItem, preItem = self:ComputeIndex(key);
    end

    if (key == "PADLTRIGGER" or key == "PADRTRIGGER") then
        --如果是trigger按键,那么进行伪装
        local mock_key = key == "PADLTRIGGER" and "PADDDOWN" or "PADDUP";
        currentItem, preItem = self:ComputeIndex(mock_key);
    end
    if (self.handlers[key]) then
        for i = 1, #self.handlers[key] do
            if (currentItem ~= nil and self.handlers[key][i].needNotNil) then
                self.handlers[key][i].callback(currentItem, preItem);
            end
            if (not self.handlers[key][i].needNotNil) then
                self.handlers[key][i].callback(currentItem, preItem);
            end
        end
    end
end

function GamePadInitor:Switch(classname)
    --交换2个框架的层级，切换手柄按键的接收
    local nextInitor    = GamePadInitor.instances[classname];
    local next_level    = nextInitor.core:GetFrameLevel();
    local current_level = self.core:GetFrameLevel();
    self.core:SetFrameLevel(next_level);
    nextInitor.core:SetFrameLevel(current_level);
    if (self.region.OnLeave) then
        self.region:OnLeave();
    end
    if (nextInitor.region.OnEnter) then
        nextInitor.region:OnEnter();
    end
end

function GamePadInitor:Destroy()
    self.core:EnableGamePadButton(false);
    self.core:UnregisterAllEvents();
    -- self.groupNames = {};
    -- self.currentGroupIndex = 0;
    -- self.currentIndex = 0;
    -- self.handlers = {};
    GamePadInitor.instances[self.classname] = nil;
end
