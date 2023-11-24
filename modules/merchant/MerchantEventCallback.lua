local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local MerchantModule = Gpe:GetModule('MerchantModule');
local currentItems = {};
local MaskFrameModule = Gpe:GetModule('MaskFrameModule');




function MerchantModule:MERCHANT_SHOW()
    MerchantFrame:ShowFadeIn();
    MaskFrameModule:ShowAll();
    self:InitframeStrata();
    UIParent:Hide();
    self:InitScrollFrame();

    self:AppendHeadElements();

    local width = self.templateWidth;
    local height = self.templateHeight;

    local height_space = self.height_space;
    local widht_space = self.width_space;



    local callback = function(index, col, midle, itemLink, cost, texture, itemQuality, isMoney, isUsable, hasTransMog)
        local source = _G["MerchantItem" .. index];
        source:ClearAllPoints();
        local floor = math.floor(index % midle);
        local scroll_width = self.templateWidth * 2 * 1.5;
        local offsetX = (scroll_width - (2) * (width + widht_space)) / 2;
        source:SetPoint("TOPLEFT", (col) * (width + widht_space) + offsetX, -floor * (height + height_space));
        local frame = CreateFrame("Frame", nil, _G["MerchantItem" .. index], "MerchantItemTemplate1");
        frame:SetPoint("CENTER");
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
        frame:InitEnableGamePadButton("MerchantItem", "group" .. col, 2);
        MerchantModule:RegisterMerchantItemGamepadButtonDown(frame);
        table.insert(currentItems, frame);
    end

    MerchantApi:PreProccessItemsInfo(callback);
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
    MerchantFrame:SetParent(self.scrollChild);
    MerchantFrame:SetPoint("TOPLEFT", self.scrollChild);
    MerchantFrame:SetPoint("BOTTOMRIGHT", self.scrollChild);

    local count = GetMerchantNumItems();
    local middle = math.ceil(count / self.maxColum);
    local scroll_width = self.templateWidth * 2 * 1.5;
    local offsetX = (scroll_width - (2) * (self.templateWidth + self.width_space)) / 2;
    for index = 1, count do
        local source = _G["MerchantItem" .. index];
        if (source ~= nil) then
            source:ClearAllPoints();
            local col = math.floor(index / middle);
            local floor = math.floor(index % middle);

            source:SetPoint("TOPLEFT", col * (self.templateWidth + self.width_space) + offsetX,
                -floor * (self.templateHeight + self.height_space));
            source:Show();
        end
    end

    --其余的都给ClearPoint掉 TODO:kangze
end

--MerchantItem 默认层级 DIALOG
--BodyFrame 默认的层级是 BACKGROUND

function MerchantModule:AppendHeadElements()
    local width = 100;
    local width_space = 20;
    local height = MaskFrameModule.headFrame:GetHeight();

    local tab_buy = CreateFrame("Frame", nil, nil, "GpeButtonTemplate");
    tab_buy.text:SetText("购买");
    tab_buy:SetPoint("CENTER", MaskFrameModule.headFrame, -(width + width_space) / 2, 0);
    tab_buy:SetSize(width, height);
    tab_buy:ShowFadeIn();
    tab_buy:SetFrameStrata("FULLSCREEN");


    local tab_rebuy = CreateFrame("Frame", nil, nil, "GpeButtonTemplate");
    tab_rebuy.text:SetText("售出");
    tab_rebuy:SetPoint("CENTER", MaskFrameModule.headFrame, (width + width_space) / 2, 0);
    tab_rebuy:SetSize(width, height);
    tab_rebuy:ShowFadeIn();
    tab_rebuy:SetFrameStrata("FULLSCREEN");

    self.tab_buy = tab_buy;
    self.tab_rebuy = tab_rebuy;

    --加入手柄按键支持
    tab_buy:InitEnableGamePadButton("BuyItem", "group", 1);
    tab_rebuy:InitEnableGamePadButton("BuyItem", "group", 1);

    --注册按键事件
    self:RegisterBuyItem(tab_buy);
    self:RegisterBuyItem(tab_rebuy);
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
end

function MerchantModule:RegisterMerchantItemGamepadButtonDown(frame)
    local proccessor = frame.gamePadButtonDownProcessor;
    proccessor:Register("PADDDOWN,PADDUP,PADDLEFT,PADDRIGHT", function(currentItem, preItem)
        PlaySoundFile("Interface\\AddOns\\GamePadExt\\media\\sound\\1.mp3", "Master");
        MaskFrameModule:SetBackground();
        MerchantItemGameTooltip:Hide();
        currentItem.buyFrame:ShowFadeIn();
        currentItem.detailFrame:ShowFadeIn();
        MaskFrameModule:SetBackground();
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
        -- MerchantFrame:Hide();
        -- MerchantItemGameTooltip:Hide();
        proccessor:Switch("BuyItem");
        --self:Switch("BuyItem");
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

    proccessor:Register("PAD2", function(currentItem)
        --背景设置最高和当前层级设置最高
        MaskFrameModule:SETDIALOG();
        currentItem:SetParent(nil);
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

    -- proccessor:Register("PADLTRIGGER,PADRTRIGGER", function()
    --     print("我切换了");
    -- end)
end

function MerchantModule:InitframeStrata()
    MaskFrameModule:SetBackground();
end

function MerchantModule:InitScrollFrame()
    local count = GetMerchantNumItems();
    local col = self.maxColum;

    local scale = UIParent:GetEffectiveScale();
    local height = GetScreenHeight() * scale - 30;
    local scrollFrame = CreateFrame("ScrollFrame", nil, nil)
    scrollFrame:SetSize(self.templateWidth * col * 1.5, height)
    scrollFrame:SetPoint("TOP", MaskFrameModule.headFrame, "BOTTOM", 0, 0);
    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollFrame:SetScrollChild(scrollChild)


    scrollChild:SetSize(self.templateWidth * col * 1.5, (self.templateHeight * count) / 2);
    self.scrollChild = scrollChild;
    self.scrollFrame = scrollFrame;


    MerchantFrame:ClearAllPoints();
    MerchantFrame:SetParent(self.scrollChild);
    MerchantFrame:SetPoint("TOPLEFT", self.scrollChild);
    MerchantFrame:SetPoint("BOTTOMRIGHT", self.scrollChild);
end
