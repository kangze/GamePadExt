GamePadFrameMixin = {};

function GamePadFrameMixin:InitEnableGamePadButton(templateName, group, level, loseFocus)
    local processor = GamePadButtonDownProcesserBuilder:New(templateName, level, loseFocus);
    processor:Group(group, self);
    self.gamePadButtonDownProcessor = processor;
end

function GamePadFrameMixin:Destory()
    self:EnableGamePadButton(false);
    self:UnregisterAllEvents();
    self:Hide();
    self.gamePadButtonDownProcessor:Destory();
end
