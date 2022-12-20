local _, Addon = ...

--震动的强度和时间长短
local GamePadExtConfig_IntensityAndTimes =
{
    currency = { "High", 0.6, 0.2 },
    extraAction = { "High", 0.7, 0.3 }
}

function Addon:OnLoad_GamePadVirbration()
    local GamePadExtAddon=Addon.GamePadExtAddon;
    GamePadExtAddon:RegisterEvent("CURRENCY_DISPLAY_UPDATE",function(eventName,...) E:Event(eventName,...) end);
    GamePadExtAddon:RegisterEvent("SPELLS_CHANGED",function(eventName,...) E:Event(eventName,...) end);
    GamePadExtAddon:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED",function(eventName,...) E:Event(eventName,...) end);
end

function Addon:Event(eventName,...)
    if(eventName=='CURRENCY_DISPLAY_UPDATE') then
        self:ProccessVibration(eventName,...);
    elseif(eventName=='SPELLS_CHANGED') then
        self:ProccessVibration(eventName,...);
    elseif(eventName=='PLAYER_MOUNT_DISPLAY_CHANGED') then
        self:ProccessCamera(eventName,...);
    end
end


function Addon:ProccessVibration(eventName, ...)
    local config = nil;
    local arg1 = ...;
    local ablits = C_ZoneAbility.GetActiveAbilities();
    if (eventName == "CURRENCY_DISPLAY_UPDATE" and arg1 ~= nil) then
        local currencyType, quantity, quantityChange = ...;
        config = GamePadExtConfig_IntensityAndTimes.currency;
    else if (eventName == "SPELLS_CHANGED" and #ablits > 0) then
            config = GamePadExtConfig_IntensityAndTimes.extraAction;
        end
    end
    if (config == nil) then
        return
    end
    local vibrationType, intensity, time = unpack(config);
    C_GamePad.SetVibration(vibrationType, intensity);
    C_Timer.After(time, function()
        C_GamePad.StopVibration();
    end);
end

function Addon:ProccessCamera(eventName, ...)
    -- if (IsMounted() == false) then
    --     SetCVar("test_cameraOverShoulder", "0")
    -- else
    --     SetCVar("test_cameraOverShoulder", "5")
    -- end
end
