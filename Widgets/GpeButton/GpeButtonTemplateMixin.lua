local _,AddonData=...;

GpeButtonTemplateMixin = {};


function GpeButtonTemplateMixin:OnLoad()

end

function GpeButtonTemplateMixin:OnGamePadButtonDown(...)
    self.gamePadButtonDownProcessor:Handle(...);
end

function GpeButtonTemplateMixin:InitEnableGamePadButton(templateName, group)
    self:EnableGamePadButton(true);
    local processor = GamePadButtonDownProcesser:New(templateName);
    processor:Group(group, self);
    self.gamePadButtonDownProcessor = processor;
end

function GpeButtonTemplateMixin:Destory()
    self:EnableGamePadButton(false);
    self:UnregisterAllEvents();
    self:Hide();
    self.gamePadButtonDownProcessor:Destory();
end