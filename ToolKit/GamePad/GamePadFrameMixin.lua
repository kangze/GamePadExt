GamePadFrameMixin = {};

function GamePadFrameMixin:InitEnableGamePadButton(templateName, group, level,frame)
    local processor = GamePadButtonDownProcesserBuilder:New(templateName,group, level,frame);
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

function GamePadFrameMixin:Destroy()
    self:UnregisterAllEvents();
    self:SetParent(nil);
    self:Hide();
    self.gamePadButtonDownProcessor:Destroy();
end
