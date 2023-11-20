local _, AddonData = ...;

DressupFrameTemplateMixin = {}

function DressupFrameTemplateMixin:OnLoad()
    self:EnableGamePadStick(true);
end

function DressupFrameTemplateMixin:OnEvent()
    -- self.model:SetUnit("player");
    -- self.model:Show();
end

function DressupFrameTemplateMixin:TryOn(itemLink)
    self.model:TryOn(itemLink);
end

function DressupFrameTemplateMixin:Destroy()
    --self:UnregisterEvent("UNIT_MODEL_CHANGED");
    self:Hide();
end

function DressupFrameTemplateMixin:SetPlayer()
    self.model:SetUnit("player");
end

function DressupFrameTemplateMixin:OnGamePadStick(...)
    local direction, position,y = ...;
    if direction == "Left" then
        -- Adjust the model's facing and pitch based on the stick's position
        local facing = self.model:GetFacing();
        local pitch = self.model:GetPitch();
        self.model:SetFacing(facing + position * 0.05);
    end
end
