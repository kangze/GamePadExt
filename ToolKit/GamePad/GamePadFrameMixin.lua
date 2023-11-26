GamePadFrameMixin = {};

function GamePadFrameMixin:InitEnableGamePadButton(templateName, group, level, loseFocus)
    local processor = GamePadButtonDownProcesserBuilder:New(templateName, level, loseFocus);
    processor:Group(group, self);
    self.gamePadButtonDownProcessor = processor;
end

function GamePadFrameMixin:InitEableGamePadButtonGroup(templateName, group, level, loseFocus)
    local processor = GamePadButtonDownProcesserBuilder:New(templateName, level, loseFocus);
    local frames = self:GetGamePadFrames();
    for i = 1, #frames do
        local frame = frames[i];
        processor:Group(group, frame);
    end
    self.gamePadButtonDownProcessor = processor;
end

function GamePadFrameMixin:Destory()
    self:EnableGamePadButton(false);
    self:UnregisterAllEvents();
    self:Hide();
    self.gamePadButtonDownProcessor:Destory();
end
