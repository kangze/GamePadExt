local function decorator(func)
    return function(...)
        local result = func(...)
        return result
    end
end

GamePadButtonDownProcesser = {};
GamePadButtonDownProcesser.__index = GamePadButtonDownProcesser
GamePadButtonDownProcesser.instances = {}

function GamePadButtonDownProcesser:New(name)
    if self.instances[name] then
        return self.instances[name]
    end
    local newObj = {
        groups = {},
        groupNames = {},
        currentGroupIndex = 0,
        currentIndex = 0,
        handlers = {}
    }
    setmetatable(newObj, GamePadButtonDownProcesser)
    self.instances[name] = newObj
    return newObj
end

function GamePadButtonDownProcesser:Register(key, callback)
    if not self.handlers[key] then
        self.handlers[key] = callback;
        return;
    end
    self.handlers[key] = decorator(self[key])
    return self;
end

--只处理方向键的定位处理
function GamePadButtonDownProcesser:Handle(key)
    local currentIndex = self.currentIndex;
    local currentGroupIndex = self.currentGroupIndex;
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

    self.currentIndex = currentIndex;
    self.currentGroupIndex = currentGroupIndex;

    local preItem = self.groups[preGroupIndex + 1][preIndex + 1];
    local currentItem = self.groups[currentGroupIndex + 1][currentIndex + 1];

    if (self.handlers[key]) then
        self.handlers[key](currentItem, preItem);
    end
    -- preItem:OnLeave();
    -- currentItem:OnEnter();
end

function GamePadButtonDownProcesser:Group(name, frame)
    local groups = self.groups;
    local groupNames = self.groupNames;
    if (not table.isInTable(groupNames, name)) then
        table.insert(groups, {});
        table.insert(groupNames, name);
    end
    frame.index = #groups[#groups] + 1; --count it
    table.insert(groups[#group], frame);
end
