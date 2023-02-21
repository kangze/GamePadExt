local _, addon = ...

local GamePadGroupMixin = {
    index = 1,
    description = ""
}
local function CreateGamePadGroup(name, index, frame, parentFrame, description)
    if not name then
        print("A name is required");
        return
    end

    local object = {
        currentFrame = frame,
        parentFrame = parentFrame,
        index = index,
        description = description
    };
    for k, v in pairs(GamePadGroupMixin) do
        object[k] = v;
    end

    addon.actionGroups[name .. index] = object;
    return object
end

local function GetGamePadGroup(name, index)
    return addon.actionGroups[name .. index];
end

addon.CreateGamePadGroup = CreateGamePadGroup;
addon.GetGamePadGroup = GetGamePadGroup;
addon.actionGroups = {};


function GamePadGroupMixin:Navgate(x, y)
    --上下移动
    self.currentFrame:OnLeave();
    if (y == 0) then
        local group = addon.GetGamePadGroup(self.parentGroup, self.index + x);
        if (group) then
            group:OnEnter();
        end
    end
end

function GamePadGroupMixin:OnEnter()
    if (self.currentFrame) then
        self.currentFrame:OnEnter();
        self.currentFrame:EnableGamePadButton(true);
        self.currentFrame:SetScript("OnGamePadButtonDown", function(self, key)
            if (key == "DPAD_UP") then
                self:Navgate(0, -1);
            elseif (key == "DPAD_DOWN") then
                self:Navgate(0, 1);
            elseif (key == "DPAD_LEFT") then
                self:Navgate( -1, 0);
            elseif (key == "DPAD_RIGHT") then
                self:Navgate(1, 0);
            end
        end);
    end
end

function GamePadGroupMixin:OnLeave()
    if (self.currentFrame) then
        self.currentFrame:OnLeave();
    end
end
