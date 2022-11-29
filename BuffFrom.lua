local addonName, addonTable = ...

local unpack = unpack;
local AceGUI = LibStub("AceGUI-3.0");
local config = LibStub("AceConfig-3.0");
local configDialog = LibStub("AceConfigDialog-3.0");

local db=addonTable.D;

local B = {};
addonTable.B = B;
local mountData={};

local function LoadMountData()
    local mountIDs = C_MountJournal.GetMountIDs()
    for key, value in ipairs(mountIDs) do
        local creatureName, spellId, icon, active, summonable, source, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected, mountID = C_MountJournal.GetMountInfoByID(value)
        if spellId then
            mountData[spellId] = (isCollected and 1 or -1) * mountID
        end
    end
    for i = 1, C_MountJournal.GetNumMounts() do
        local creatureName, spellId, icon, active, summonable, source, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected, mountID = C_MountJournal.GetDisplayedMountInfo(i)
        if spellId then
            mountData[spellId] = (isCollected and 1 or -1) * mountID
        end
    end
end

local function showMountInfo(spellId)
    local mountID = mountData[spellId]
    if (mountID) then
        local creatureDisplayID, descriptionText, sourceText, isSelfMount = C_MountJournal.GetMountInfoExtraByID(abs(mountID))
        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine("坐骑来源：", mountID > 0 and "(已收集)" or "(未收集)", mountID > 0 and 0 or 1, mountID > 0 and 1 or 0, 0, mountID > 0 and 0 or 1, mountID > 0 and 1 or 0, 0)
        GameTooltip:AddLine(sourceText, 1, 1, 1)
        GameTooltip:Show()
    end
end

local function hookMountBuffInfo(self, unit, index, filter)
    if InCombatLockdown() then return end
    if not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) then return end
    local name, texture, count, debuffType, duration, expirationTime, _, _, _, spellId, _, _, _, _, timeMod = UnitAura(unit, index, filter);
    showMountInfo(spellId)
end

local function hookMountBuffInfoForTarget(self, unit, auraInstanceID)
    if InCombatLockdown() then return end
    if not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) then return end
    local aura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID)
    local spellId = aura.spellId
    showMountInfo(spellId)
end

local function getFormatterText(class)
    local color=RAID_CLASS_COLORS[class];
    local text = format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
    return text;
end

local function SetCaster(self, unit, index, filter)
    -- if(db.profile.buffer.from ~= true) then
    --     return
    -- end
    local name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitBuff(unit, index, filter)
    --local unitCaster=unpack(UnitBuff(unit, index, filter));
    if unitCaster then
        local uname, urealm = UnitName(unitCaster)
        local _, uclass = UnitClass(unitCaster)
        if urealm then uname = uname .. '-' .. urealm end
        self:AddLine(" ");
        self:AddLine('法术来源: ' .. '|cff00ff00 |r' .. (getFormatterText(uclass)) .. uname .. '|cff00ff00 |r')
        self:Show()
    end
end

function B:InitBuffFrom()
    --加载坐骑数据
    LoadMountData();

    hooksecurefunc(GameTooltip, 'SetUnitAura', SetCaster)
    hooksecurefunc(GameTooltip, 'SetUnitAura', hookMountBuffInfo)
    hooksecurefunc(GameTooltip, "SetUnitBuff", hookMountBuffInfo)
    hooksecurefunc(GameTooltip, 'SetUnitBuff', function(self, unit, index, filter)
        filter = filter and ('HELPFUL ' .. filter) or 'HELPFUL'
        SetCaster(self, unit, index, filter)
    end)
    hooksecurefunc(GameTooltip, 'SetUnitDebuff', function(self, unit, index, filter)
        filter = filter and ('HARMFUL ' .. filter) or 'HARMFUL'
        SetCaster(self, unit, index, filter)
    end)
end