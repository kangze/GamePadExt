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
    tabName = nil,
    tabContents = {}
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

function GamePadInitor:Add(element, groupName, tabName)
    if (tabName) then
        element.tabName = tabName;
    end
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
    if (element.index == 1 and element.OnEnter) then
        element:OnEnter();
        self.currentItem = element;
        self.preItem = element;
    end
end

--tagContent主要是为了和tab进行联动
function GamePadInitor:SetRegion(frame, tabName)
    self.region = frame;
    frame.gamePadInitor = self;
    if (tabName) then
        self.tabContents[tabName] = self;
    end
end

function GamePadInitor:Register(keys, callback)
    local keys_arr = string.split(keys, ",");
    for _, key in ipairs(keys_arr) do
        if not self.handlers[key] then
            self.handlers[key] = {};
        end
        table.insert(self.handlers[key], callback);
    end
    return self;
end

function GamePadInitor:ComputeIndex(...)
    local key = ...;
    print(key);
    local currentIndex = self.currentIndex;
    local currentGroupIndex = self.currentGroupIndex;

    local preIndex = currentIndex;
    local preGroupIndex = currentGroupIndex;

    print(self.classname);
    print(self.groups);
    print(currentGroupIndex);
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
            self.handlers[key][i](currentItem, preItem);
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
end

--框架规定,必定可以选择到
function GamePadInitor:SelectTab(tabName, callback)
    local initor = self.tabContents[tabName];
    
    self:Switch(initor.classname);
    if (callback) then
        callback();
    end
end

function GamePadInitor:Destroy()
    self.core:EnableGamePadButton(false);
    self.core:UnregisterAllEvents();
    self.groupNames = {};
    self.currentGroupIndex = 0;
    self.currentIndex = 0;
    self.handlers = {};

    for i = 1, #self.groups do
        for j = 1, #self.groups[i] do
            self.groups[i][j]:Hide();
            self.groups[i][j]:SetParent(nil);
            self.groups[i][j]:ClearAllPoints();
            self.groups[i][j]:UnregisterAllEvents();
            self.groups[i][j] = nil;
        end
    end
    self.groups = {};
    if (self.region) then
        self.region:ClearAllPoints();
        self.region:Hide();
        self.region:UnregisterAllEvents();
        self.region = nil;
    end
    GamePadInitor.instances[self.classname] = nil;
end
