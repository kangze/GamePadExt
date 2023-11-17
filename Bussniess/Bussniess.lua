local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local BussniessTradeModule = Gpe:GetModule('BussniessTradeModule');

local currentItems = {};
local sourceOpenAllBags = OpenAllBags;

-- 0：粗糙（灰色）
-- 1：普通（白色）
-- 2：优秀（绿色）
-- 3：稀有（蓝色）
-- 4：史诗（紫色）
-- 5：传说（橙色）
-- 6：神器（金色）
-- 7：绑定（绿色）
-- 8：任务（白色）
local QualityTexs = {
    [0] = "loottoast-itemborder-gray",
    [1] = "loottoast-itemborder-gray",
    [2] = "loottoast-itemborder-green",
    [3] = "loottoast-itemborder-blue",
    [4] = "loottoast-itemborder-purple",
    [5] = "loottoast-itemborder-orange",
    [6] = "loottoast-itemborder-artifact",
    [7] = "loottoast-itemborder-green",
    [8] = "loottoast-itemborder-gray",
}

local function ApplyMoney(fontString, copper)
    local gold = math.floor(copper / 10000)
    copper = copper - gold * 10000
    local silver = math.floor(copper / 100)
    copper = copper - silver * 100

    local goldIcon = "|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t"
    local silverIcon = "|TInterface\\MoneyFrame\\UI-SilverIcon:14:14:2:0|t"
    local copperIcon = "|TInterface\\MoneyFrame\\UI-CopperIcon:14:14:2:0|t"

    fontString:SetFormattedText("%d%s %d%s %d%s", gold, goldIcon, silver, silverIcon, copper, copperIcon)
end

function BussniessTradeModule:OnInitialize()
    --DeveloperConsole:Toggle()

    self:RegisterEvent("MERCHANT_SHOW");
    self:RegisterEvent("MERCHANT_CLOSED")
    self:SecureHook("MerchantFrame_UpdateMerchantInfo", "UpdateMerchantPositions");
    self:SecureHook("OpenAllBags", "test");

    _G.MERCHANT_ITEMS_PER_PAG = 60;
    for i = 1, _G.MERCHANT_ITEMS_PER_PAG do
        if not _G["MerchantItem" .. i] then
            CreateFrame("Frame", "MerchantItem" .. i, MerchantFrame, "MerchantItemTemplate");
        end
    end
end

function BussniessTradeModule:MERCHANT_SHOW()
    -- -- 创建一个纯黑色背景 Texture
    -- local frame = CreateFrame("Frame", nil, UIParent);
    -- frame:SetAllPoints(UIParent);
    -- frame.background = frame:CreateTexture(nil, "BACKGROUND")
    -- frame.background:SetAllPoints(frame)
    -- --frame.background:SetColorTexture(0, 0, 0, 1) -- 设置背景颜色为纯黑色
    -- frame.background:SetAtlas("talents-background-priest-shadow");
    -- frame:Show()

    --legioninvasion-ScenarioTrackerToast



    self:HiddeMerchantSomeFrame();
    MerchantFrame:ClearAllPoints();
    MerchantFrame:SetPoint("CENTER", UIParent);

    local count = GetMerchantNumItems();

    local templeteWidth = 350;
    local pages = math.ceil(count / 10);
    MerchantFrame:SetSize(templeteWidth * pages + 100, UIParent:GetHeight());

    OpenAllBags = function() end

    for i = 1, count do
        local page = math.ceil(i / 10)
        local source = _G["MerchantItem" .. i];
        source:ClearAllPoints();
        local offsetY = -1 * i + 10 * (page - 1);
        source:SetPoint("TOPLEFT", 400 * (page - 1), (offsetY) * 82);
        local itemLink, cost, texture, itemQuality, isMoney = self:GetItemInfoByMerchantItemIndex(i);
        local frame = CreateFrame("Frame", nil, _G["MerchantItem" .. i], "MerchantItemTemplate1");
        frame:SetPoint("CENTER");
        if (itemLink) then
            itemLink = string.gsub(itemLink, "%[", "", 1);
            itemLink = string.gsub(itemLink, "%]", "", 1);
        end
        frame.productName:SetText(itemLink);
        frame.itemLink = itemLink;
        if (isMoney) then
            ApplyMoney(frame.costmoney, cost);
        else
            frame.costmoney:SetText(cost);
        end
        frame.icon:SetTexture(texture);
        frame.iconBorder:SetAtlas(QualityTexs[itemQuality]);
        frame:Group("group" .. page);
        frame:Show();
        table.insert(currentItems, frame);
    end
end

function BussniessTradeModule:MERCHANT_CLOSED()
    OpenAllBags = sourceOpenAllBags();
    for i = 1, #currentItems do
        currentItems[i]:EnableGamePadButton(false);
        currentItems[i]:UnregisterAllEvents();
        currentItems[i]:Hide();
        MerchatItemGroups = {};
    end
end

function BussniessTradeModule:OnEnable()

end

--Sample:Masque
-- local group = Masque:Group("GamePadExt", "MerchantItem");
-- group:AddButton(MerchantItem.button);

function BussniessTradeModule:GetItemInfoByMerchantItemIndex(index)
    local itemLink = GetMerchantItemLink(index)
    local _, texture, price = GetMerchantItemInfo(index)
    local currencyCount = GetMerchantItemCostInfo(index)
    local _, _, itemQuality = GetItemInfo(itemLink);
    if (currencyCount == 0) then
        return itemLink, price, texture, itemQuality, true; --表示只要金币
    end

    local cost = "";
    for j = 1, currencyCount do
        local itemTexture, itemValue, itemLink, currencyName = GetMerchantItemCostItem(index, j);
        cost = cost .. itemValue;
        if (itemLink) then
            local currencyID = tonumber(string.match(itemLink, "currency:(%d+)"))
            local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyID)
            if currencyInfo and currencyInfo.iconFileID then
                local iconString = "|T" .. currencyInfo.iconFileID .. ":0|t"
                cost = cost .." ".. iconString .. " " .. itemLink
            else
                print("Invalid currency ID: " .. currencyID)
            end
        else
            cost = cost .. currencyName
        end
    end
    return itemLink, cost, texture, itemQuality, false;
end

function BussniessTradeModule:UpdateMerchantPositions()
    self:HiddeMerchantSomeFrame();
    MerchantFrame:ClearAllPoints();
    MerchantFrame:SetPoint("CENTER", UIParent);
    local count = GetMerchantNumItems();
    for i = 1, count do
        local page = math.ceil(i / 10)
        local source = _G["MerchantItem" .. i];
        local offsetY = -1 * i + 10 * (page - 1);
        source:ClearAllPoints();
        source:SetPoint("TOPLEFT", 400 * (page - 1), offsetY * 82)
        source:Show();
    end

    --其余的都给ClearPoint掉 TODO:kangze
end

function BussniessTradeModule:HiddeMerchantSomeFrame()
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

function BussniessTradeModule:test()
end
