local function RegisterBuyItem(gamePadInitor)
    gamePadInitor:Register("PADRTRIGGER,PADLTRIGGER", function(currentItem, preItem)
        if (preItem and preItem.OnLeave) then
            print("leave");
            preItem:OnLeave();
        end
        if (currentItem and currentItem.OnEnter) then
            print("enter");
            currentItem:OnEnter();
        end
    end);

    --tab选项选择
    gamePadInitor:Register("PAD1", function(currentItem, preItem)
        if (currentItem.tag == "buy") then
            mode = "buy";
            gamePadInitor:Switch("MerchantItem");
            -- MerchantModule:UpdateMerchantPositions();
            -- MerchantModule.scrollFrame:SetVerticalScroll(0);
        end
        if (currentItem.tag == "buyback") then
            mode = "buyback";
            gamePadInitor:Switch("MerchantItemBuyBack");
            -- MerchantModule:UpdateMerchantPositions();
            -- MerchantModule.scrollFrame:SetVerticalScroll(0);
        end
    end);

    --注册这个框架关闭
    gamePadInitor:Register("PADSYSTEM", function(currentItem, prrItem)
        MerchantModule:MERCHANT_CLOSED();
    end);
end

local function callback(headFrame)
    local frame = CreateFrame("Frame", nil, nil, "MerchantTabsFrameTemplate");
    frame.buy:SetHeight(headFrame:GetHeight() - 2);
    frame.rebuy:SetHeight(headFrame:GetHeight() - 2);
    local gamePadInitor = GamePadInitor:Init("TabFrame", 10);
    gamePadInitor:Add(frame.buy, "group");
    gamePadInitor:Add(frame.rebuy, "group");
    gamePadInitor:SetRegion(frame);
    RegisterBuyItem(gamePadInitor);
    return frame;
end

HeaderRegions:Register("merchantTab", callback);
