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

    self:Update(GamePadInitorNames.MerchantBuyFrame.Name);

    MaskFrameModule:SetContent(self.scrollChildFrame);
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

function MerchantModule:RegisterMerchantItemGamepadButtonDown(gamePadInitor, buyback)
    gamePadInitor:Register("PADDDOWN,PADDUP,PADDLEFT,PADDRIGHT", function(currentItem, preItem)
        PlaySoundFile("Interface\\AddOns\\GamePadExt\\media\\sound\\1.mp3", "Master");
        MaskFrameModule:TopContent();
        MerchantItemGameTooltip:Hide();
        if (preItem) then
            preItem:SetFrameStrata("HIGH");
            if (preItem.dressUpFrame) then
                preItem.dressUpFrame:Destroy();
                preItem.dressUpFrame = nil;
            end
        end

        if (preItem and preItem.OnLeave) then
            preItem:OnLeave();
        end
        if (currentItem and currentItem.OnEnter) then
            currentItem:OnEnter();
        end
    end);

    --返回上一级菜单
    gamePadInitor:Register("PADSYSTEM", function(...)
        gamePadInitor:Switch(GamePadInitorNames.MerchantTabFrame.Name);
        MaskFrameModule:TopHead();
    end);

    --幻化
    gamePadInitor:Register("PAD4", function(currentItem)
        if (currentItem.dressUpFrame) then
            currentItem.dressUpFrame:Destroy();
            currentItem.dressUpFrame = nil;
        end
        local frame = self:CreateDressUpFrame(currentItem.itemLink);
        frame:Show();
        currentItem.dressUpFrame = frame;
    end)

    --当前商品查看详情
    gamePadInitor:Register("PAD2", function(currentItem)
        --背景设置最高和当前层级设置最高
        MaskFrameModule:SETDIALOG();
        currentItem:SetFrameStrata("DIALOG");
        self:ShowMerchantItemTooltip(currentItem);
    end)

    --购买物品
    gamePadInitor:Register("PAD1", function(currentItem)
        if (buyback) then
            BuybackItem(currentItem.index);
        else
            BuyMerchantItem(currentItem.index, 1);
        end
    end)

    --窗体滚动
    gamePadInitor:Register("PADDDOWN,PADDUP", function(currentItem, preItem)
        self:Scroll(currentItem);
    end);
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

function MerchantModule:RenderAndAnchorMerchantItem(gamePadInitor)
    --模仿三元表达式

    local numItems;
    if gamePadInitor.classname == GamePadInitorNames.MerchantBuyFrame.Name then
        numItems = GetMerchantNumItems()
    else
        numItems = GetNumBuybackItems()
    end
    local maxColum = 2; --b
    local middle = math.ceil(numItems / maxColum);
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
        merchantItem:SetParent(self.scrollChildFrame);
        merchantItem:SetPoint("TOPLEFT", self.scrollChildFrame, offsetX, offsetY);
        if (itemLink) then
            itemLink = string.gsub(itemLink, "%[", "", 1);
            itemLink = string.gsub(itemLink, "%]", "", 1);
        end
        gamePadInitor:Add(merchantItem, "group" .. col);
    end
end

--更新界面元素的位置
function MerchantModule:Update(mode)
    self.scrollFrame:SetVerticalScroll(0);
    self.scrollFrame:Show();
    self.scrollChildFrame:Show();


    --BUG:Destory会摧毁GamePad的监听
    --购买商品渲染
    if (mode == GamePadInitorNames.MerchantBuyFrame.Name) then
        local buy_gamePadInitor = self.buy_gamePadInitor;
        if (buy_gamePadInitor) then
            buy_gamePadInitor:Destroy();
        end
        buy_gamePadInitor = GamePadInitor:Init(GamePadInitorNames.MerchantBuyFrame.Name,
            GamePadInitorNames.MerchantBuyFrame.Level);

        self:RenderAndAnchorMerchantItem(buy_gamePadInitor);
        buy_gamePadInitor:SetRegion(self.scrollChildFrame);
        self:RegisterMerchantItemGamepadButtonDown(buy_gamePadInitor);
        self.buy_gamePadInitor = buy_gamePadInitor;
    end

    if (mode == GamePadInitorNames.MerchantBuyBackFrame.Name) then
        local buyback_gamePadInitor = self.buyback_gamePadInitor;
        if (buyback_gamePadInitor) then
            buyback_gamePadInitor:Destroy();
        end
        buyback_gamePadInitor = GamePadInitor:Init(GamePadInitorNames.MerchantBuyFrame.Name,
            GamePadInitorNames.MerchantBuyFrame.Level);

        self:RenderAndAnchorMerchantItem(buyback_gamePadInitor);
        buyback_gamePadInitor:SetRegion(self.scrollChildFrame);
        self:RegisterMerchantItemGamepadButtonDown(buyback_gamePadInitor, true);
        self.buyback_gamePadInitor = buyback_gamePadInitor;
    end
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
