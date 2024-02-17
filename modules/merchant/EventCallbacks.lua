local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local MerchantModule = Gpe:GetModule('MerchantModule');
local MaskFrameModule = Gpe:GetModule('MaskFrameModule');


function MerchantModule:MERCHANT_SHOW()
    --全局UI进行隐藏
    --UIParent:Hide();

    --顶部菜单开始激活
    MaskFrameModule:Active("MerchantTabFrameHeader");

    self:ResetScrollFrame();

    --初始化买入和卖出2个GamePadInitor
    self:InitGamePadInitors();

    MaskFrameModule:SetContent(self.buy_scrollChildFrame);
    --模拟点击第一个tab
    --self.buy_gamePadInitor:Handle("PAD1");
end

function MerchantModule:MERCHANT_CLOSED()
    UIParent:Show();
    --通知MaskFrameModule关闭一些实例
    MaskFrameModule:Destroy("merchantTab");
    --取消gamepad监听以及对应窗体的销毁
    self.buy_gamePadInitor:Destroy();
end

function MerchantModule:ResetScrollFrame()
    self.buy_scrollFrame:SetVerticalScroll(0);
    self.buy_scrollFrame:Show();
    self.buy_scrollChildFrame:Show();

    self.buyback_scrollFrame:SetVerticalScroll(0);
    self.buyback_scrollFrame:Show();
    self.buyback_scrollChildFrame:Show();
end

function MerchantModule:InitGamePadInitors()
    --买入GamePadInitor
    buy_gamePadInitor = GamePadInitor:Init(GamePadInitorNames.MerchantBuyFrame.Name,
        GamePadInitorNames.MerchantBuyFrame.Level);

    self:RenderAndAnchorMerchantItem(buy_gamePadInitor, self.buy_scrollChildFrame, self.buy_scrollFrame);
    buy_gamePadInitor:SetRegion(self.buy_scrollChildFrame);
    self:RegisterMerchantItemGamepadButtonDown(buy_gamePadInitor);
    self.buy_gamePadInitor = buy_gamePadInitor;

    --卖出GamePadInitor
    buyback_gamePadInitor = GamePadInitor:Init(GamePadInitorNames.MerchantBuyBackFrame.Name,
        GamePadInitorNames.MerchantBuyBackFrame.Level);

    self:RenderAndAnchorMerchantItem(buyback_gamePadInitor,self.buyback_scrollChildFrame,self.buyback_scrollFrame);
    buyback_gamePadInitor:SetRegion(self.buyback_scrollChildFrame);
    self:RegisterMerchantItemGamepadButtonDown(buyback_gamePadInitor, true);
    self.buyback_gamePadInitor = buyback_gamePadInitor;
end

function MerchantModule:RenderAndAnchorMerchantItem(gamePadInitor, parentFrame, scrollFrame)
    local numItems;
    if gamePadInitor.classname == GamePadInitorNames.MerchantBuyFrame.Name then
        numItems = GetMerchantNumItems()
    else
        numItems = GetNumBuybackItems()
    end
    local middle = math.ceil(numItems / self.maxColum);
    for index = 1, numItems do
        local col = math.ceil(index / middle);
        local itemLink, cost, texture, itemQuality, isMoney, isUsable;
        if gamePadInitor.classname == GamePadInitorNames.MerchantBuyFrame.Name then
            itemLink, cost, texture, itemQuality, isMoney, isUsable = MerchantApiHelper:GetMerchantBuyItemInfo(index)
        else
            itemLink, cost, texture, itemQuality, isMoney, isUsable = MerchantApiHelper:GetBuybackItemInfo(index)
        end
        local merchantItem = self:CreateMerchantItem(index, itemLink, cost, texture, itemQuality, isMoney, isUsable, true);
        merchantItem:ClearAllPoints();
        local offsetX, offsetY = self:GetColInfo(index, col, middle);
        merchantItem:SetParent(parentFrame);
        merchantItem:SetPoint("TOPLEFT", parentFrame, offsetX, offsetY);
        merchantItem.scrollFrame = scrollFrame;
        if (itemLink) then
            itemLink = string.gsub(itemLink, "%[", "", 1);
            itemLink = string.gsub(itemLink, "%]", "", 1);
        end
        gamePadInitor:Add(merchantItem, "group" .. col);
    end
end

function MerchantModule:CreateMerchantItem(index, itemLink, cost, texture, itemQuality, isMoney, isUsable, hasTransMog)
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

--获取当前列的索引
function MerchantModule:GetColInfo(index, col, middle)
    local width = self.templateWidth;
    local height = self.templateHeight;

    local height_space = self.height_space;
    local widht_space = self.width_space;

    local cols = self.maxColum;


    --属于这一列的第几个
    local col_index = math.ceil((index - 1) % middle);

    --主要是为了保证居中
    local scroll_width = self.templateWidth * cols * 1.5;
    local initial_offsetX = (scroll_width - cols * (width + widht_space));

    --元素的x,y偏移
    local offsetX = (col - 1) * (width + widht_space) + initial_offsetX;
    local offsetY = -col_index * (height + height_space)
    return offsetX, offsetY;
end
