local default_duration = 0.2;

local function InitScrollAnimation(frame, start, ends)
    local callback = function(current)
        local current = OutSine(current, start, ends, default_duration);
        frame:SetVerticalScroll(current);
    end

    local animation = CreateAnimationFrame(default_duration, callback);
    frame._scrollAnimation = animation;
end

local function SetVerticalScrollFade(frame, start, ends)
    frame:InitScrollAnimation(start, ends);
    frame._scrollAnimation:Show();
end

Gpe:AddScrollFrameApi("InitScrollAnimation", InitScrollAnimation)
Gpe:AddScrollFrameApi("SetVerticalScrollFade", SetVerticalScrollFade)
