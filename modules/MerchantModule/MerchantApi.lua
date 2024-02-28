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
    local maxColum = 2; --b
    local middle = math.ceil(numItems / maxColum);
    for index = 1, numItems do
        local col = math.ceil(index / middle);
        local itemLink = GetMerchantItemLink(index);
        local _, texture, price, _, _, isUsable = GetMerchantItemInfo(index)
        local currencyCount = GetMerchantItemCostInfo(index)
        local itemID, _, itemQuality, _, _, itemType, itemSubType = GetItemInfo(itemLink);
        if (currencyCount == 0) then
            callback(index, col, middle, itemLink, price, texture, itemQuality, true, isUsable, hasTransMog);
        else
            callback(index, col, middle, itemLink, cost, texture, itemQuality, false, isUsable, hasTransMog);
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

function MerchantApi:ProcessMerchantBuyBackInfo(callback)
    local numBuybackItems = GetNumBuybackItems();
    local maxColum = 2; --b
    local middle = math.ceil(numBuybackItems / maxColum);
    for index = 1, numBuybackItems do
        local col = math.ceil(index / middle);
        local itemLink = GetBuybackItemLink(index);
        local name, icon, price, quantity, numAvailable, isUsable = GetBuybackItemInfo(index);
        callback(index, col, middle, itemLink, price, icon, quantity, true, isUsable, false);
    end
end

function MerchantApi:GetCostInfo(index)
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

function MerchantApi:GetMerchantBuyItemInfo(index)
    local itemLink = GetMerchantItemLink(index);
    local _, texture, price, quantity, numAvailable, isUsable = GetMerchantItemInfo(index);
    local itemID, _, itemQuality = GetItemInfo(itemLink);
    local cost, isMoney = MerchantApi:GetCostInfo(index);
    return itemLink, cost, texture, itemQuality, isMoney, isUsable;
end

function MerchantApi:GetMerchantBuyItemInfos()
    local infos = {};
    local nums = GetMerchantNumItems();
    for index = 1, nums do
        itemLink, cost, texture, itemQuality, isMoney, isUsable = self:GetMerchantBuyItemInfo(index)
        table.insert(infos, { itemLink, cost, texture, itemQuality, isMoney, isUsable });
        -- local name, texture, price, stackCount, numAvailable, isPurchasable, isUsable, extendedCost, currencyID, spellID;
        -- name, texture, price, stackCount, numAvailable, isPurchasable, isUsable, extendedCost, currencyID, spellID = GetMerchantItemInfo(index);
    end
    return infos;
end

--TODO:测试
function MerchantApi:GetBuybackItemInfo(index)
    local name, icon, price, quantity = GetBuybackItemInfo(index)
    local itemLink = GetBuybackItemLink(index);
    return itemLink, nil, icon, quantity, false, true;
end

function MerchantApi:GetMerchantBuybackItemInfos()
    local infos = {};
    local nums = GetNumBuybackItems();
    for index = 1, nums do
        itemLink, cost, texture, itemQuality, isMoney, isUsable = self:GetBuybackItemInfo(index)
        table.insert(infos, { itemLink, cost, texture, itemQuality, isMoney, isUsable });
    end
    return infos;
end

function MerchantApi:GetMerchantItemInfosNew()
    local infos = {};
    local nums = GetMerchantNumItems();
    for index = 1, nums do
        local info = {};
        local name, texture, price, stackCount, numAvailable, isPurchasable, isUsable, extendedCost, currencyID, spellID =
            GetMerchantItemInfo(index);
        if (currencyID) then
            name, texture, numAvailable = CurrencyContainerUtil.GetCurrencyContainerInfo(currencyID, numAvailable, name,
                texture, nil);
        end
        local canAfford = CanAffordMerchantItem(index);
        info.canAford = canAfford;
        info.name = name;
        info.stackCount = stackCount;
        info.numAvailable = numAvailable;
        info.texture = texture;
        info.price = price;
        info.link = GetMerchantItemLink(index);

        if (extendedCost) then
            info.extendedCost = true;
            info.extendedCostValue = {};
            local itemCount = GetMerchantItemCostInfo(index);
            for i = 1, itemCount do
                local itemTexture, itemValue, itemLink, currencyName = GetMerchantItemCostItem(index, i);
                if (itemTexture) then
                    info.extendedCostValue[i] = {
                        itemTexture = itemTexture,
                        itemValue = itemValue,
                        itemLink = itemLink,
                        currencyName = currencyName
                    };
                end
            end
        end

        --是否可以退款
        info.showNonrefundablePrompt = not C_MerchantFrame.IsMerchantItemRefundable(index);

        --传家宝
        local merchantItemID = GetMerchantItemID(index);
        local isHeirloom = merchantItemID and C_Heirloom.IsItemHeirloom(merchantItemID);
        local isKnownHeirloom = isHeirloom and C_Heirloom.PlayerHasHeirloom(merchantItemID);
        --是否是传家宝
        info.isHeirloom = isHeirloom;
        --已经收集了的传家宝
        info.isKnownHeirloom = isKnownHeirloom;

        --设定index,
        info.index = index;

        --染红色,表示不能购买/不能够使用
        local tintRed = not isPurchasable or (not isUsable and not isHeirloom);
        info.tintRed = tintRed;
        table.insert(infos, info);
    end
    return infos;
end
