BodyFrameMixin = {};

--TODO:这里的bug解决
local alaphAnimation_callback = function(frame)
    return function(current)
        frame:SetAlpha(current);
    end
end

function BodyFrameMixin:OnLoad()
    local scale = UIParent:GetEffectiveScale();
    local width = GetScreenWidth() * scale
    local height = GetScreenHeight() * scale - 30;
    self:SetSize(width, height);
    self.animation_alpha = Animation:new(0.3, 0, 1, alaphAnimation_callback(self), nil,
        EasingFunctions.OutSine);
end

function BodyFrameMixin:AnimationIn()
    self:Show();
    self.animation_alpha:Play();
end

function BodyFrameMixin:AnimationOut()
    self.animation_alpha:PlayReverse(function() self:Hide(); end);
end
