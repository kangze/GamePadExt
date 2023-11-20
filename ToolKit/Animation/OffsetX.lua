local default_duration = 0.3;
local default_start = -100;
local default_end = 0;

local function InitOffsetXAnimation(frame, relative, start, ends, duration, end_callback)
    start = start or default_start;
    ends = ends or default_end;
    duration = duration or default_duration;

    local callback = function(current)
        local y = 0; -- Replace with your desired y value
        local current = OutSine(current, start, ends, duration);
        frame:SetPoint("RIGHT", relative, current, y);
    end

    local animation = CreateAnimationFrame(duration, callback, end_callback);
    frame._offsetXAnimation = animation;
end

local function ShowOffsetXAnimation(frame)
    frame._offsetXAnimation:Show();
end

Gpe:AddFrameApi("InitOffsetXAnimation", InitOffsetXAnimation)
Gpe:AddFrameApi("ShowOffsetXAnimation", ShowOffsetXAnimation)
