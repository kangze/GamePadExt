local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local MerchantModule = Gpe:GetModule('MerchantModule');
local currentItems = {};
local currentBuyBackItems = {};
local MaskFrameModule = Gpe:GetModule('MaskFrameModule');
local mode = "buy";

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

function MerchantModule:MERCHANT_SHOW()
    MaskFrameModule:ShowAll();
    UIParent:Hide();

    MaskFrameModule:Active("merchantTab");

    local scrollFrame, scrollChildFrame = MerchantItemContainer:New(self.maxColum, self.templateWidth,
        self.templateHeight, MaskFrameModule.headFrame);
    self.scrollFrame = scrollFrame;
    self.scrollChildFrame = scrollChildFrame;

    --MerchantModule:RegisterBuyItem(tabsFrame);

    MerchantFrame:ClearAllPoints();
    MerchantFrame:SetParent(scrollChildFrame);
    MerchantFrame:SetPoint("TOPLEFT", scrollChildFrame);
    MerchantFrame:SetPoint("BOTTOMRIGHT", scrollChildFrame);

    local loseFocusCallback = function()
        MerchantItemContainer:ScollFrameLoseFocus();
        MerchantItemContainer:TabsFrameGetFocus();
    end

    --购买商品渲染
    --GamePadFrameInitor:Init("MerchantItem", "group" .. col, 1,frame);

    local gamePadInitor = GamePadInitor:Init("MerchantItem", 1);
    local callback_buy = function(index, col, midle, itemLink, cost, texture, itemQuality, isMoney, isUsable, hasTransMog)
        local source = _G["MerchantItem" .. index];
        source:ClearAllPoints();
        local offsetX, offsetY = self:GetColInfo(index, col, midle);
        source:SetPoint("TOPLEFT", offsetX, offsetY);
        source:Show();

        local frame = MerchantModule:Render(index, col, midle, itemLink, cost, texture, itemQuality, isMoney, isUsable,
            hasTransMog);
        frame:SetPoint("CENTER", _G["MerchantItem" .. index]);
        if (itemLink) then
            itemLink = string.gsub(itemLink, "%[", "", 1);
            itemLink = string.gsub(itemLink, "%]", "", 1);
        end
        --gamepadproccessor = GamePadFrameInitor:Init("MerchantItem", "group" .. col, 1,frame);
        gamePadInitor:Add(frame, "group" .. col);
        table.insert(currentItems, frame);
    end
    gamePadInitor:SetRegion(scrollChildFrame);
    MerchantModule:RegisterMerchantItemGamepadButtonDown(gamePadInitor);

    MerchantApi:PreProccessItemsInfo(callback_buy);

    --购回商品渲染
    local gamePadInitor_buyback = GamePadInitor:Init("MerchantItemBuyBack", 2);
    local callback_buy = function(index, col, midle, itemLink, cost, texture, itemQuality, isMoney, isUsable, hasTransMog)
        local source = _G["MerchantItem" .. index];
        source:ClearAllPoints();
        local offsetX, offsetY = self:GetColInfo(index, col, midle);
        source:SetPoint("TOPLEFT", offsetX, offsetY);

        local frame = MerchantModule:Render(index, col, midle, itemLink, cost, texture, itemQuality, isMoney, isUsable,
            hasTransMog);
        frame:SetPoint("CENTER", _G["MerchantItem" .. index]);
        if (itemLink) then
            itemLink = string.gsub(itemLink, "%[", "", 1);
            itemLink = string.gsub(itemLink, "%]", "", 1);
        end
        gamePadInitor_buyback:Add(frame, "group" .. col);
        table.insert(currentBuyBackItems, frame);
    end

    gamePadInitor_buyback:SetRegion(scrollChildFrame);
    MerchantModule:RegisterMerchantItemGamepadButtonDown(gamePadInitor_buyback, true);

    MerchantApi:ProcessMerchantBuyBackInfo(callback_buy);

    --模拟点击第一个tab
    --tabsFrame.gamePadButtonDownProcessor:Handle("PAD1");
end

function MerchantModule:RegisterMerchantItemGamepadButtonDown(gamePadInitor, buyback)
    gamePadInitor:Register("PADDDOWN,PADDUP,PADDLEFT,PADDRIGHT", function(currentItem, preItem)
        PlaySoundFile("Interface\\AddOns\\GamePadExt\\media\\sound\\1.mp3", "Master");
        MaskFrameModule:SetBackground();
        MerchantItemGameTooltip:Hide();
        print(gamePadInitor.classname);
        _G["test"] = currentItem;
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
        local itemLink = currentItem.itemLink;

        MerchantItemGameTooltip:SetHyperlink(itemLink);
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

function MerchantModule:MERCHANT_CLOSED()
    MaskFrameModule:HideBody();
    UIParent:Show();

    --关闭所有的商品Item
    for i = 1, #currentItems do
        currentItems[i]:Destroy();
    end
    currentItems = {};
    --通知MaskFrameModule关闭一些实例
    MaskFrameModule:Destroy("merchantTab");
end

function MerchantModule:UpdateMerchantPositions()
    self:HiddeMerchantSomeFrame();
    MerchantFrame:ClearAllPoints();
    MerchantFrame:SetParent(nil);
    MerchantFrame:SetPoint("TOP", MaskFrameModule:GetHeaderFrame());

    MerchantFrame:ClearAllPoints();
    MerchantFrame:SetParent(self.scrollChildFrame);
    MerchantFrame:SetPoint("TOPLEFT", self.scrollChildFrame);
    MerchantFrame:SetPoint("BOTTOMRIGHT", self.scrollChildFrame);

    local count = nil;
    if (mode == "buy") then
        count = GetMerchantNumItems();
    else
        count = GetNumBuybackItems();
    end
    local middle = math.ceil(count / self.maxColum);

    for index = 1, count do
        local source = _G["MerchantItem" .. index];
        if (source ~= nil) then
            source:ClearAllPoints();
            local col = math.ceil(index / middle);
            local offsetX, offsetY = self:GetColInfo(index, col, middle);
            source:SetPoint("TOPLEFT", offsetX, offsetY);
            source:Show();
        end
    end

    --其余的都给ClearPoint掉 TODO:kangze
end

function MerchantModule:InitframeStrata()
    MaskFrameModule:SetBackground();
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
    return frame;
end
