local _, AddonData = ...;

HeaderFrameMixin = {};

--TODO:这里的bug解决
local alaphAnimation_callback = function(frame)
    return function(current)
        if (current > 0) then
            frame:SetAlpha(current);
        end
    end
end

function HeaderFrameMixin:OnLoad()
    local scale = UIParent:GetEffectiveScale();
    local width = GetScreenWidth() * scale
    local height = 30;
    self:SetSize(width, height);
    self.animation_alpha = Animation:new(0.3, 0.3, 1, alaphAnimation_callback(self), nil, EasingFunctions.OutSine);
end

function HeaderFrameMixin:AnimationIn()
    self:Show();
    self.animation_alpha:Play();
end

function HeaderFrameMixin:AnimationOut()
    self.animation_alpha:PlayReverse(function() self:Hide(); end);
end
