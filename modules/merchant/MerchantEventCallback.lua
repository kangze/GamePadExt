local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local MerchantModule = Gpe:GetModule('MerchantModule');
local MaskFrameModule = Gpe:GetModule('MaskFrameModule');

function MerchantModule:MERCHANT_SHOW()
    --第一次展示购买界面
    self.mode = "buy";
    self.frame_buy:Show();
    self.frame_buyback:Hide();

    --顶部渐入显示
    MaskFrameModule:ShowFadeIn();

    --全局UI进行隐藏
    --UIParent:Hide();

    --顶部菜单开始激活
    MaskFrameModule:Active("merchantTab");

    --购买商品渲染
    local gamePadInitor = GamePadInitor:Init("MerchantItem", 1);
    self.gamePadInitor = gamePadInitor;
    function callback_buy(index, col, midle, itemLink, cost, texture, itemQuality, isMoney, isUsable, hasTransMog)
        local frame = MerchantModule:Render(index, col, midle, itemLink, cost, texture, itemQuality, isMoney, isUsable,
            hasTransMog);
        frame:ClearAllPoints();
        local offsetX, offsetY = self:GetColInfo(index, col, midle);
        frame:SetParent(self.frame_buy);
        frame:SetPoint("TOPLEFT", self.frame_buy, offsetX, offsetY);
        if (itemLink) then
            itemLink = string.gsub(itemLink, "%[", "", 1);
            itemLink = string.gsub(itemLink, "%]", "", 1);
        end
        gamePadInitor:Add(frame, "group" .. col);
    end

    MerchantApi:PreProccessItemsInfo(callback_buy);
    gamePadInitor:SetRegion(self.frame_buy, "buy");
    MerchantModule:RegisterMerchantItemGamepadButtonDown(gamePadInitor);

    --购回商品渲染
    local gamePadInitor_buyback = GamePadInitor:Init("MerchantItemBuyBack", 2);
    self.gamePadInitor_buyback = gamePadInitor_buyback;
    function callback_buyback(index, col, midle, itemLink, cost, texture, itemQuality, isMoney, isUsable, hasTransMog)
        local frame = MerchantModule:Render(index, col, midle, itemLink, cost, texture, itemQuality, isMoney, isUsable,
            hasTransMog);
        local offsetX, offsetY = self:GetColInfo(index, col, midle);
        frame:ClearAllPoints();
        frame:SetParent(self.frame_buyback);
        frame:SetPoint("TOPLEFT", self.frame_buyback, offsetX, offsetY);
        if (itemLink) then
            itemLink = string.gsub(itemLink, "%[", "", 1);
            itemLink = string.gsub(itemLink, "%]", "", 1);
        end
        gamePadInitor_buyback:Add(frame, "group" .. col);
    end

    gamePadInitor_buyback:SetRegion(self.frame_buyback, "buyback");
    MerchantModule:RegisterMerchantItemGamepadButtonDown(gamePadInitor_buyback, true);
    MerchantApi:ProcessMerchantBuyBackInfo(callback_buyback);

    MaskFrameModule:SetContent(self.scrollChildFrame);

    --模拟点击第一个tab
    --gamePadInitor:Handle("PAD1");
end

function MerchantModule:MERCHANT_CLOSED()
    UIParent:Show();
    --通知MaskFrameModule关闭一些实例
    MaskFrameModule:Destroy("merchantTab");
    --取消gamepad监听以及对应窗体的销毁
    self.gamePadInitor:Destroy();
    self.gamePadInitor_buyback:Destroy();
end

function MerchantModule:RegisterMerchantItemGamepadButtonDown(gamePadInitor, buyback)
    gamePadInitor:Register("PADDDOWN,PADDUP,PADDLEFT,PADDRIGHT", function(currentItem, preItem)
        PlaySoundFile("Interface\\AddOns\\GamePadExt\\media\\sound\\1.mp3", "Master");
        MaskFrameModule:TopContent();
        MerchantItemGameTooltip:Hide();
        currentItem.buyFrame:ShowFadeIn();
        currentItem.detailFrame:ShowFadeIn();
        if (preItem) then
            preItem.buyFrame:ShowFadeOut();
            preItem.detailFrame:ShowFadeOut();
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
        gamePadInitor:Switch("TabFrame");
        MaskFrameModule:TopHead();
    end);

    --幻化
    gamePadInitor:Register("PAD4", function(currentItem)
        if (currentItem.dressUpFrame) then
            currentItem.dressUpFrame:Destroy();
            currentItem.dressUpFrame = nil;
        end
        local frame = CreateFrame("Frame", nil, nil, "DressupFrameTemplate");
        local bodyFrame = MaskFrameModule.bodyFrame;
        local end_callback = function()
            frame:SetPlayer();
            frame.model:InitShowFadeInAndOut(1.2);
            frame.model:ShowFadeIn();
            frame:TryOn(currentItem.itemLink);
        end
        frame:InitOffsetXAnimation(bodyFrame, 300, 0, 0.3, end_callback);
        frame:InitShowFadeInAndOut();
        frame:ClearAllPoints();
        frame:SetPoint("RIGHT", bodyFrame, 300, 0);
        local scale = UIParent:GetEffectiveScale();
        frame:SetWidth(300);
        frame:SetHeight(GetScreenHeight() * scale - 100);
        frame:SetFrameStrata("DIALOG");
        frame:Show();
        frame:ShowOffsetXAnimation();
        frame:ShowFadeIn();
        currentItem.dressUpFrame = frame;
    end)

    --当前商品查看详情
    gamePadInitor:Register("PAD2", function(currentItem)
        --背景设置最高和当前层级设置最高
        MaskFrameModule:SETDIALOG();
        currentItem:SetFrameStrata("DIALOG");
        MerchantItemGameTooltip:ClearAllPoints();
        MerchantItemGameTooltip:SetOwner(currentItem, "ANCHOR_NONE", 0);
        MerchantItemGameTooltip:SetPoint("LEFT", currentItem, "RIGHT", 0, 0);
        MerchantItemGameTooltip:SetHyperlink(currentItem.itemLink);
        MerchantItemGameTooltip:Show();
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
        local total_height = MerchantModule.scrollFrame:GetHeight();
        local item_height = currentItem:GetHeight();
        local current_index = currentItem.currentIndex;
        local ratio = 3;
        local current_position = MerchantModule.scrollFrame:GetVerticalScroll();

        --判断是否需要滚动
        if (current_index == 0) then
            MerchantModule.scrollFrame:SetVerticalScrollFade(current_position, 0);
            return;
        end

        if (item_height * current_index > total_height / ratio) then
            MerchantModule.scrollFrame:SetVerticalScrollFade(current_position,
                item_height * current_index - total_height / ratio);
            return;
        end
        if (item_height * current_index > total_height / ratio) then
            MerchantModule.scrollFrame:SetVerticalScrollFade(current_position,
                item_height * current_index - total_height / ratio);
            return;
        end
    end);
end

function MerchantModule:Render(index, col, midle, itemLink, cost, texture, itemQuality, isMoney, isUsable, hasTransMog)
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

--更新界面元素的位置
function MerchantModule:Update()
    MerchantModule.scrollFrame:SetVerticalScroll(0);
    
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
