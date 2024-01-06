BodyFrameMixin = {};


function BodyFrameMixin:OnLoad()
    local scale = UIParent:GetEffectiveScale();
    local width = GetScreenWidth() * scale
    local height = GetScreenHeight() * scale - 30;
    self:SetSize(width, height);
    local animation = Animation:new(0.3, 0, 1, function(current)
        self:SetAlpha(current);
    end, nil, EasingFunctions.OutSine);
    self.animation = animation;
end