MerchantSkin = {
    ["MerchantItem"] = {
        Render = function(itemInfo)
            local frame = CreateFrame("Frame", nil, nil, "MerchantItemTemplate1");
            local itemLink = itemInfo.itemLink;
            if (itemLink) then
                itemLink = string.gsub(itemLink, "%[", "", 1);
                itemLink = string.gsub(itemLink, "%]", "", 1);
            end
            frame.productName:SetText(itemLink);
            if (itemInfo.price) then
                ApplyMoney(frame.costmoney, itemInfo.price);
            end

            if (itemInfo.costs and #itemInfo.costs > 0) then
                local itemsString = "";
                for i = 1, #itemInfo.costs do
                    local itemTexture = itemInfo.costs[i].itemTexture;
                    local costItemCount = itemInfo.costs[i].itemValue;
                    local itemLink = itemInfo.costs[i].itemLink;
                    local currencyName = itemInfo.costs[i].currencyName;

                    if (currencyName) then
                        if (itemsString) then
                            itemsString = itemsString ..
                                ", |T" ..
                                itemTexture ..
                                ":0:0:0:-1|t " .. format(CURRENCY_QUANTITY_TEMPLATE, costItemCount, currencyName);
                        else
                            itemsString = " |T" ..
                                itemTexture ..
                                ":0:0:0:-1|t " .. format(CURRENCY_QUANTITY_TEMPLATE, costItemCount, currencyName);
                        end
                    elseif (itemLink) then
                        local itemName, itemLink, itemQuality = GetItemInfo(itemLink);
                        if (itemsString) then
                            itemsString = itemsString ..
                                LIST_DELIMITER .. format(ITEM_QUANTITY_TEMPLATE, costItemCount, itemLink);
                        else
                            itemsString = format(ITEM_QUANTITY_TEMPLATE, costItemCount, itemLink);
                        end
                    end
                end
                frame.costmoney:SetText(itemsString);
            end

            if (not hasTransMog) then
                frame.mog:SetDrawLayer("OVERLAY", 1)
                frame.mog:Show();
            end

            frame.icon:SetTexture(frame.texture);

            if (not isUsable) then
                frame.icon:SetVertexColor(0.96078431372549, 0.50980392156863, 0.12549019607843, 1);
                local reason = "测试哟"; --MerchantApi:GetCannotBuyReason(index);
                frame.forbidden:SetText(reason);
            end
            frame.iconBorder:SetAtlas(GetQualityBorder(2)); --itemQuality
            frame:SetAlpha(1);
        end
    }
}
