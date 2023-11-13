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
        -- if (not source:IsShown()) then
        --     source:SetPoint("CENTER");
        --     source:Show();
        -- end

        if (source.item) then return; end
        source:ClearAllPoints();
        local offsetY = -1 * i + 10 * (page - 1);
        source:SetPoint("TOPLEFT", 400 * (page - 1), (offsetY) * 80)
        local itemLink, cost, texture = self:GetItemInfoByMerchantItemIndex(i);
        local frame = CreateFrame("Frame", nil, _G["MerchantItem" .. i], "MerchantItemTemplate1");
        frame:SetPoint("LEFT");
        itemLink = string.gsub(itemLink, "%[", "", 1);
        itemLink = string.gsub(itemLink, "%]", "", 1);
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
    local pages = math.ceil(count / 10);
    for page = 1, pages do
        local endIndex = page * 10;
        if (page == count) then
            endIndex = count - page * 10
        end

        for i = (page - 1) * 10 + 1, endIndex do
            local source = _G["MerchantItem" .. i];
            local offsetY = -1 * i + 10 * (page - 1);
            source:ClearAllPoints();
            source:SetPoint("TOPLEFT", 400 * (page - 1), offsetY * 80)
            source:Show();
        end
    end
end

function BussniessTradeModule:HiddeMerchantSomeFrame()
    --买回
    MerchantBuyBackItem:Hide();
    --自己的货币
    MerchantExtraCurrencyBg:Hide();
    MerchantExtraCurrencyInset:Hide();

    --下一页
    MerchantNextPageButton:Hide();
    MerchantPrevPageButton:Hide();

    MerchantFrameBottomLeftBorder:Hide();

    --商人名称
    MerchantFrame.TitleContainer:Hide();

    MerchantFrame.TopTileStreaks:Hide();

    MerchantFrameTab1:Hide();
    MerchantFrameTab2:Hide();

    --头像
    MerchantFrame.PortraitContainer:Hide();

    --过滤器
    MerchantFrameLootFilter:Hide();

    --售卖垃圾
    MerchantSellAllJunkButton:Hide();

    --自己的金钱
    MerchantMoneyBg:Hide();
    MerchantMoneyInset:Hide();
    MerchantMoneyFrame:Hide();
    if (MerchantToken1) then
        MerchantToken1:Hide();
    end

    --翻页组件
    MerchantPageText:Hide();

    MerchantFrameBg:Hide();
    MerchantFrameCloseButton:Hide();

    --透明了
    MerchantFrameInset:Hide();

    --边框
    MerchantFrame.NineSlice:Hide();
end

function BussniessTradeModule:test()
end
