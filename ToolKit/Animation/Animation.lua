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
            animation:ResetArg();
            return
        end
    end)

    setmetatable(animation, Animation)
    return animation
end

function Animation:ResetArg()
    --重置
    self._frame.current = 0;
    self._start = self._base_start;
    self._ends = self._base_ends;
    if self._end_callback then
        self._end_callback();
        self._end_callback = self._base_end_callback;
    end
end

function Animation:Stop()
    if self._frame:IsShown() then
        self._frame:Hide()
        -- 如果有结束回调，执行它
        if self._end_callback then
            self._end_callback()
        end
    end
    self:ResetArg();
end

function Animation:Play(start, ends)
    self:Stop() -- 停止当前动画
    if start then
        self._start = start
    end
    if ends then
        self._ends = ends
    end
    self._frame:Show()
end

function Animation:PlayReverse(end_callback)
    self:Stop() -- 停止当前动画
    local temp = self._start
    self._start = self._ends
    self._ends = temp
    self._end_callback = end_callback
    self._frame:Show()
end
