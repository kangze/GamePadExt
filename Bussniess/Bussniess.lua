local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local BussniessTradeModule = Gpe:GetModule('BussniessTradeModule');


function BussniessTradeModule:OnInitialize()
    --DeveloperConsole:Toggle()
    self:RegisterEvent("MERCHANT_SHOW");
    self:SecureHook("MerchantFrame_UpdateMerchantInfo", "UpdateMerchantPositions");

    _G.MERCHANT_ITEMS_PER_PAG = 60;
    for i = 1, _G.MERCHANT_ITEMS_PER_PAG do
        if not _G["MerchantItem" .. i] then
            CreateFrame("Frame", "MerchantItem" .. i, MerchantFrame, "MerchantItemTemplate");
        end

        --CreateFrame("Frame", "MerchantItem1", _G.MerchantFrame, "MerchantItemTemplate")
    end
end

function BussniessTradeModule:MERCHANT_SHOW()
    -- MerchantItem1ItemButton:EnableGamePadButton(true)
    -- MerchantItem1ItemButton:SetScript("OnGamePadButtonDown", function(selfs)
    --     print(selfs);
    --     --selfs:Click();
    -- end);


    MerchantFrame:SetSize(1000, 900)


    -- MerchantItem2:ClearAllPoints();
    -- MerchantItem2:SetPoint("TOPRIGHT");

    MerchantFrameBg:Hide();
    MerchantFrameCloseButton:Hide();

    --透明了
    MerchantFrameInset:Hide();

    --边框
    MerchantFrame.NineSlice:Hide();
    print("show");

    for i = 1, 12 do
        local source = _G["MerchantItem" .. i];
        print(source);
        if (not source:IsShown()) then
            source:SetPoint("CENTER");
            source:Show();
        end

        if (source.item) then return; end
        source:ClearAllPoints();
        source:SetPoint("TOPLEFT", 100, (-1 * i) * 80)
        local itemLink, cost, texture = self:GetItemInfoByMerchantItemIndex(i);
        local frame = CreateFrame("Frame", nil, _G["MerchantItem" .. i], "MerchantItemTemplate1");
        frame.productName:SetText(itemLink);
        frame.itemLink = itemLink;
        frame.cost:SetText(cost);
        frame.icon:SetTexture(texture);
        frame:Group("ff");
        frame:Show();
        source.item = frame;
    end
end

function BussniessTradeModule:UpdateMerchantPositions()
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
    MerchantToken1:Hide();

    --翻页组件
    MerchantPageText:Hide();

    for i = 1, 12 do
        local source = _G["MerchantItem" .. i];
        source:ClearAllPoints();
        source:SetPoint("TOPLEFT", 100, (-1 * i) * 80)
        source:Show();
    end
end

function BussniessTradeModule:ShowPanel()
    local count = GetMerchantNumItems()
    local groupCount = math.floor(count / 11);
    for group = 1, groupCount do
        for i = 1, 8 do
            local index = 8 * group + i;
            local _, texture = GetMerchantItemInfo(index)
            local itemLink = GetMerchantItemLink(index)
            local currencyCount = GetMerchantItemCostInfo(index)
            local cost = "";
            for j = 1, currencyCount do
                local itemTexture, itemValue, itemLink, currencyName = GetMerchantItemCostItem(index, j);
                cost = cost .. itemValue .. " " .. itemLink .. " ";
            end
            local frame = CreateFrame("Frame", nil, UIParent, "MerchantItemTemplate1");
            frame:SetPoint("TOPLEFT", UIParent, 500 + 400 * (group - 1), -76 * (i - 1));
            frame.productName:SetText(itemLink);
            frame.itemLink = itemLink;
            frame.cost:SetText(cost);
            frame.icon:SetTexture(texture);
            frame:Group("group" .. group);
        end
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
