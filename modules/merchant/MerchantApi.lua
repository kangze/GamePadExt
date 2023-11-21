local _, AddonData = ...;
local Gpe = _G["Gpe"];


MerchantApi = {};

--获取商人出售的商品信息
function MerchantApi:PreProccessItemsInfo(callback)
    local numItems = GetMerchantNumItems()
    local count = 0
    local function checkItems()
        count = 0
        for i = 1, numItems do
            local itemLink = GetMerchantItemLink(i)
            if itemLink then
                count = count + 1
            end
            print(itemLink);
        end
        if count < numItems then
            C_Timer.After(1, checkItems) -- Wait for 1 second before checking again
        else
            MerchantApi:ProccessMerchantItemsInfo(callback)
        end
    end
    checkItems()
end

function MerchantApi:ProccessMerchantItemsInfo(callback)
    local numItems = GetMerchantNumItems();
    for index = 1, numItems do
        local page = math.ceil(index / 10)
        local itemLink = GetMerchantItemLink(index);
        local _, texture, price, _, _, isUsable = GetMerchantItemInfo(index)
        local currencyCount = GetMerchantItemCostInfo(index)
        local itemID, _, itemQuality, _, _, itemType, itemSubType = GetItemInfo(itemLink);
        if (currencyCount == 0) then
            callback(index, page, itemLink, price, texture, itemQuality, true, isUsable, hasTransMog);
        else
            local cost = "";
            for j = 1, currencyCount do
                local itemTexture, itemValue, itemLink, currencyName = GetMerchantItemCostItem(index, j);
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
                    cost = cost .. currencyName
                end
            end
            callback(index, page, itemLink, cost, texture, itemQuality, false, isUsable, hasTransMog);
        end
    end
end

function MerchantApi:GetCannotBuyReason(index)
    local tooltip = C_TooltipInfo.GetMerchantItem(index);
    for i = 1, #tooltip.lines do
        local line = tooltip.lines[i]["leftText"];
        if line then
            if string.find(line, "获得") or string.find(line, "无法使用") then
                return line;
            end
        end
    end
    return "未查询到购买要求";
end
