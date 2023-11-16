local _, AddonData = ...;

HeaderMixin = {};

function HeaderMixin:OnLoad()
    self:EnableGamePadButton(true);
    self:InitShowFadeInAndOut();
end


