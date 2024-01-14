local _, AddonData = ...;

HeaderFrameMixin = {};

function HeaderFrameMixin:OnLoad()
    local scale = UIParent:GetEffectiveScale();
    local width = GetScreenWidth() * scale
    local height = 30;
    self:SetSize(width, height);
    self.animation_alpha = Animation:new(0.3, 0, 1, function(current)
        self:SetAlpha(current);
    end, nil, EasingFunctions.OutSine);
end

function HeaderFrameMixin:AnimationIn()
    self:Show();
    self.animation_alpha:Play();
end

function HeaderFrameMixin:AnimationOut()
    self.animation_alpha:PlayReverse(function() self:Hide(); end);
end
