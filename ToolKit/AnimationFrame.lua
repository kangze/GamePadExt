local _, AddonData = ...;
local Gpe = _G["Gpe"];

local AnimationFrame = {};
AddonData.AnimationFrame = AnimationFrame;

function AnimationFrame.New(duration, callback)
    local frame = CreateFrame("Frame");
    frame.current = 0;
    frame:Hide();
    local updateCallback = function(selfs, elapsed)
        selfs.current = selfs.current + elapsed;
        if (callback) then
            callback(selfs.current)
        end
        if (selfs.current >= duration) then
            selfs:Hide();
            selfs.current = 0;
            return;
        end
    end
    frame:SetScript("OnUpdate", updateCallback);
    return frame;
end
