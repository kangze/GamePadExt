local _, AddonData = ...;

HeaderFrameMixin = {};

function HeaderFrameMixin:OnLoad()
    local scale = UIParent:GetEffectiveScale();
    local width = GetScreenWidth() * scale
    local height = 30;
    self:SetSize(width, height);
    local animation = Animation:new(0.3, 0, 1, function(current)
        self:SetAlpha(current);
        print(current);
    end, nil, EasingFunctions.OutSine);
    self.animation = animation;
end
