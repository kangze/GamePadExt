local stats = {
    [1] = { stat = "STRENGTH", primary = LE_UNIT_STAT_STRENGTH, statIndex = LE_UNIT_STAT_STRENGTH },
    [2] = { stat = "AGILITY", primary = LE_UNIT_STAT_AGILITY, statIndex = LE_UNIT_STAT_AGILITY },
    [3] = { stat = "INTELLECT", primary = LE_UNIT_STAT_INTELLECT, statIndex = LE_UNIT_STAT_INTELLECT },
    [4] = { stat = "STAMINA", statIndex = LE_UNIT_STAT_STAMINA },
    [5] = { stat = "ARMOR" },
    [6] = { stat = "STAGGER", hideAt = 0, roles = { Enum.LFGRole.Tank } },
    [7] = { stat = "MANAREGEN", roles = { Enum.LFGRole.Healer } },
};

function CharacterCore_GetTooltipText(statIndex)
    stat, effectiveStat, posBuff, negBuff = UnitStat("player", statIndex);
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
    return statName, effectiveStatDisplay, tooltipText;
end

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
        print(statName);
        print(tooltipText);
        print(tooltip2);
        -- Stamina
    elseif (statIndex == LE_UNIT_STAT_STAMINA) then
        tooltip2 = format(tooltip2,
            BreakUpLargeNumbers(((effectiveStat * UnitHPPerStamina("player"))) * GetUnitMaxHealthModifier("player")));
        print(statName);
        print(tooltipText);
        print(tooltip2);
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
    elseif (statIndex == 7) then
        return CharacterCore_GetManaRegen();
    end
end

function CharacterCore_GetSTAMINA()
    local statName, value, tooltip1 = CharacterCore_GetTooltipText(LE_UNIT_STAT_STAMINA);
    _, effectiveStat = UnitStat("player", LE_UNIT_STAT_STAMINA);
    local tooltip2 = _G["DEFAULT_STAT" .. LE_UNIT_STAT_STAMINA .. "_TOOLTIP"];
    tooltip2 = format(tooltip2,
        BreakUpLargeNumbers(((effectiveStat * UnitHPPerStamina("player"))) * GetUnitMaxHealthModifier("player")));
    local result = { statName = statName, value = value, tooltip1 = tooltip1, tooltip2 = tooltip2 };
    return result;
end

function CharacterCore_GetAGILITY()
    local statName, value, tooltip1 = CharacterCore_GetTooltipText(LE_UNIT_STAT_AGILITY);
    local tooltip2 = _G["DEFAULT_STAT" .. LE_UNIT_STAT_AGILITY .. "_TOOLTIP"];
    local primaryStat, spec, role;
    spec = GetSpecialization();
    if (spec) then
        role = GetSpecializationRole(spec);
        primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")));
    end

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

    local result = { statName = statName, value = value, tooltip1 = tooltip1, tooltip2 = tooltip2 };
    return result;
end

--获取力量
function CharacterCore_GetSTRENGTH()
    local statName, value, tooltip1 = CharacterCore_GetTooltipText(LE_UNIT_STAT_STRENGTH);
    local tooltip2 = _G["DEFAULT_STAT" .. LE_UNIT_STAT_STRENGTH .. "_TOOLTIP"];
    local primaryStat, spec, role;
    spec = GetSpecialization();
    if (spec) then
        role = GetSpecializationRole(spec);
        primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")));
    end

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

    local result = { statName = statName, value = value, tooltip1 = tooltip1, tooltip2 = tooltip2 };
    return result;
end

--获取智力
function CharacterCore_GetINTELLECT()
    local statName, value, tooltip1 = CharacterCore_GetTooltipText(LE_UNIT_STAT_INTELLECT);
    local tooltip2 = _G["DEFAULT_STAT" .. LE_UNIT_STAT_INTELLECT .. "_TOOLTIP"];
    local primaryStat, spec, role;
    spec = GetSpecialization();
    if (spec) then
        role = GetSpecializationRole(spec);
        primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")));
    end

    if (HasAPEffectsSpellPower()) then
        tooltip2 = STAT_NO_BENEFIT_TOOLTIP;
    elseif (HasSPEffectsAttackPower()) then
        tooltip2 = STAT_TOOLTIP_BONUS_AP_SP;
    elseif (not primaryStat or primaryStat == LE_UNIT_STAT_INTELLECT) then
        tooltip2 = format(tooltip2, max(0, effectiveStat));
    else
        tooltip2 = STAT_NO_BENEFIT_TOOLTIP;
    end
    local result = { statName = statName, value = value, tooltip1 = tooltip1, tooltip2 = tooltip2 };
    return result;
end

--法力回复
---- All mana regen stats are displayed as mana/5 sec.
function CharacterCore_GetManaRegen()
    local base, combat = GetManaRegen();
    base = floor(base * 5.0);
    combat = floor(combat * 5.0);
    local baseText = BreakUpLargeNumbers(base);
    local combatText = BreakUpLargeNumbers(combat);
    local tooltipText = HIGHLIGHT_FONT_COLOR_CODE ..
        format(PAPERDOLLFRAME_TOOLTIP_FORMAT, MANA_REGEN) .. " " .. combatText .. FONT_COLOR_CODE_CLOSE;
    local tooltip2 = format(MANA_REGEN_TOOLTIP, baseText);
    local result = {
        statName = statName,
        value = base,
        tooltip1 = tooltipText,
        tooltip2 = tooltip2
    };
    return result;
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

--GetUserArmor();
