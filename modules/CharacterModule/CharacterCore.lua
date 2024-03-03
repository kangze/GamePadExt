local slotNames = {
    "HeadSlot", --头部
    -- "NeckSlot",          --颈部
    -- "ShoulderSlot",      --肩部
    -- "BackSlot",          --背部
    -- "ChestSlot",         --胸部
    -- "ShirtSlot",         --衬衣
    -- "TabardSlot",        --战袍
    -- "WristSlot",         --护腕
    -- "HandsSlot",         --手
    -- "WaistSlot",         --腰部
    -- "LegsSlot",          --腿部
    -- "FeetSlot",          --脚
    -- "Finger0Slot",       --戒指1
    -- "Finger1Slot",       --戒指2
    -- "Trinket0Slot",      --饰品1
    -- "Trinket1Slot",      --饰品2
    -- "MainHandSlot",      --主手
    -- "SecondaryHandSlot", --副手
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

    local gamePadInitor = GamePadInitor:Init(GamePadInitorNames.MerchantTabFrame.Name,
        GamePadInitorNames.MerchantTabFrame.Level);
    gamePadInitor:Add(frame.tab_equipment, "group", GamePadInitorNames.CharacterEquipmentFrame.Name);
    gamePadInitor:Add(frame.tab_faction, "group", GamePadInitorNames.CharacterFactionFrame.Name);
    gamePadInitor:Add(frame.tab_currency, "group", GamePadInitorNames.CharacterCurrencyFrame.Name);
    gamePadInitor:SetRegion(frame);
    RegisterMerchantTabGamepadButtonDown(gamePadInitor);
    return frame;
end

--C_TooltipInfo.GetHyperlink(GetInventoryItemLink("player", 5))
-- print(gemName);
-- print(gemLink);

--CharacterCore_HasAndGetEnchant()
