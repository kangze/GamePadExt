--数字表示列
slotNames = {
    { "HeadSlot",          1 }, --头部
    { "NeckSlot",          1 }, --颈部
    { "ShoulderSlot",      1 }, --肩部
    { "BackSlot",          1 }, --背部
    { "ChestSlot",         1 }, --胸部
    { "ShirtSlot",         1 }, --衬衣
    { "TabardSlot",        1 }, --战袍
    { "WristSlot",         1 }, --护腕

    { "HandsSlot",         3 }, --手
    { "WaistSlot",         3 }, --腰部
    { "LegsSlot",          3 }, --腿部
    { "FeetSlot",          3 }, --脚
    { "Finger0Slot",       3 }, --戒指1
    { "Finger1Slot",       3 }, --戒指2
    { "Trinket0Slot",      3 }, --饰品1
    { "Trinket1Slot",      3 }, --饰品2
    { "MainHandSlot",      1 }, --主手
    { "SecondaryHandSlot", 3 }, --副手
    -- "RangedSlot",        --远程
}

--{slotName,texture,itemLink}

function CharacterCore_GetEquipments()
    local equipments = {}
    for i = 1, #slotNames do
        local slotId, texture = GetInventorySlotInfo(slotNames[i][1]);
        local itemLink = GetInventoryItemLink("player", slotId);
        if itemLink then
            --获取装备等级
            local _, _, _, itemLevel = GetItemInfo(itemLink)
            --获取宝石信息
            local sockets = CharacterCore_HasAndGetSockets(itemLink);
            --获取插槽信息
            local gems = CharacterCore_HasAndGetGems(itemLink);
            table.insert(equipments,
                {
                    slotName = slotNames[i][1],
                    texture = texture,
                    itemLink = itemLink,
                    itemLevel = itemLevel,
                    gems = gems,
                    sockets =
                        sockets
                });
        else
            table.insert(equipments, { slotName = slotNames[i][1], texture = texture, itemLink = nil, itemLevel = 0 });
        end
    end
    return equipments
end

function CharacterCore_HasAndGetGems(itemLink)
    local gems = {};
    for index = 1, 3 do
        local gemName, gemLink = GetItemGem(itemLink, index) -- 获取这个物品的第一个宝石
        if gemName then
            table.insert(gems, { gemName = gemName, gemLink = gemLink });
        end
    end
    return gems;
end

function CharacterCore_HasAndGetSockets(itemLink)
    local sockets = {};
    if not itemLink then return sockets; end
    local tooltipData = C_TooltipInfo.GetHyperlink(itemLink);
    if not tooltipData then return sockets end;

    
    local lines = tooltipData.lines;
    local numLines = #lines;

    for i = 1, numLines do --max 10
        local line = lines[i];
        if (line and line.socketType) then
            table.insert(sockets, { socketType = line.socketType, leftText = line.leftText, leftColor = line.leftColor });
        end
    end
    return sockets;
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
    [1] = { stat = "STRENGTH", primary = LE_UNIT_STAT_STRENGTH, statIndex = LE_UNIT_STAT_STRENGTH },
    [2] = { stat = "AGILITY", primary = LE_UNIT_STAT_AGILITY, statIndex = LE_UNIT_STAT_AGILITY },
    [3] = { stat = "INTELLECT", primary = LE_UNIT_STAT_INTELLECT, statIndex = LE_UNIT_STAT_INTELLECT },
    [4] = { stat = "STAMINA", statIndex = LE_UNIT_STAT_STAMINA },
    [5] = { stat = "ARMOR" },
    [6] = { stat = "STAGGER", hideAt = 0, roles = { Enum.LFGRole.Tank } },
    [7] = { stat = "MANAREGEN", roles = { Enum.LFGRole.Healer } },
};

--PaperDollFrame.lua 604
function GetUserStat(unit, statIndex)
    local stat;
    local effectiveStat;
    local posBuff;
    local negBuff;
    stat, effectiveStat, posBuff, negBuff = UnitStat(unit, statIndex);
    local effectiveStatDisplay = BreakUpLargeNumbers(effectiveStat);
    local statName = _G["SPELL_STAT" .. statIndex .. "_NAME"];
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

    --PaperDollFrame_SetLabelAndText(statFrame, statName, effectiveStatDisplay, false, effectiveStat);
    local tooltip2 = _G["DEFAULT_STAT" .. statIndex .. "_TOOLTIP"];
    local _, unitClass = UnitClass("player");
    unitClass = strupper(unitClass);
    local primaryStat, spec, role;
    spec = GetSpecialization();
    if (spec) then
        role = GetSpecializationRole(spec);
        primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")));
    end

    if (statIndex == LE_UNIT_STAT_STRENGTH) then
        local attackPower = GetAttackPowerForStat(statIndex, effectiveStat);
        if (HasAPEffectsSpellPower()) then
            tooltip2 = STAT_TOOLTIP_BONUS_AP_SP;
        end
        if (not primaryStat or primaryStat == LE_UNIT_STAT_STRENGTH) then
            tooltip2 = format(tooltip2, BreakUpLargeNumbers(attackPower));
            if (role == "TANK") then
                local increasedParryChance = GetParryChanceFromAttribute();
                if (increasedParryChance > 0) then
                    tooltip2 = tooltip2 .. "|n|n" .. format(CR_PARRY_BASE_STAT_TOOLTIP, increasedParryChance);
                end
            end
        else
            tooltip2 = STAT_NO_BENEFIT_TOOLTIP;
        end
        -- Agility
    elseif (statIndex == LE_UNIT_STAT_AGILITY) then
        if (not primaryStat or primaryStat == LE_UNIT_STAT_AGILITY) then
            tooltip2 = HasAPEffectsSpellPower() and STAT_TOOLTIP_BONUS_AP_SP or STAT_TOOLTIP_BONUS_AP;
            if (role == "TANK") then
                local increasedDodgeChance = GetDodgeChanceFromAttribute();
                if (increasedDodgeChance > 0) then
                    tooltip2 = tooltip2 .. "|n|n" .. format(CR_DODGE_BASE_STAT_TOOLTIP, increasedDodgeChance);
                end
            end
        else
            tooltip2 = STAT_NO_BENEFIT_TOOLTIP;
        end
        -- Stamina
    elseif (statIndex == LE_UNIT_STAT_STAMINA) then
        tooltip2 = format(tooltip2,
            BreakUpLargeNumbers(((effectiveStat * UnitHPPerStamina("player"))) * GetUnitMaxHealthModifier("player")));
        -- Intellect
    elseif (statIndex == LE_UNIT_STAT_INTELLECT) then
        if (HasAPEffectsSpellPower()) then
            tooltip2 = STAT_NO_BENEFIT_TOOLTIP;
        elseif (HasSPEffectsAttackPower()) then
            tooltip2 = STAT_TOOLTIP_BONUS_AP_SP;
        elseif (not primaryStat or primaryStat == LE_UNIT_STAT_INTELLECT) then
            tooltip2 = format(tooltip2, max(0, effectiveStat));
        else
            tooltip2 = STAT_NO_BENEFIT_TOOLTIP;
        end
    end
    print("sss");
    print(tooltip2);
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
            local primaryStat = select(6, GetSpecializationInfo(1, nil, nil, nil, UnitSex("player")));
            if (stat.primary ~= primaryStat) then
                showStat = false;
                print("------");
                print(stat.primary, primaryStat);
                print("-------");
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
        if (showStat and stat.statIndex) then
            GetUserStat("player", stat.statIndex);
        end
    end
end

--GetUserStats();

function GetUserArmor()
    local baselineArmor, effectiveArmor, armor, bonusArmor = UnitArmor("player");
    --PaperDollFrame_SetLabelAndText(statFrame, STAT_ARMOR, BreakUpLargeNumbers(effectiveArmor), false, effectiveArmor);
    local armorReduction = PaperDollFrame_GetArmorReduction(effectiveArmor, UnitEffectiveLevel("player"));
    print(armorReduction);
    local armorReductionAgainstTarget = C_PaperDollInfo.GetArmorEffectivenessAgainstTarget(effectiveArmor);
    if (armorReductionAgainstTarget) then
        armorReductionAgainstTarget = armorReductionAgainstTarget * 100;
    end
    local tooltip = HIGHLIGHT_FONT_COLOR_CODE ..
        format(PAPERDOLLFRAME_TOOLTIP_FORMAT, ARMOR) ..
        " " .. BreakUpLargeNumbers(effectiveArmor) .. FONT_COLOR_CODE_CLOSE;
    local tooltip2 = format(STAT_ARMOR_TOOLTIP, armorReduction);
    local tooltip3;
    if (armorReductionAgainstTarget) then
        tooltip3 = format(STAT_ARMOR_TARGET_TOOLTIP, armorReductionAgainstTarget);
    end
    print(tooltip2);
end

GetUserArmor();

--schools:
-- 1物理
-- 2神圣
-- 3火焰
-- 4自然
-- 5冰霜
-- 6暗影
-- 7奥术


--获取玩家的暴击信息
function GetBaoJi()
    local rating;
    local spellCrit, rangedCrit, meleeCrit;
    local critChance;

    local result = {};
    local holySchool = 2;
    local minCrit = GetSpellCritChance(holySchool);
    result.spellCrit = {};
    result.spellCrit[holySchool] = minCrit;
    local spellCrit;
    for i = (holySchool + 1), MAX_SPELL_SCHOOLS do
        spellCrit = GetSpellCritChance(i);
        minCrit = min(minCrit, spellCrit);
        result.spellCrit[i] = spellCrit;
    end
    spellCrit = minCrit
    --远程攻击暴击几率
    rangedCrit = GetRangedCritChance();
    --近战暴击几率
    meleeCrit = GetCritChance();

    if (spellCrit >= rangedCrit and spellCrit >= meleeCrit) then
        critChance = spellCrit;
        rating = CR_CRIT_SPELL;
    elseif (rangedCrit >= meleeCrit) then
        critChance = rangedCrit;
        rating = CR_CRIT_RANGED;
    else
        critChance = meleeCrit;
        rating = CR_CRIT_MELEE;
    end

    local tooltip = HIGHLIGHT_FONT_COLOR_CODE ..
        format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_CRITICAL_STRIKE) .. FONT_COLOR_CODE_CLOSE;
    local tooltip2 = nil;
    local extraCritChance = GetCombatRatingBonus(rating);
    local extraCritRating = GetCombatRating(rating);
    if (GetCritChanceProvidesParryEffect()) then
        tooltip2 = format(CR_CRIT_PARRY_RATING_TOOLTIP, BreakUpLargeNumbers(extraCritRating), extraCritChance,
            GetCombatRatingBonusForCombatRatingValue(CR_PARRY, extraCritRating));
    else
        tooltip2 = format(CR_CRIT_TOOLTIP, BreakUpLargeNumbers(extraCritRating), extraCritChance);
    end

    print(critChance, tooltip, tooltip2);
end

--获取玩家的急速信息
function GetjiSu()
    local haste = GetHaste();
    local rating = CR_HASTE_MELEE;

    local hasteFormatString;
    if (haste < 0 and not GetPVPGearStatRules()) then
        hasteFormatString = RED_FONT_COLOR_CODE .. "%s" .. FONT_COLOR_CODE_CLOSE;
    else
        hasteFormatString = "%s";
    end

    local tooltip = HIGHLIGHT_FONT_COLOR_CODE .. format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_HASTE) ..
        FONT_COLOR_CODE_CLOSE;

    local _, class = UnitClass(unit);
    local tooltip2 = _G["STAT_HASTE_" .. class .. "_TOOLTIP"];
    if (not tooltip2) then
        tooltip2 = STAT_HASTE_TOOLTIP;
    end
    tooltip2 = tooltip2 ..
        format(STAT_HASTE_BASE_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(rating)), GetCombatRatingBonus(rating));
end

--精通有点特殊--12846
function GetJitong()
    local mastery = GetMasteryEffect();

    local _, class = UnitClass("player");
    local mastery, bonusCoeff = GetMasteryEffect();
    local masteryBonus = GetCombatRatingBonus(CR_MASTERY) * bonusCoeff;

    local primaryTalentTree = GetSpecialization();
    if (primaryTalentTree) then
        local masterySpell, masterySpell2 = GetSpecializationMasterySpells(primaryTalentTree);
        local description = GetSpellDescription(masterySpell);
        local tootiple = format(STAT_MASTERY_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_MASTERY)), masteryBonus);
    else
        local tooltip = STAT_MASTERY_TOOLTIP_NO_TALENT_SPEC;
    end
end

--获取全能
function GetQuanneng()
    local versatility = GetCombatRating(CR_VERSATILITY_DAMAGE_DONE);
    local versatilityDamageBonus = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) +
        GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE);
    local versatilityDamageTakenReduction = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_TAKEN) +
        GetVersatilityBonus(CR_VERSATILITY_DAMAGE_TAKEN);
    --PaperDollFrame_SetLabelAndText(statFrame, STAT_VERSATILITY, versatilityDamageBonus, true, versatilityDamageBonus);
    local tooltip = HIGHLIGHT_FONT_COLOR_CODE ..
        format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_VERSATILITY) .. FONT_COLOR_CODE_CLOSE;
    local tooltip2 = format(CR_VERSATILITY_TOOLTIP, versatilityDamageBonus, versatilityDamageTakenReduction,
        BreakUpLargeNumbers(versatility), versatilityDamageBonus, versatilityDamageTakenReduction);
    --statFrame:Show();
end

--获取加速
function GetSpeeds()
    local speed = GetSpeed();

    local tooltip = HIGHLIGHT_FONT_COLOR_CODE ..
        format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_SPEED) .. " " .. format("%.2F%%", speed) .. FONT_COLOR_CODE_CLOSE;
    local tooltip2 = format(CR_SPEED_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_SPEED)),
        GetCombatRatingBonus(CR_SPEED));
end

--获取生命偷取

function Getxixue()
    local lifesteal = GetLifesteal();
    local tooltip = HIGHLIGHT_FONT_COLOR_CODE ..
        format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_LIFESTEAL) ..
        " " .. format("%.2F%%", lifesteal) .. FONT_COLOR_CODE_CLOSE;
    local tooltip2 = format(CR_LIFESTEAL_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_LIFESTEAL)),
        GetCombatRatingBonus(CR_LIFESTEAL));
end

--获取闪避
function GetShanbi()
    local avoidance = GetAvoidance();

    local tooltip = HIGHLIGHT_FONT_COLOR_CODE ..
        format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_AVOIDANCE) ..
        " " .. format("%.2F%%", avoidance) .. FONT_COLOR_CODE_CLOSE;
    local tooltip2 = format(CR_AVOIDANCE_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_AVOIDANCE)),
        GetCombatRatingBonus(CR_AVOIDANCE));
end
