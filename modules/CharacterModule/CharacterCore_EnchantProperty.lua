--获取附加属性集合
function CharacterCore_GetEnchantProperties()
    local properties = {};
    --获取精通
    local masteryName, mastery, master_tooltip, spellName, description = CharacterCore_GetMastery();
    table.insert(properties,
        { name = masteryName, value = mastery, spellName = spellName, description = description, tooltip = master_tooltip });

    --获取急速
    local hasteName, haste, haste_tooltip = CharacterCore_GetHaste();
    table.insert(properties,
        { name = hasteName, value = haste, tooltip = haste_tooltip });

    --获取暴击
    local critChanceName, CritChance, critChance_tooltip = CharacterCore_GetCritChance();
    table.insert(properties,
        { name = critChanceName, value = CritChance, tooltip = critChance_tooltip });

    --获取全能
    local versatilityName, versatility, versatility_tooltip = CharacterCore_GetVersatility();
    table.insert(properties,
        { name = versatilityName, value = versatility, tooltip = versatility_tooltip });

    --获取加速
    local speedName, speed, speed_tooltip = CharacterCore_GetSpeed();
    table.insert(properties, { name = speedName, value = speed, tooltip = speed_tooltip });

    --获取生命偷取
    local lifestealName, lifesteal, lifesteal_tooltip = CharacterCore_GetLifesteal();
    table.insert(properties, { name = lifestealName, value = lifesteal, tooltip = lifesteal_tooltip });

    --获取闪避
    local avoidanceName, avoidance, avoidance_tooltip = CharacterCore_GetAvoidance();
    table.insert(properties, { name = avoidanceName, value = avoidance, tooltip = avoidance_tooltip });

    return properties;
end

--schools:
-- 1物理
-- 2神圣
-- 3火焰
-- 4自然
-- 5冰霜
-- 6暗影
-- 7奥术


--获取玩家的暴击信息
function CharacterCore_GetCritChance()
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
    local tooltip = nil;
    local extraCritChance = GetCombatRatingBonus(rating);
    local extraCritRating = GetCombatRating(rating);
    if (GetCritChanceProvidesParryEffect()) then
        tooltip = format(CR_CRIT_PARRY_RATING_TOOLTIP, BreakUpLargeNumbers(extraCritRating), extraCritChance,
            GetCombatRatingBonusForCombatRatingValue(CR_PARRY, extraCritRating));
    else
        tooltip = format(CR_CRIT_TOOLTIP, BreakUpLargeNumbers(extraCritRating), extraCritChance);
    end

    return STAT_CRITICAL_STRIKE, critChance, tooltip;
end

--获取玩家的急速信息
function CharacterCore_GetHaste()
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

    local _, class = UnitClass("player");
    local tooltip2 = _G["STAT_HASTE_" .. class .. "_TOOLTIP"];
    if (not tooltip2) then
        tooltip2 = STAT_HASTE_TOOLTIP;
    end
    tooltip2 = tooltip2 ..
        format(STAT_HASTE_BASE_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(rating)), GetCombatRatingBonus(rating));
    return STAT_HASTE, haste, tooltip2;
end

--精通有点特殊--12846
function CharacterCore_GetMastery()
    local mastery, bonusCoeff = GetMasteryEffect();
    local tooltip;
    local description;
    local spellName;
    local masteryBonus = GetCombatRatingBonus(CR_MASTERY) * bonusCoeff;

    local primaryTalentTree = GetSpecialization();
    if (primaryTalentTree) then
        local masterySpell, masterySpell2 = GetSpecializationMasterySpells(primaryTalentTree);
        description = GetSpellDescription(masterySpell);
        spellName = GetSpellInfo(masterySpell)
        tooltip = format(STAT_MASTERY_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_MASTERY)), masteryBonus);
    else
        tooltip = STAT_MASTERY_TOOLTIP_NO_TALENT_SPEC;
    end
    return STAT_MASTERY, mastery, spellName, description, tooltip;
end

--获取全能
function CharacterCore_GetVersatility()
    local versatility = GetCombatRating(CR_VERSATILITY_DAMAGE_DONE);
    local versatilityDamageBonus = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) +
        GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE);
    local versatilityDamageTakenReduction = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_TAKEN) +
        GetVersatilityBonus(CR_VERSATILITY_DAMAGE_TAKEN);
    
    local tooltip = format(CR_VERSATILITY_TOOLTIP, versatilityDamageBonus, versatilityDamageTakenReduction,
        BreakUpLargeNumbers(versatility), versatilityDamageBonus, versatilityDamageTakenReduction);
    return STAT_VERSATILITY, versatilityDamageBonus, tooltip;
end

--获取加速
function CharacterCore_GetSpeed()
    local speed = GetSpeed();
    local tooltip = format(CR_SPEED_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_SPEED)),
        GetCombatRatingBonus(CR_SPEED));
    return STAT_SPEED, speed, tooltip;
end

--获取生命偷取
function CharacterCore_GetLifesteal()
    local lifesteal = GetLifesteal();
    local tooltip = format(CR_LIFESTEAL_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_LIFESTEAL)),
        GetCombatRatingBonus(CR_LIFESTEAL));
    return STAT_LIFESTEAL, lifesteal, tooltip;
end

--获取闪避
function CharacterCore_GetAvoidance()
    local avoidance = GetAvoidance();
    local tooltip = format(CR_AVOIDANCE_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_AVOIDANCE)),
        GetCombatRatingBonus(CR_AVOIDANCE));
    return STAT_AVOIDANCE, avoidance, tooltip;
end