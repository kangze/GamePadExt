local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local MerchantModule = Gpe:GetModule('MerchantModule');

local currentItems = {};

local HeaderFrameModule = nil;

function MerchantModule:OnInitialize()
    --DeveloperConsole:Toggle()

    self:RegisterEvent("MERCHANT_SHOW");
    self:RegisterEvent("MERCHANT_CLOSED")
    --self:SecureHook("OpenAllBags", "test");

    _G.MERCHANT_ITEMS_PER_PAG = 60;
    for i = 1, _G.MERCHANT_ITEMS_PER_PAG do
        if not _G["MerchantItem" .. i] then
            CreateFrame("Frame", "MerchantItem" .. i, MerchantFrame, "MerchantItemTemplate");
        end
    end
end

function MerchantModule:OnEnable()
    HeaderFrameModule = Gpe:GetModule('HeaderFrameModule');
    self:SecureHook("MerchantFrame_UpdateMerchantInfo", "UpdateMerchantPositions");
end

function MerchantModule:MERCHANT_SHOW()
    -- 创建一个纯黑色背景 Texture
    -- local frame = CreateFrame("Frame", nil, UIParent);
    -- frame:SetAllPoints(UIParent);
    -- frame.background = frame:CreateTexture(nil, "BACKGROUND")
    -- frame.background:SetAllPoints(frame)
    -- --frame.background:SetColorTexture(0, 0, 0, 1) -- 设置背景颜色为纯黑色
    -- frame.background:SetAtlas("talents-background-priest-shadow");
    -- frame:Show()

    --legioninvasion-ScenarioTrackerToast

    HeaderFrameModule:ShowAll();

    UIParent:SetAlpha(0);


    self:HiddeMerchantSomeFrame();
    MerchantFrame:ClearAllPoints();
    MerchantFrame:SetParent(nil);
    MerchantFrame:SetPoint("TOP", HeaderFrameModule:GetHeaderFrame());
    --设置为FULLSCREEN


    local count = GetMerchantNumItems();

    local templeteWidth = 210;
    local pages = math.ceil(count / 10);
    MerchantFrame:SetSize(templeteWidth * pages + 100, UIParent:GetHeight());

    local callback2 = function(currentItem)
        HeaderFrameModule:SetFullScreen();
        currentItem:SetParent(nil);
        currentItem:SetFrameStrata("FullScreen");
    end

    local callback = function(index, page, itemLink, cost, texture, itemQuality, isMoney, isUsable)
        local source = _G["MerchantItem" .. index];
        source:ClearAllPoints();
        local offsetY = -1 * index + 10 * (page - 1);
        source:SetPoint("TOPLEFT", 230 * (page - 1), (offsetY) * 55);
        local frame = CreateFrame("Frame", nil, _G["MerchantItem" .. index], "MerchantItemTemplate1");
        frame:SetPoint("CENTER");
        frame:RegisterGamePadButtonDown("PAD2", callback2);
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
        frame.icon:SetTexture(texture);
        if (not isUsable) then
            frame.icon:SetVertexColor(0.96078431372549, 0.50980392156863, 0.12549019607843, 1);
            local reason = MerchantApi:GetCannotBuyReason(index);
            frame.forbidden:SetText(reason);
        end
        frame.iconBorder:SetAtlas(GetQualityBorder(itemQuality));
        frame:Group("group" .. page);
        frame:Show();
        table.insert(currentItems, frame);
    end

    MerchantApi:PreProccessItemsInfo(callback);
end

function MerchantModule:MERCHANT_CLOSED()
    HeaderFrameModule:HideBody();
    UIParent:SetAlpha(1);
    for i = 1, #currentItems do
        currentItems[i]:EnableGamePadButton(false);
        currentItems[i]:UnregisterAllEvents();
        currentItems[i]:Hide();
        MerchatItemGroups = {};
    end
end

--Sample:Masque
-- local group = Masque:Group("GamePadExt", "MerchantItem");
-- group:AddButton(MerchantItem.button);

function MerchantModule:UpdateMerchantPositions()
    self:HiddeMerchantSomeFrame();
    MerchantFrame:ClearAllPoints();
    MerchantFrame:SetParent(nil);
    MerchantFrame:SetPoint("TOP", HeaderFrameModule:GetHeaderFrame());
    local count = GetMerchantNumItems();
    for i = 1, count do
        local page = math.ceil(i / 10)
        local source = _G["MerchantItem" .. i];
        local offsetY = -1 * i + 10 * (page - 1);
        source:ClearAllPoints();
        source:SetPoint("TOPLEFT", 230 * (page - 1), offsetY * 55)
        source:Show();
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
