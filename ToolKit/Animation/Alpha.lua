local default_duration = 0.5;

local function InitShowFadeInAndOut(frame, duration)
    local start = 1;
    local ends = 0;
    local duration = duration or default_duration;
    local callbackOut = function(current)
        local current = OutSine(current, start, ends, duration);
        frame:SetAlpha(current);
    end;
    local callbackIn = function(current)
        local current = OutSine(current, ends, start, duration);
        frame:SetAlpha(current);
    end;
    local animationOut = CreateAnimationFrame(duration, callbackOut);
    local animationIn = CreateAnimationFrame(duration, callbackIn);
    frame._showFadeOut = animationOut;
    frame._showFadeIn = animationIn;
end

local function ShowFadeIn(frame)
    frame._showFadeIn:Show();
end

local function ShowFadeOut(frame)
    frame._showFadeOut:Show();
end

Gpe:AddFrameApi("InitShowFadeInAndOut", InitShowFadeInAndOut)
Gpe:AddFrameApi("ShowFadeIn", ShowFadeIn)
Gpe:AddFrameApi("ShowFadeOut", ShowFadeOut)
