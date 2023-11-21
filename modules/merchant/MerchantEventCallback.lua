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
    local count = GetMerchantNumItems();
    local templeteWidth = 210;
    local pages = math.ceil(count / 10);
    MerchantFrame:SetSize(templeteWidth * pages + 100, UIParent:GetHeight());


    local callback = function(index, page, itemLink, cost, texture, itemQuality, isMoney, isUsable, hasTransMog)
        local source = _G["MerchantItem" .. index];
        source:ClearAllPoints();
        local offsetY = -1 * index + 10 * (page - 1);
        source:SetPoint("TOPLEFT", 230 * (page - 1), (offsetY) * 55);
        local frame = CreateFrame("Frame", nil, _G["MerchantItem" .. index], "MerchantItemTemplate1");
        frame:SetPoint("CENTER");
        MerchantModule:RegisterMerchantItemGamepadButtonDown(frame);
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
        frame:Group("group" .. page);
        table.insert(currentItems, frame);
    end

    MerchantApi:PreProccessItemsInfo(callback);
end

function MerchantModule:MERCHANT_CLOSED()
    MaskFrameModule:HideBody();
    UIParent:Show();
    for i = 1, #currentItems do
        currentItems[i]:EnableGamePadButton(false);
        currentItems[i]:UnregisterAllEvents();
        currentItems[i]:Hide();
        MerchatItemGroups = {};
    end
end

function MerchantModule:UpdateMerchantPositions()
    self:HiddeMerchantSomeFrame();
    MerchantFrame:ClearAllPoints();
    MerchantFrame:SetParent(nil);
    MerchantFrame:SetPoint("TOP", MaskFrameModule:GetHeaderFrame());

    local count = GetMerchantNumItems();
    for i = 1, count do
        local page = math.ceil(i / 10)
        local source = _G["MerchantItem" .. i];
        if (source ~= nil) then
            local offsetY = -1 * i + 10 * (page - 1);
            source:ClearAllPoints();
            source:SetPoint("TOPLEFT", 230 * (page - 1), offsetY * 55)
            source:Show();
        end
    end

    --其余的都给ClearPoint掉 TODO:kangze
end

function MerchantModule:HiddeMerchantSomeFrame()
    if MerchantBuyBackItem then
        MerchantBuyBackItem:Hide()
    end

    if MerchantExtraCurrencyBg then
        MerchantExtraCurrencyBg:Hide()
    end

    if MerchantExtraCurrencyInset then
        MerchantExtraCurrencyInset:Hide()
    end

    if MerchantNextPageButton then
        MerchantNextPageButton:Hide()
    end

    if MerchantPrevPageButton then
        MerchantPrevPageButton:Hide()
    end

    if MerchantFrameBottomLeftBorder then
        MerchantFrameBottomLeftBorder:Hide()
    end

    if MerchantFrame.TitleContainer then
        MerchantFrame.TitleContainer:Hide()
    end

    if MerchantFrame.TopTileStreaks then
        MerchantFrame.TopTileStreaks:Hide()
    end

    if MerchantFrameTab1 then
        MerchantFrameTab1:Hide()
    end

    if MerchantFrameTab2 then
        MerchantFrameTab2:Hide()
    end

    if MerchantFrame.PortraitContainer then
        MerchantFrame.PortraitContainer:Hide()
    end

    if MerchantFrameLootFilter then
        MerchantFrameLootFilter:Hide()
    end

    if MerchantSellAllJunkButton then
        MerchantSellAllJunkButton:Hide()
    end

    if MerchantMoneyBg then
        MerchantMoneyBg:Hide()
    end

    if MerchantMoneyInset then
        MerchantMoneyInset:Hide()
    end

    if MerchantMoneyFrame then
        MerchantMoneyFrame:Hide()
    end

    if MerchantToken1 then
        MerchantToken1:Hide()
    end

    if MerchantPageText then
        MerchantPageText:Hide()
    end

    if MerchantFrameBg then
        MerchantFrameBg:Hide()
    end

    if MerchantFrameCloseButton then
        MerchantFrameCloseButton:Hide()
    end

    if MerchantFrameInset then
        MerchantFrameInset:Hide()
    end

    if MerchantFrame.NineSlice then
        MerchantFrame.NineSlice:Hide()
    end
end

--MerchantItem 默认层级 DIALOG
--BodyFrame 默认的层级是 BACKGROUND

function MerchantModule:RegisterMerchantItemGamepadButtonDown(frame)
    local callback_select = function(currentItem)
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
    end

    local callback_up_down = function(currentItem, preItem)
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
    end

    local callback_system = function(currentItem)
        MerchantFrame:Hide();
        MerchantItemGameTooltip:Hide();
    end

    local callback_dressUp = function(currentItem)
        if (currentItem.dressUpFrame) then
            currentItem.dressUpFrame:Destroy();
            currentItem.dressUpFrame = nil;
            return;
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

        print(currentItem.itemLink);
        print("TryOn");
        frame:Show();
        frame:ShowOffsetXAnimation();
        frame:ShowFadeIn();
        currentItem.dressUpFrame = frame;
    end

    --X按钮
    frame:RegisterGamePadButtonDown("PAD2", callback_select);

    --方向键
    frame:RegisterGamePadButtonDown("PADDDOWN", callback_up_down);
    frame:RegisterGamePadButtonDown("PADDUP", callback_up_down);
    frame:RegisterGamePadButtonDown("PADDLEFT", callback_up_down);
    frame:RegisterGamePadButtonDown("PADDRIGHT", callback_up_down);

    --系统键
    frame:RegisterGamePadButtonDown("PADSYSTEM", callback_system);

    --三角
    frame:RegisterGamePadButtonDown("PAD4", callback_dressUp);
end

function MerchantModule:InitframeStrata()
    MaskFrameModule:SetBackground();
end
