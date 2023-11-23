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

--name: processer namep
--buttonGroup: 目前只有2个值，一个是 direct,一个是 trigger
function GamePadButtonDownProcesser:New(classname, buttonGroup)
    if self.instances[classname] then
        return self.instances[classname]
    end
    local newObj = {
        classname = classname,
        groups = {},
        groupNames = {},
        currentGroupIndex = 0,
        currentIndex = 0,
        handlers = {},
        buttonGroup = buttonGroup
    }
    setmetatable(newObj, GamePadButtonDownProcesser)
    self.instances[classname] = newObj
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

function GamePadButtonDownProcesser:ComputeIndex(...)
    local key = ...;
    local currentIndex = self.currentIndex;
    local currentGroupIndex = self.currentGroupIndex;

    local preIndex = currentIndex;
    local preGroupIndex = currentGroupIndex;

    local count = #self.groups[currentGroupIndex + 1];
    local groupCount = #self.groups;
    if (key == "PADDRIGHT" or key == "PADRTRIGGER") then
        currentGroupIndex = currentGroupIndex + 1;
        currentGroupIndex = currentGroupIndex % (groupCount);
    elseif (key == "PADDLEFT" or key == "PADLTRIGGER") then
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
    return currentItem, preItem;
end

--只处理方向键的定位处理
function GamePadButtonDownProcesser:Handle(...)
    local key = ...;
    local currentItem, preItem;

    if (self.buttonGroup == "direct") then
        currentItem, preItem = self:ComputeIndex(key);
    end

    if (self.buttonGroup == "trigger") then
        --如果是trigger按键,那么进行伪装
        local mock_key = key == "PADLTRIGGER" and "PADDLEFT" or "PADDRIGHT";
        currentItem, preItem = self:ComputeIndex(mock_key);
    end

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
    self.instances[self.classname] = nil;
end
