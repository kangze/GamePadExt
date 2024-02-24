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

--UIErrorsFrame
function ErrorFrameMixin:OnLoad()
    self:AppendShadow(2, nil);
    --function() self.hide_animation:Play() end
    self.show_animation = Animation:new(0.3, 1, 2, show_callback(self), nil, EasingFunctions.OutSine);
    --self.hide_animation = Animation:new(0.3, 2, 1, hide_callback(self), nil, EasingFunctions.OutSine);
end

-- -- 保存原始的 AddMessage 函数
-- local originalAddMessage = UIErrorsFrame.AddMessage

-- -- 创建新的 AddMessage 函数
-- function UIErrorsFrame:AddMessage(message, r, g, b, id, accessID, typeID)
--     -- 在这里处理错误消息
--     -- 如果你不想显示错误消息，你可以直接返回
--     -- 如果你想显示错误消息，你可以调用原始的 AddMessage 函数
--     -- originalAddMessage(self, message, r, g, b, id, accessID, typeID)
-- end
