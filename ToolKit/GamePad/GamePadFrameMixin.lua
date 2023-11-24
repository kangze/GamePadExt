GamePadFrameMixin = {};

function GamePadFrameMixin:OnGamePadButtonDown(...)
    self.gamePadButtonDownProcessor:Handle(...);
end

function GamePadFrameMixin:InitEnableGamePadButton(templateName, group, buttonGroup)
    self:EnableGamePadButton(true);
    local processor = GamePadButtonDownProcesser:New(templateName, buttonGroup);
    processor:Group(group, self);
    self.gamePadButtonDownProcessor = processor;
end

function GamePadFrameMixin:Destory()
    self:EnableGamePadButton(false);
    self:UnregisterAllEvents();
    self:Hide();
    self.gamePadButtonDownProcessor:Destory();
end
