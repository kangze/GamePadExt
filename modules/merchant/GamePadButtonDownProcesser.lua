local function decorator(oldFunc)
    return function(newFunc)
        return function(...)
            oldFunc(...)
            newFunc(...)
        end
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
        name = name,
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

function GamePadButtonDownProcesser:Register(keys, callback)
    local keys_arr = string.split(keys, ",");
    for _, key in ipairs(keys_arr) do
        if not self.handlers[key] then
            self.handlers[key] = callback;
        end
        self.handlers[key] = decorator(self.handlers[key])(callback);
    end
    return self;
end

--只处理方向键的定位处理
function GamePadButtonDownProcesser:Handle(...)
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

    if (self.handlers[key]) then
        self.handlers[key](currentItem, preItem, self);
    end

    if (preItem and preItem.OnLeave) then
        preItem:OnLeave();
    end
    if (currentItem and currentItem.OnEnter) then
        currentItem:OnEnter();
    end
end

function GamePadButtonDownProcesser:Group(name, frame)
    local groups = self.groups;
    local groupNames = self.groupNames;
    if (not table.isInTable(groupNames, name)) then
        table.insert(groups, {});
        table.insert(groupNames, name);
    end
    frame.index = #groups[#groups] + 1; --count it
    table.insert(groups[#groups], frame);
end

function GamePadButtonDownProcesser:Destory()
    self.groups = {};
    self.groupNames = {};
    self.currentGroupIndex = 0;
    self.currentIndex = 0;
    self.handlers = {};
    self.instances[self.name] = nil;
end
