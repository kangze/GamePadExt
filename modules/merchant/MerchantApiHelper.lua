MerchantApiHelper = {};


function MerchantApiHelper:GetCostInfo(index)
    local itemCount = GetMerchantItemCostInfo(index)

    if (itemCount == 0) then
        local _, texture, price, _, _, isUsable = GetMerchantItemInfo(index)
        return price, true;
    end

    local cost = "";

    for i = 1, itemCount do
        local itemTexture, itemValue, itemLink, currencyName = GetMerchantItemCostItem(index, i);
        cost = cost .. itemValue;
        if (itemLink) then
            if string.match(itemLink, "currency:(%d+)") then
                -- This is a currency link
                local currencyID = tonumber(string.match(itemLink, "currency:(%d+)"))
                local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyID)
                if currencyInfo and currencyInfo.iconFileID then
                    local iconString = "|T" .. currencyInfo.iconFileID .. ":0|t"
                    cost = cost .. " " .. iconString .. " " .. itemLink
                else
                    print("Invalid currency ID: " .. currencyID)
                end
            elseif string.match(itemLink, "item:(%d+)") then
                -- This is an item link
                local itemID = tonumber(string.match(itemLink, "item:(%d+)"))
                local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon, vendorPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent =
                    GetItemInfo(itemID)
                if itemIcon then
                    local iconString = "|T" .. itemIcon .. ":0|t"
                    cost = cost .. " " .. iconString .. " " .. itemLink
                else
                    print("Invalid item ID: " .. itemID)
                end
            end
        else
            if (currencyName) then
                cost = cost .. currencyName
            end
        end
    end
    return cost, false;
end

function MerchantApiHelper:GetMerchantBuyItemInfo(index)
    local itemLink = GetMerchantItemLink(index);
    local _, texture, price, quantity, numAvailable, isUsable = GetMerchantItemInfo(index)
    local itemID, _, itemQuality = GetItemInfo(itemLink);
    local cost, isMoney = MerchantApiHelper:GetCostInfo(index);
    return itemLink, cost, texture, itemQuality, isMoney, isUsable;
end
