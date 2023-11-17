local _, AddonData = ...;

HeaderMixin = {};

function HeaderMixin:OnLoad()
    --self:EnableGamePadButton(true);
    local width = UIParent:GetWidth();
    self:SetSize(1920, 30);
    
end

function HeaderMixin:OnEnter()
    self:InitShowFadeInAndOut();
    self:InitShadowAndAnimation();
    self:ShowShadow();
end
