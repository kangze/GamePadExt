

--创建动画帧
Animation = {}
Animation.__index = Animation

function Animation:new(duration, start, ends, callback, end_callback, easingFunction)
    local frame = CreateFrame("Frame")
    frame.current = 0
    frame:Hide()

    local animation = {
        _start = start,
        _ends = ends,
        _callback = callback,
        _end_callback = end_callback,
        _duration = duration,
        _frame = frame,
    }

    frame:SetScript("OnUpdate", function(selfs, elapsed)
        selfs.current = selfs.current + elapsed
        if animation._callback then
            animation._callback(easingFunction(selfs.current, animation._start, animation._ends,
                animation._duration));
        end
        if selfs.current >= animation._duration then
            selfs:Hide()
            selfs.current = 0
            if animation._end_callback then
                animation._end_callback()
            end
            return
        end
    end)

    setmetatable(animation, Animation)
    return animation
end

function Animation:Play()
    self._frame:Show()
end
