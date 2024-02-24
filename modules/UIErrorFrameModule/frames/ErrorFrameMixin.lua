ErrorFrameMixin = {};

local show_callback = function(frame)
    return function(current)
        if (frame) then
            frame:SetPoint("TOP", 0, -current * 100);
        end
    end
end

local hide_callback = function(frame)
    return function(current)
        frame:SetAlpha(current);
    end
end

--UIErrorsFrame
function ErrorFrameMixin:OnLoad()
    self:AppendShadow(2, nil);
    --
    self.show_animation = Animation:new(0.3, 1, 2, show_callback(self), function() self.hide_animation:Play() end, EasingFunctions.OutSine);
    self.hide_animation = Animation:new(1, 1, 0, hide_callback(self), nil, EasingFunctions.OutSine);
end
