local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local BussniessTradeModule = Gpe:GetModule('BussniessTradeModule');



function BussniessTradeModule:OnInitialize()
    --DeveloperConsole:Toggle()
    OpenAllBags = function()

    end
    self:RegisterEvent("MERCHANT_SHOW");
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
    MerchantFrame:SetSize(1000, 900)
    self:HiddeMerchantSomeFrame();

    local count = GetMerchantNumItems();
    for i = 1, count do
        local page = math.ceil(i / 10)
        local source = _G["MerchantItem" .. i];

        if (source.item) then
            source.item:EnableGamePadButton(false);
            source.item:Hide();
            source.item = nil;
        end
        source:ClearAllPoints();
        local offsetY = -1 * i + 10 * (page - 1);
        source:SetPoint("TOPLEFT", 400 * (page - 1), (offsetY) * 80)
        local itemLink, cost, texture = self:GetItemInfoByMerchantItemIndex(i);
        local frame = CreateFrame("Frame", nil, _G["MerchantItem" .. i], "MerchantItemTemplate1");
        frame:SetPoint("LEFT");
        if (itemLink) then
            itemLink = string.gsub(itemLink, "%[", "", 1);
            itemLink = string.gsub(itemLink, "%]", "", 1);
        end

        frame.productName:SetText(itemLink);
        frame.itemLink = itemLink;
        frame.cost:SetText(cost);
        frame.icon:SetTexture(texture);
        frame:Group("group" .. page);
        frame:Show();
        source.item = frame;
    end
end

function BussniessTradeModule:OnEnable()
    -- local frame=CreateFrame("Frame",nil,UIParent,"MerchantItemTemplate1");
    --     frame:SetPoint("CENTER");

    -- for i=1,10 do
    --     local frame=CreateFrame("Frame",nil,UIParent,"MerchantItemTemplate1");
    --     frame:SetPoint("TOP",UIParent,0,-76*(i-1));
    --     frame:Group("group1");
    --     --frame.text2:SetText("500|TInterface\\AddOns\\GamePadExt\\media\\texture\\UI-GoldIcon:18:18:0:0|t");
    -- end

    -- for i=1,10 do
    --     local frame=CreateFrame("Frame",nil,UIParent,"MerchantItemTemplate1");
    --     frame:SetPoint("TOP",UIParent,380,-76*(i-1));
    --     frame:Group("group2");
    -- end

    -- local frame = CreateFrame("Frame", "MyBlackFrame", UIParent)
    -- frame:SetAllPoints(UIParent);

    -- -- 创建一个纯黑色背景 Texture
    -- frame.background = frame:CreateTexture(nil, "BACKGROUND")
    -- frame.background:SetAllPoints(frame)
    -- frame.background:SetColorTexture(0.1725, 0.2431, 0.3137, 0.5) -- 设置背景颜色为纯黑色
    -- frame:Show()
end

--Sample:Masque
-- local group = Masque:Group("GamePadExt", "MerchantItem");
-- group:AddButton(MerchantItem.button);

function BussniessTradeModule:GetItemInfoByMerchantItemIndex(index)
    local _, texture = GetMerchantItemInfo(index)
    local itemLink = GetMerchantItemLink(index)
    local currencyCount = GetMerchantItemCostInfo(index)
    local cost = "";
    for j = 1, currencyCount do
        local itemTexture, itemValue, itemLink, currencyName = GetMerchantItemCostItem(index, j);
        cost = cost .. itemValue .. " " .. itemLink .. " ";
    end
    return itemLink, cost, texture;
end

function BussniessTradeModule:UpdateMerchantPositions()
    self:HiddeMerchantSomeFrame();
    local count = GetMerchantNumItems();
    for i = 1, count do
        local page = math.ceil(i / 10)
        local source = _G["MerchantItem" .. i];
        local offsetY = -1 * i + 10 * (page - 1);
        source:ClearAllPoints();
        source:SetPoint("TOPLEFT", 400 * (page - 1), offsetY * 80)
        source:Show();
    end
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
