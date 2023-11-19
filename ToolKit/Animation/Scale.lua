local default_duration=0.3;
local default_scale=1.04;

local function ScaleFadeIn(frame)
    local callback = function(current)
        local current = OutSine(current, 1, default_scale, default_duration);
        frame:SetScale(current);
    end
    local animation = CreateAnimationFrame(default_duration, callback);
    animation:Show();
end

local function ScaleFadeOut(frame)
    local callback = function(current)
        local current = OutSine(current, default_scale, 1, default_duration);
        frame:SetScale(current);
    end
    local animation = CreateAnimationFrame(default_duration, callback);
    animation:Show();
end

Gpe:AddFrameApi("ScaleFadeIn", ScaleFadeIn)
Gpe:AddFrameApi("ScaleFadeOut", ScaleFadeOut)