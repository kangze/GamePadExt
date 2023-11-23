

GamePadFrameMixin={};

function GamePadFrameMixin:OnGamePadButtonDown(...)
    self.gamePadButtonDownProcessor:Handle(...);
end

function GamePadFrameMixin:InitEnableGamePadButton(templateName, group)
    self:EnableGamePadButton(true);
    local processor = GamePadButtonDownProcesser:New(templateName);
    processor:Group(group, self);
    self.gamePadButtonDownProcessor = processor;
end

function GamePadFrameMixin:Destory()
    self:EnableGamePadButton(false);
    self:UnregisterAllEvents();
    self:Hide();
    self.gamePadButtonDownProcessor:Destory();
end