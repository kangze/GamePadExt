local function RegisterBuyItem(gamePadInitor)
    gamePadInitor:Register("PADRTRIGGER,PADLTRIGGER", function(currentItem, preItem)
        if (preItem and preItem.OnLeave) then
            preItem:OnLeave();
        end
        if (currentItem and currentItem.OnEnter) then
            currentItem:OnEnter();
        end
    end);

    --tab选项选择
    gamePadInitor:Register("PAD1", function(currentItem, preItem)
        gamePadInitor:SelectTab(currentItem.tabName);
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
    gamePadInitor:Add(frame.buy, "group", "buy");
    gamePadInitor:Add(frame.rebuy, "group", "buyback");
    gamePadInitor:SetRegion(frame);
    RegisterBuyItem(gamePadInitor);
    return frame;
end

HeaderRegions:Register("merchantTab", callback);
