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
        _base_start = start,
        _base_ends = ends,
        _base_end_callback = end_callback,
    }

    frame:SetScript("OnUpdate", function(selfs, elapsed)
        selfs.current = selfs.current + elapsed
        if animation._callback then
            animation._callback(easingFunction(selfs.current, animation._start, animation._ends,
                animation._duration));
        end
        if selfs.current >= animation._duration then
            selfs:Hide()
            selfs.current = 0;
            animation._start = animation._base_start;
            animation._ends = animation._base_ends;
            if animation._end_callback then
                animation._end_callback();
                animation._end_callback = animation._base_end_callback;
            end
            return
        end
    end)

    setmetatable(animation, Animation)
    return animation
end

function Animation:Play(start, ends)
    if start then
        self._start = start
    end
    if ends then
        self._ends = ends
    end
    self._frame:Show()
end

function Animation:PlayReverse(end_callback)
    local temp = self._start;
    self._start = self._ends;
    self._ends = temp;
    self._end_callback = end_callback;
    self._frame:Show();
end
