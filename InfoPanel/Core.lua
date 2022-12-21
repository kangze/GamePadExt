local _,Addon=...;
local After=C_Timer.After;



function Addon:OnLoad_InfoPanel()
    C_Timer.NewTimer(5,function ()
        SetCVar("test_cameraDynamicPitch", 1);
        local frame=self:CameraEnter();    
        frame:Show();
        SetView(2);
        After(0.1,function()
            CameraZoomIn(3.55);
        end);
    end)
end



function Addon:CameraEnter()
    local frame=CreateFrame("Frame");
    frame:Hide();
    frame.total=0;
    local inOutSine=Addon.EasingFunctions.inOutSine;
    local outSine=Addon.EasingFunctions.outSine;
    frame:SetScript("OnUpdate",function (selfs,elapsed)
        selfs.total=selfs.total+elapsed;
        local speed = inOutSine(frame.total, 1, 0.004, 1.5);	--inOutSine
        local PL = tostring(outSine(frame.total, 88,  1, 1.5));	--outSine
        local value = outSine(frame.total,0, 0.79, 1.5); --shoulder
        SetCVar("test_cameraOverShoulder", value);
        MoveViewRightStart(speed);
        ConsoleExec( "pitchlimit "..PL)
        if(frame.total>=1.5) then
            MoveViewRightStop();
            frame:Hide();
            ConsoleExec( "pitchlimit 1");
		    After(0, function()
			ConsoleExec( "pitchlimit 88");
		end)
        end
        
    end)
    return frame;
end