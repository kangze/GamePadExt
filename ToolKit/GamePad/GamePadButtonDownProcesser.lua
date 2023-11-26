local function Register(frame, keys, callback)
    local keys_arr = string.split(keys, ",");
    for _, key in ipairs(keys_arr) do
        if not frame.handlers[key] then
            frame.handlers[key] = {};
        end
        table.insert(frame.handlers[key], callback);
    end
    return frame;
end

local function ComputeIndex(frame, ...)
    local key = ...;
    local currentIndex = frame.currentIndex;
    local currentGroupIndex = frame.currentGroupIndex;

    local preIndex = currentIndex;
    local preGroupIndex = currentGroupIndex;

    local count = #frame.groups[currentGroupIndex + 1];
    local groupCount = #frame.groups;

    if (key == "PADDRIGHT") then
        currentGroupIndex = currentGroupIndex + 1;
        currentGroupIndex = currentGroupIndex % (groupCount);
    elseif (key == "PADDLEFT") then
        currentGroupIndex = currentGroupIndex - 1;
        currentGroupIndex = currentGroupIndex % (groupCount);
    end

    currentIndex = math.min(currentIndex, #frame.groups[currentGroupIndex + 1] - 1);

    if (key == "PADDDOWN") then
        currentIndex = currentIndex + 1;
        currentIndex = currentIndex % count;
    elseif (key == "PADDUP") then
        currentIndex = currentIndex - 1;
        currentIndex = currentIndex % count;
    end

    frame.currentIndex = currentIndex;
    frame.currentGroupIndex = currentGroupIndex;


    local preItem = frame.groups[preGroupIndex + 1][preIndex + 1];
    local currentItem = frame.groups[currentGroupIndex + 1][currentIndex + 1];

    frame.currentItem = currentItem;
    frame.preItem = preItem;

    currentItem.currentIndex = currentIndex;

    return currentItem, preItem;
end

--只处理方向键的定位处理
local function Handle(frame, ...)
    local key = ...;
    local preItem = frame.preItem;
    local currentItem = frame.currentItem;

    if (key == "PADDLEFT" or key == "PADDRIGHT" or key == "PADDUP" or key == "PADDDOWN") then
        currentItem, preItem = frame:ComputeIndex(key);
    end

    if (key == "PADLTRIGGER" or key == "PADRTRIGGER") then
        --如果是trigger按键,那么进行伪装
        local mock_key = key == "PADLTRIGGER" and "PADDDOWN" or "PADDUP";
        currentItem, preItem = frame:ComputeIndex(mock_key);
    end

    if (frame.handlers[key]) then
        for i = 1, #frame.handlers[key] do
            frame.handlers[key][i](currentItem, preItem);
        end
    end
end

local function Switch(frame, classname)
    --交换2个框架的层级，切换手柄按键的接收
    local nextFrame     = GamePadButtonDownProcesserBuilder.instances[classname]
    local next_level    = nextFrame:GetFrameLevel();
    local current_level = frame:GetFrameLevel();
    frame:SetFrameLevel(next_level);
    nextFrame:SetFrameLevel(current_level);
    frame:LostFocus();
end

local function LostFocus(frame)
    frame:LoseFocus();
end

local function Group(frame, name, element)
    local groups = frame.groups;
    local groupNames = frame.groupNames;
    if (not table.isInTable(groupNames, name)) then
        table.insert(groups, {});
        table.insert(groupNames, name);
    end

    --计算index
    local index = 0;
    for i = 1, #groups do
        for j = 1, #groups[i] do
            index = index + 1;
        end
    end
    element.index = index + 1; --count it
    if (element.index == 1 and element.OnEnter) then
        element:OnEnter();
        frame.currentItem = element;
        frame.preItem = element;
    end

    table.insert(groups[#groups], element);
end

local function Destroy(frame)
    frame:EnableGamePadButton(false);
    frame:UnregisterAllEvents();
    frame.groups = {};
    frame.groupNames = {};
    frame.currentGroupIndex = 0;
    frame.currentIndex = 0;
    frame.handlers = {};
    GamePadButtonDownProcesserBuilder.instances[frame.classname] = nil;
end


GamePadButtonDownProcesserBuilder = {
    instances = {}
};


function GamePadButtonDownProcesserBuilder:New(classname, level, loseFocus)
    if self.instances[classname] then
        return self.instances[classname]
    end
    local frame = CreateFrame("Frame", nil, nil);
    frame:SetPoint("CENTER", UIParent, "CENTER");
    frame:SetSize(1, 1);
    frame.Register = Register;
    frame.ComputeIndex = ComputeIndex;
    frame.Handle = Handle;
    frame.Group = Group;
    frame.Switch = Switch;
    frame.Destroy = Destroy;
    frame.LostFocus = LostFocus;
    frame:SetFrameLevel(level);
    frame:EnableGamePadButton(true);
    frame:SetScript("OnGamePadButtonDown", Handle);
    frame.classname = classname;
    frame.groups = {};
    frame.groupNames = {};
    frame.currentGroupIndex = 0;
    frame.currentIndex = 0;
    frame.handlers = {};
    --把...参数的值传给relations数组
    frame.LoseFocus = loseFocus;
    self.instances[classname] = frame
    return frame
end
