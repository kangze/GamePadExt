local config = {
    maxColum = 2,
    templateWidth = 210,
    templateHeight = 45,
    height_space = 10,
    width_space = 40,
}

--计算列
function GetColInfo(index, col, middle)
    local width = config.templateWidth;
    local height = config.templateHeight;

    local height_space = config.height_space;
    local widht_space = config.width_space;

    local cols = config.maxColum;

    --属于这一列的第几个
    local col_index = math.ceil((index - 1) % middle);

    --主要是为了保证居中
    local scroll_width = config.templateWidth * cols * 1.5;
    local initial_offsetX = (scroll_width - cols * (width + widht_space));

    --元素的x,y偏移
    local offsetX = (col - 1) * (width + widht_space) + initial_offsetX;
    local offsetY = -col_index * (height + height_space)
    return offsetX, offsetY;
end

--渲染单个项目
function MerchantItem_Create(index, itemLink, cost, texture, itemQuality, isMoney, isUsable, hasTransMog)
    local frame = CreateFrame("Frame", nil, nil, "MerchantItemTemplate1");
    if (itemLink) then
        itemLink = string.gsub(itemLink, "%[", "", 1);
        itemLink = string.gsub(itemLink, "%]", "", 1);
    end
    frame.productName:SetText(itemLink);
    frame.itemLink = itemLink;
    if (isMoney) then
        frame.costmoney:ApplyMoney(cost)
    else
        frame.costmoney:SetText(cost);
    end
    if (not hasTransMog) then
        frame.mog:SetDrawLayer("OVERLAY", 1)
        frame.mog:Show();
    end
    frame.icon:SetTexture(texture);
    if (not isUsable) then
        frame.icon:SetVertexColor(0.96078431372549, 0.50980392156863, 0.12549019607843, 1);
        local reason = MerchantApi:GetCannotBuyReason(index);
        frame.forbidden:SetText(reason);
    end
    frame.iconBorder:SetAtlas(GetQualityBorder(itemQuality));
    frame:SetAlpha(1);
    return frame;
end

--布局所有的item项目
function MerchantItem_Render(itemInfos, parentFrame, scrollFrame, isbuy)
    local numItems = #itemInfos;
    local items = {};
    local middle = math.ceil(numItems / config.maxColum);
    for index = 1, numItems do
        local col = math.ceil(index / middle);
        local itemLink, cost, texture, itemQuality, isMoney, isUsable = unpack(itemInfos[index]);
        test1=itemInfos[index];
        local merchantItem = MerchantItem_Create(index, itemLink, cost, texture, itemQuality, isMoney, isUsable, true);
        merchantItem:ClearAllPoints();
        local offsetX, offsetY = GetColInfo(index, col, middle);
        merchantItem:SetParent(parentFrame);
        merchantItem:SetPoint("TOPLEFT", parentFrame, offsetX, offsetY);
        merchantItem.scrollFrame = scrollFrame;
        merchantItem.col = col;
        merchantItem.isbuy = isbuy;
        table.insert(items, merchantItem);
    end
    return items;
end
