--物品容器框体
MerchantItemContainer = {};


function MerchantItemContainer:New(maxColum, templateWidht, templateHeigt,headFrame)
    local count = GetMerchantNumItems();

    local scale = UIParent:GetEffectiveScale();
    local height = GetScreenHeight() * scale - 30;

    local scrollFrame = CreateFrame("ScrollFrame", nil, nil)
    scrollFrame:SetSize(templateWidht * maxColum * 1.5, height)
    scrollFrame:SetPoint("TOP", headFrame, "BOTTOM", 0, 0);
    
    local scrollChildFrame = CreateFrame("Frame", nil, scrollFrame)
    scrollFrame:SetScrollChild(scrollChildFrame)
    scrollChildFrame:SetSize(templateWidht * maxColum * 1.5, (templateHeigt * count) / 2);

    --self.scrollChildFrame = scrollChildFrame;
    --self.scrollFrame = scrollFrame;

    -- MerchantFrame:ClearAllPoints();
    -- MerchantFrame:SetParent(scrollChildFrame);
    -- MerchantFrame:SetPoint("TOPLEFT", scrollChildFrame);
    -- MerchantFrame:SetPoint("BOTTOMRIGHT", scrollChildFrame);

    return scrollFrame, scrollChildFrame;
end
