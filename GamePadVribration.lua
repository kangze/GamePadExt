local addonName, addonTable = ...

local unpack = unpack;
local AceGUI = LibStub("AceGUI-3.0");
local config = LibStub("AceConfig-3.0");
local configDialog = LibStub("AceConfigDialog-3.0");

local E = {};
addonTable.E = E;

--震动的强度和时间长短
local GamePadExtConfig_IntensityAndTimes =
{
    currency = { "High", 0.6, 0.2 },
    extraAction = { "High", 0.7, 0.3 }
}

function E:InitGamePadVirbration()
    local db=addonTable.D;
    local GamePadExtAddon=addonTable.GamePadExtAddon;
    GamePadExtAddon:RegisterEvent("CURRENCY_DISPLAY_UPDATE",function(eventName,...) E:Event(eventName,...) end);
    GamePadExtAddon:RegisterEvent("SPELLS_CHANGED",function(eventName,...) E:Event(eventName,...) end);
    GamePadExtAddon:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED",function(eventName,...) E:Event(eventName,...) end);
end

function E:Event(eventName,...)
    if(eventName=='CURRENCY_DISPLAY_UPDATE') then
        E:ProccessVibration(eventName,...);
    elseif(eventName=='SPELLS_CHANGED') then
        E:ProccessVibration(eventName,...);
    elseif(eventName=='PLAYER_MOUNT_DISPLAY_CHANGED') then
        E:ProccessCamera(eventName,...);
    end
end


function E:ProccessVibration(eventName, ...)
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

function E:ProccessCamera(eventName, ...)
    -- if (IsMounted() == false) then
    --     SetCVar("test_cameraOverShoulder", "0")
    -- else
    --     SetCVar("test_cameraOverShoulder", "5")
    -- end
end
