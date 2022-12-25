local _, Addon = ...;

local outSine = Addon.EasingFunctions.outSine;
local inOutSine = Addon.EasingFunctions.inOutSine;
local linear=Addon.EasingFunctions.linear;

local After = C_Timer.After;

local AnimationFrame = {};
local ShoulderAnimationFrame = {};
local MoveViewAnimationFrame = {};
local ViewPitchLimitAnimationFrame = {};
local UIParentAlphaAnimtationFrame={};
local CameraFocus = {};


function AnimationFrame.New(duration, callback)
    local frame = CreateFrame("Frame");
    frame.total = 0;
    frame:Hide();

    frame:SetScript("OnUpdate", function(selfs, elapsed)
        selfs.total = selfs.total + elapsed;
        if (callback) then callback(selfs.total) end
        if (selfs.total >= duration) then
            selfs:Hide();
            MoveViewRightStop();
        end
    end);
    return frame;
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
        print(speed);
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

function UIParentAlphaAnimtationFrame.New(duration)
    local callback=function(total)
        local alpha = linear(total, 1, 0, duration);
        print(alpha);
        if(alpha>1 or alpha<0) then return end;
        UIParent:SetAlpha(alpha);
    end
    local animationFrame=AnimationFrame.New(duration,callback);
    return animationFrame;
end



--Instance
function CameraFocus:Enter()
    After(0, function()
        local shoulder  = ShoulderAnimationFrame.New(1.5);
        local moveView  = MoveViewAnimationFrame.New(1.5);
        local pitchView = ViewPitchLimitAnimationFrame.New(1.5);
        local goal=2;
        moveView:Show();
        shoulder:Show();
        pitchView:Show();
        After(0.1, function()
            local target = GetCameraZoom() - goal;
            CameraZoomIn(target);
        end);
    end);
end

Addon.ShoulderAnimationFrame = ShoulderAnimationFrame;
Addon.MoveViewAnimationFrame = MoveViewAnimationFrame;
Addon.ViewPitchLimitAnimationFrame = ViewPitchLimitAnimationFrame;
Addon.UIParentAlphaAnimtationFrame=UIParentAlphaAnimtationFrame;
Addon.CameraFocus=CameraFocus;