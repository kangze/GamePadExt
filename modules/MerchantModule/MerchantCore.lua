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
    local offsetY = -col_index * (height + height_space) - 10;
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

--初始化滚动窗体的布局
function MerchantScorll_Create()
    local scale = UIParent:GetEffectiveScale();
    local height = GetScreenHeight() * scale - 30;

    local scrollFrame = CreateFrame("ScrollFrame", nil, nil)
    scrollFrame:SetSize(config.templateWidth * config.maxColum * 1.5, height)

    --ScrollFade,0,0表示需要Play特定赋值
    scrollFrame.animation_scroll = Animation:new(0.3, 0, 0, function(current)
        scrollFrame:SetVerticalScroll(current);
    end, nil, EasingFunctions.OutSine);

    local enter_animation = Animation:new(0.8, 0, 1, function(current)
        scrollFrame:SetAlpha(current);
    end, nil, EasingFunctions.OutSine);
    local enter_callback = function(frame)
        frame:SetAlpha(0);
        frame:Show();
        enter_animation:Play();
    end
    local leave_callback = function(frame)
        frame:Hide();
    end

    local scrollChildFrame = CreateFrame("Frame", nil, scrollFrame);
    scrollFrame.OnEnter = enter_callback;
    scrollFrame.OnLeave = leave_callback;
    scrollFrame:SetScrollChild(scrollChildFrame)
    scrollChildFrame:SetSize(config.templateWidth * config.maxColum * 1.5, height);

    scrollFrame:SetPoint("TOP", UIParent, 0, -40);
    return scrollFrame, scrollChildFrame;
end

--初始化幻化框体的布局
function MerchantDressUpFrame_Create(bodyFrame)
    local frame = CreateFrame("Frame", nil, nil, "DressupFrameTemplate");
    frame:ClearAllPoints();
    frame:SetPoint("RIGHT", bodyFrame, 0, 0);
    local scale = UIParent:GetEffectiveScale();
    frame:SetWidth(300);
    frame:SetHeight(GetScreenHeight() * scale - 100);
    frame:SetFrameStrata("DIALOG");
    frame:Hide();
    return frame;
end

function MerchantTabActiveCallBack(headFrame)
    local frame = CreateFrame("Frame", nil, nil, "MerchantTabsFrameTemplate");
    frame.buy:SetHeight(headFrame:GetHeight() - 2);
    frame.rebuy:SetHeight(headFrame:GetHeight() - 2);

    local gamePadInitor = GamePadInitor:Init(GamePadInitorNames.MerchantTabFrame.Name,
        GamePadInitorNames.MerchantTabFrame.Level);
    gamePadInitor:Add(frame.buy, "group", GamePadInitorNames.MerchantBuyFrame.Name);
    gamePadInitor:Add(frame.rebuy, "group", GamePadInitorNames.MerchantBuyBackFrame.Name);
    gamePadInitor:SetRegion(frame);
    RegisterMerchantTabGamepadButtonDown(gamePadInitor);
    return frame;
end
