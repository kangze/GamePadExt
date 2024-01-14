BodyFrameMixin = {};


function BodyFrameMixin:OnLoad()
    local scale = UIParent:GetEffectiveScale();
    local width = GetScreenWidth() * scale
    local height = GetScreenHeight() * scale - 30;
    self:SetSize(width, height);
    self.animation_alpha = Animation:new(0.3, 0, 1, function(current) self:SetAlpha(current); end, nil,
        EasingFunctions.OutSine);
end

function BodyFrameMixin:AnimationIn()
    self:Show();
    self.animation_alpha:Play();
end

function BodyFrameMixin:AnimationOut()
    self.animation_alpha:PlayReverse(function() self:Hide(); end);
end
