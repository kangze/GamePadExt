local _, AddonData = ...;

HeaderFrameMixin = {};

function HeaderFrameMixin:OnLoad()
    --self:EnableGamePadButton(true);
    local scale = UIParent:GetEffectiveScale();
    local width = GetScreenWidth() * scale
    local height = 30;
    self:SetSize(width, height);
    self:InitShowFadeInAndOut();
    self:InitShadowAndAnimation();
end

function HeaderFrameMixin:OnEnter()

end

function HeaderFrameMixin:OnShow()
    self:ShowFadeIn();
end
