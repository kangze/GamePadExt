BodyFrameMixin = {};


function BodyFrameMixin:OnLoad()
    local scale = UIParent:GetEffectiveScale();
    local width = GetScreenWidth() * scale
    local height = GetScreenHeight() * scale - 30;
    self:SetSize(width, height);
    self.animation_fadeIn = Animation:new(0.3, 0, 1, function(current) self:SetAlpha(current); end, nil,
        EasingFunctions.OutSine);
    self.animation_fadeOut = Animation:new(0.3, 1, 0, function(current) self:SetAlpha(current); end, nil,
        EasingFunctions.OutSine);
end
