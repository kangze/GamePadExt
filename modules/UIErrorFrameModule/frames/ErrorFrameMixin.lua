ErrorFrameMixin = {};

local show_callback = function(frame)
    return function(current)
        if (frame) then
            frame:SetPoint("TOP", 0, -current * 50);
        end
    end
end

local hide_callback = function(frame)
    return function(current)
        frame:SetAlpha(current);
    end
end

function ErrorFrameMixin:OnLoad()
    self:AppendShadow(2, nil);
    --function() self.hide_animation:Play() end
    self.show_animation = Animation:new(0.3, 1, 2, show_callback(self), nil, EasingFunctions.OutSine);
    --self.hide_animation = Animation:new(0.3, 2, 1, hide_callback(self), nil, EasingFunctions.OutSine);
end
