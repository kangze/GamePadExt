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
