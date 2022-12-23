local _,Addon=...;

local CameraMover = {};


--Move Shoulder
function CameraMover:MoveShoulder()
    local frame=CreateFrame("Frame");
    frame:Hide();
    frame.total=0;
    local outSine=Addon.EasingFunctions.outSine;
    frame:SetScript("OnUpdate",function(selfs,elapsed)
        selfs.total=selfs.total+elapsed;
        local value = outSine(frame.total,0, 0.79, 1.5); --shoulder
        SetCVar("test_cameraOverShoulder", value);
        if(frame.total>=1.5) then
            frame:Hide();
        end
    end);
end

function CameraMover:CameraMoveView()
    local frame=CreateFrame("Frame");
    frame:Hide();
    frame.total=0;
    local inOutSine=Addon.EasingFunctions.inOutSine;
    frame:SetScript("OnUpdate",function(selfs,elapsed)
        selfs.total=selfs.total+elapsed;
        local speed = inOutSine(frame.total, 1, 0.004, 1.5);
        MoveViewRightStart(speed);
        if(frame.total>=1.5) then
            MoveViewRightStop();
            frame:Hide();
        end
    end);
end