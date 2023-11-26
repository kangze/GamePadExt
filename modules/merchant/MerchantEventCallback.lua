local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local MerchantModule = Gpe:GetModule('MerchantModule');
local currentItems = {};
local MaskFrameModule = Gpe:GetModule('MaskFrameModule');


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
    MerchantFrame:ShowFadeIn();
    MaskFrameModule:ShowAll();
    self:InitframeStrata();
    UIParent:Hide();

    local scrollFrame, scrollChildFrame,tabsFrame = MerchantItemContainer:New(self.maxColum, self.templateWidth,
        self.templateHeight, MaskFrameModule.headFrame);
    self.scrollFrame = scrollFrame;
    self.scrollChildFrame = scrollChildFrame;

    MerchantModule:RegisterBuyItem(tabsFrame);

    MerchantFrame:ClearAllPoints();
    MerchantFrame:SetParent(scrollChildFrame);
    MerchantFrame:SetPoint("TOPLEFT", scrollChildFrame);
    MerchantFrame:SetPoint("BOTTOMRIGHT", scrollChildFrame);

    local loseFocusCallback = function()
        MerchantItemContainer:ScollFrameLoseFocus();
        MerchantItemContainer:TabsFrameGetFocus();
    end
    local callback = function(index, col, midle, itemLink, cost, texture, itemQuality, isMoney, isUsable, hasTransMog)
        local source = _G["MerchantItem" .. index];
        source:ClearAllPoints();
        local offsetX, offsetY = self:GetColInfo(index, col, midle);
        source:SetPoint("TOPLEFT", offsetX, offsetY);
        local frame = CreateFrame("Frame", nil, nil, "MerchantItemTemplate1");
        frame:SetPoint("CENTER", _G["MerchantItem" .. index]);
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
        frame:InitEnableGamePadButton("MerchantItem", "group" .. col, 2, loseFocusCallback);
        if (index == 1) then --避免多次注册
            MerchantModule:RegisterMerchantItemGamepadButtonDown(frame);
        end
        table.insert(currentItems, frame);
    end

    MerchantApi:PreProccessItemsInfo(callback);
end

function MerchantModule:RegisterBuyItem(frame)
    local proccessor = frame.gamePadButtonDownProcessor;
    proccessor:Register("PADRTRIGGER,PADLTRIGGER", function(currentItem, preItem)
        if (preItem and preItem.OnLeave) then
            preItem:OnLeave();
        end
        if (currentItem and currentItem.OnEnter) then
            currentItem:OnEnter();
        end
    end);

    proccessor:Register("PAD1", function(currentItem, preItem)
        proccessor:Switch("MerchantItem");
    end);
end

function MerchantModule:RegisterMerchantItemGamepadButtonDown(frame)
    local proccessor = frame.gamePadButtonDownProcessor;
    proccessor:Register("PADDDOWN,PADDUP,PADDLEFT,PADDRIGHT", function(currentItem, preItem)
        PlaySoundFile("Interface\\AddOns\\GamePadExt\\media\\sound\\1.mp3", "Master");
        MaskFrameModule:SetBackground();
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
    proccessor:Register("PADSYSTEM", function(...)
        proccessor:Switch("BuyItem");
    end);

    --幻化
    proccessor:Register("PAD4", function(currentItem)
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
    proccessor:Register("PAD2", function(currentItem)
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
    proccessor:Register("PAD1", function(currentItem)
        BuyMerchantItem(currentItem.index, 1);
    end)

    --窗体滚动
    proccessor:Register("PADDDOWN,PADDUP", function(currentItem, preItem)
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
    for i = 1, #currentItems do
        currentItems[i]:Destory();
    end
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

    local count = GetMerchantNumItems();
    local middle = math.ceil(count / self.maxColum);
    local scroll_width = self.templateWidth * 2 * 1.5;
    local offsetX = (scroll_width - (2) * (self.templateWidth + self.width_space)) / 2;
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
