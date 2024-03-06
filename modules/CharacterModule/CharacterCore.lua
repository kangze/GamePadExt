local slotNames = {
    "HeadSlot",          --头部
    "NeckSlot",          --颈部
    "ShoulderSlot",      --肩部
    "BackSlot",          --背部
    "ChestSlot",         --胸部
    "ShirtSlot",         --衬衣
    "TabardSlot",        --战袍
    "WristSlot",         --护腕

    "HandsSlot",         --手
    "WaistSlot",         --腰部
    "LegsSlot",          --腿部
    "FeetSlot",          --脚
    "Finger0Slot",       --戒指1
    "Finger1Slot",       --戒指2
    "Trinket0Slot",      --饰品1
    "Trinket1Slot",      --饰品2
    "MainHandSlot",      --主手
    "SecondaryHandSlot", --副手
    -- "RangedSlot",        --远程
}

--{slotName,texture,itemLink}

function CharacterCore_GetEquipments()
    local equipments = {}
    for i = 1, #slotNames do
        local slotId, texture = GetInventorySlotInfo(slotNames[i]);
        local itemLink = GetInventoryItemLink("player", slotId);
        if itemLink then
            table.insert(equipments, { slotName = slotNames[i], texture = texture, itemLink = itemLink });
        else
            table.insert(equipments, nil);
        end
    end
    return equipments
end

function CharacterCore_HasAndGetGems(itemLink)
    if not itemLink then return; end
    local tooltipData = C_TooltipInfo.GetHyperlink(itemLink);
    if not tooltipData then return end;

    local lines = tooltipData.lines;
    local numLines = #lines;

    for i = 1, numLines do --max 10
        local line = lines[i];
        if (line and line.socketType) then
            return true, line.leftText, line.socketType, line.leftColor;
        end
    end
    return nil, nil, nil, nil;
end

function CharacterCore_HasAndGetEnchant(itemLink)
    if not itemLink then return; end
    local tooltipData = C_TooltipInfo.GetHyperlink(itemLink);
    if not tooltipData then return end;

    local lines = tooltipData.lines;
    local numLines = #lines;

    for i = 1, numLines do --max 10
        local line = lines[i];
        if (line and line.enchantID) then
            return true, line.enchantID, line.enchantText;
        end
    end
    return nil, nil, nil;
end

function CharacterCore_HasAndGetUseInfo(itemLink)
    if not itemLink then return; end
    local tooltipData = C_TooltipInfo.GetHyperlink(itemLink);
    if not tooltipData then return end;

    local lines = tooltipData.lines;
    local numLines = #lines;

    for i = 1, numLines do --max 10
        local line = lines[i];
        if (line and line.leftText and string.find(line.leftText, "使用") ~= nil) then
            return true, line.leftText;
        end
    end
    return nil, nil, nil;
end

function CharacterCore_HasAndGetPassiveEffectInfo(itemLink)
    if not itemLink then return; end
    local tooltipData = C_TooltipInfo.GetHyperlink(itemLink);
    if not tooltipData then return end;

    local lines = tooltipData.lines;
    local numLines = #lines;

    for i = 1, numLines do --max 10
        local line = lines[i];
        if (line and line.leftText and string.find(line.leftText, "装备") ~= nil) then
            return true, line.leftText;
        end
    end
    return nil, nil, nil;
end

function CharacterFrameTabActiveCallBack(headFrame)
    local frame = CreateFrame("Frame", nil, nil, "CharacterTabsFrameTemplate");
    frame.tab_equipment:SetHeight(headFrame:GetHeight() - 2);
    frame.tab_equipment:SetHeight(headFrame:GetHeight() - 2);

    frame.tab_faction:SetHeight(headFrame:GetHeight() - 2);
    frame.tab_faction:SetHeight(headFrame:GetHeight() - 2);

    frame.tab_currency:SetHeight(headFrame:GetHeight() - 2);
    frame.tab_currency:SetHeight(headFrame:GetHeight() - 2);

    local gamePadInitor = GamePadInitor:Init(GamePadInitorNames.CharacterTabFrame.Name,
        GamePadInitorNames.CharacterTabFrame.Level);
    gamePadInitor:Add(frame.tab_equipment, "group", GamePadInitorNames.CharacterEquipmentFrame.Name);
    gamePadInitor:Add(frame.tab_faction, "group", GamePadInitorNames.CharacterFactionFrame.Name);
    gamePadInitor:Add(frame.tab_currency, "group", GamePadInitorNames.CharacterCurrencyFrame.Name);
    gamePadInitor:SetRegion(frame);
    RegisterCharacterTabGamepadButtonDown(gamePadInitor);
    return frame;
end

--C_TooltipInfo.GetHyperlink(GetInventoryItemLink("player", 5))
-- print(gemName);
-- print(gemLink);

--CharacterCore_HasAndGetEnchant()

--返回玩家的等级，以及自适应等级
function GetUserLevel()
    local level = UnitLevel("player");
    local level2 = UnitEffectiveLevel("player");
    return level, level2;
end

--返回玩家的天赋信息,也有可能玩家没有,比如10级之前
function GetUserSpec()
    local primaryTalentTree = GetSpecialization();
    local specName;
    if (primaryTalentTree) then
        _, specName = GetSpecializationInfo(primaryTalentTree, nil, nil, nil, UnitSex("player"));
    end
    return specName;
end

--获取玩家得职业信息
function GetUserClass()
    local classDisplayName, class = UnitClass("player");
    local classColorString = RAID_CLASS_COLORS[class].colorStr;
    return classDisplayName, classColorString;
end

--获取玩家得基础属性

function GetUserProperties()
    -- [1] = { stat = "STRENGTH", primary = LE_UNIT_STAT_STRENGTH },
    -- 		[2] = { stat = "AGILITY", primary = LE_UNIT_STAT_AGILITY },
    -- 		[3] = { stat = "INTELLECT", primary = LE_UNIT_STAT_INTELLECT },
    -- 		[4] = { stat = "STAMINA" },
    -- 		[5] = { stat = "ARMOR" },
    -- 		[6] = { stat = "STAGGER", hideAt = 0, roles = { Enum.LFGRole.Tank }},
    -- 		[7] = { stat = "MANAREGEN", roles =  { Enum.LFGRole.Healer } },
    UnitStat("player", 1);
end

--PaperDollFrame.lua 692
--3 耐力
--2 敏捷
--1 力量
--4 智力
function GetUserStrength()
    local stat, effectiveStat, posBuff, negBuff = UnitStat("player", 4);
    local effectiveStatDisplay = BreakUpLargeNumbers(effectiveStat);
    -- Set the tooltip text
    local statName = _G["SPELL_STAT" .. 4 .. "_NAME"];
    local tooltipText = HIGHLIGHT_FONT_COLOR_CODE .. format(PAPERDOLLFRAME_TOOLTIP_FORMAT, statName) .. " ";
    if ((posBuff == 0) and (negBuff == 0)) then
        tooltipText = tooltipText .. effectiveStatDisplay .. FONT_COLOR_CODE_CLOSE;
    else
        tooltipText = tooltipText .. effectiveStatDisplay;
        if (posBuff > 0 or negBuff < 0) then
            tooltipText = tooltipText .. " (" .. BreakUpLargeNumbers(stat - posBuff - negBuff) .. FONT_COLOR_CODE_CLOSE;
        end
        if (posBuff > 0) then
            tooltipText = tooltipText ..
                FONT_COLOR_CODE_CLOSE .. GREEN_FONT_COLOR_CODE .. "+" .. BreakUpLargeNumbers(posBuff) ..
                FONT_COLOR_CODE_CLOSE;
        end
        if (negBuff < 0) then
            tooltipText = tooltipText .. RED_FONT_COLOR_CODE .. " " ..
                BreakUpLargeNumbers(negBuff) .. FONT_COLOR_CODE_CLOSE;
        end
        if (posBuff > 0 or negBuff < 0) then
            tooltipText = tooltipText .. HIGHLIGHT_FONT_COLOR_CODE .. ")" .. FONT_COLOR_CODE_CLOSE;
        end
        -- If there are any negative buffs then show the main number in red even if there are
        -- positive buffs. Otherwise show in green.
        if (negBuff < 0 and not GetPVPGearStatRules()) then
            effectiveStatDisplay = RED_FONT_COLOR_CODE .. effectiveStatDisplay .. FONT_COLOR_CODE_CLOSE;
        end
    end
    print(stat, effectiveStat, effectiveStatDisplay, tooltipText);
    return stat, effectiveStat, effectiveStatDisplay, tooltipText;
end

--GetUserStrength();

local stats = {
    [1] = { stat = "STRENGTH", primary = LE_UNIT_STAT_STRENGTH },
    [2] = { stat = "AGILITY", primary = LE_UNIT_STAT_AGILITY },
    [3] = { stat = "INTELLECT", primary = LE_UNIT_STAT_INTELLECT },
    [4] = { stat = "STAMINA" },
    [5] = { stat = "ARMOR" },
    [6] = { stat = "STAGGER", hideAt = 0, roles = { Enum.LFGRole.Tank } },
    [7] = { stat = "MANAREGEN", roles = { Enum.LFGRole.Healer } },
};

--PaperDollFrame.lua 604
function GetUserStat(index)

end

function GetUserStats()
    local spec, role;
    spec = GetSpecialization();
    if spec then
        role = GetSpecializationRoleEnum(spec);
    end

    for statIndex = 1, #stats do
        local stat = stats[statIndex];
        local showStat = true;
        if (showStat and stat.primary and spec) then
            local primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")));
            if (stat.primary ~= primaryStat) then
                showStat = false;
            end
        end

        if (showStat and stat.roles) then
            local foundRole = false;
            for _, statRole in pairs(stat.roles) do
                if (role == statRole) then
                    foundRole = true;
                    break;
                end
            end
            showStat = foundRole;
        end

        if (showStat) then
            GetUserStat(stat.stat);
        end
    end
end
