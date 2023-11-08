local _, Addon = ...;

local outSine = Addon.EasingFunctions.outSine;
local inOutSine = Addon.EasingFunctions.inOutSine;
local linear = Addon.EasingFunctions.linear;

local After = C_Timer.After;

local AnimationFrame = {};
local AlphaAnimationFrame = {};
local ShoulderAnimationFrame = {};
local MoveViewAnimationFrame = {};
local ViewPitchLimitAnimationFrame = {};
local CameraFocus = {};


function AnimationFrame.New(duration, callback)
    local frame = CreateFrame("Frame");
    frame.total = 0;
    frame:Hide();

    frame:SetScript("OnUpdate", function(self, elapsed)
        self.total = self.total + elapsed;
        if (callback) then callback(self.total) end
        if (self.total >= duration) then
            self:Hide();
            self:UnregisterAllEvents();
            self = nil;
        end
    end);
    return frame;
end

function AlphaAnimationFrame.New(duration, frame)
    --0 是完全透明的
    local startAlpha, endAlpha = frame.startAlpha, frame.endAlpha;
    frame:SetAlpha(startAlpha);
    frame:Show();
    local callback = function(total)
        local alpha = linear(total, startAlpha, endAlpha, duration);
        if (alpha > 1 or alpha < 0) then return end;
        frame:SetAlpha(alpha);
        if (total >= duration or endAlpha == 0) then
            frame:Hide();
        end
    end
    local animationFrame = AnimationFrame.New(duration, callback);
    return animationFrame;
end

function ShoulderAnimationFrame.New(duration)
    local callback = function(total)
        local value = outSine(total, 0, 0.79, duration);
        SetCVar("test_cameraOverShoulder", value);
    end
    local animationFrame = AnimationFrame.New(duration, callback);
    SetCVar("test_cameraOverShoulder", "0");
    return animationFrame;
end

function MoveViewAnimationFrame.New(duration)
    local callback = function(total)
        local speed = inOutSine(total, 1.05, 0.004, duration);
        MoveViewRightStart(speed);
    end
    local animatioFrame = AnimationFrame.New(duration, callback);
    return animatioFrame;
end

function ViewPitchLimitAnimationFrame.New(duration)
    local callback = function(total)
        local PL = tostring(outSine(total, 88, 1, duration));
        ConsoleExec("pitchlimit " .. PL);
    end
    local animatioFrame = AnimationFrame.New(duration, callback);
    return animatioFrame;
end

--Instance
function CameraFocus:Enter()
    local shoulder  = ShoulderAnimationFrame.New(1.5);
    local moveView  = MoveViewAnimationFrame.New(1.5);
    local pitchView = ViewPitchLimitAnimationFrame.New(1.5);
    local goal      = 2;
    local target    = GetCameraZoom() - goal;
    CameraZoomIn(target);
    moveView:Show();
    shoulder:Show();
    pitchView:Show();
end

Addon.ShoulderAnimationFrame = ShoulderAnimationFrame;
Addon.MoveViewAnimationFrame = MoveViewAnimationFrame;
Addon.ViewPitchLimitAnimationFrame = ViewPitchLimitAnimationFrame;
Addon.AlphaAnimationFrame = AlphaAnimationFrame;
Addon.CameraFocus = CameraFocus;
