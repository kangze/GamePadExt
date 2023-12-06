local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local MerchantModule = Gpe:GetModule('MerchantModule');

local MaskFrameModule = Gpe:GetModule('MaskFrameModule');

function MerchantModule:OnInitialize()
    --DeveloperConsole:Toggle()

    self:RegisterEvent("MERCHANT_SHOW");
    --self:RegisterEvent("MERCHANT_CLOSED")
    --self:SecureHook("OpenAllBags", "test");

    self.maxColum = 2;        --配置最大展示列数字

    self.templateWidth = 210; --配置模板宽度
    self.templateHeight = 45; --配置模板高度

    self.height_space = 10;   --配置高度间隔
    self.width_space = 40;    --配置宽度间隔
end

function MerchantModule:OnEnable()
    --self:SecureHook("MerchantFrame_UpdateMerchantInfo", "UpdateMerchantPositions");
    MerchantFrame:SetAlpha(0);
    MerchantFrame:InitShowFadeInAndOut();
    _G.MERCHANT_ITEMS_PER_PAG = 0;
    -- for i = 1, _G.MERCHANT_ITEMS_PER_PAG do
    --     if not _G["MerchantItem" .. i] then
    --         CreateFrame("Frame", "MerchantItem" .. i, MerchantFrame, "MerchantItemTemplate");
    --     end
    -- end

    --初始化布局
    MerchantModule:InitLayout();

    --初始化tab选项
    MerchantModule:InitTabls();
end

--Sample:Masque
-- local group = Masque:Group("GamePadExt", "MerchantItem");
-- group:AddButton(MerchantItem.button);

--初始化布局
function MerchantModule:InitLayout()
    local scale = UIParent:GetEffectiveScale();
    local height = GetScreenHeight() * scale - 30;

    local scrollFrame = CreateFrame("ScrollFrame", nil, nil)
    scrollFrame:SetSize(self.templateWidth * self.maxColum * 1.5, height)

    local scrollChildFrame = CreateFrame("Frame", nil, scrollFrame)
    scrollFrame:SetScrollChild(scrollChildFrame)
    scrollChildFrame:SetSize(self.templateWidth * self.maxColum * 1.5, height); --TODO:这里需要计算

    scrollChildFrame.OnLeave = function()
        print("我childFrame离开了");
    end;

    scrollFrame:SetPoint("TOP", UIParent, 0, -35);

    --初始化2个region区域给商品列表
    local frame_buy = CreateFrame("Frame", "buyRegion", scrollChildFrame);
    frame_buy:SetAllPoints();

    local frame_buyback = CreateFrame("Frame", "buybackRegion", scrollChildFrame);
    frame_buyback:SetAllPoints();

    self.scrollFrame = scrollFrame;
    self.scrollChildFrame = scrollChildFrame;
    self.frame_buy = frame_buy;
    self.frame_buyback = frame_buyback;

    MerchantFrame:ClearAllPoints();
    MerchantFrame:SetParent(scrollChildFrame);
    MerchantFrame:SetPoint("TOPLEFT", scrollChildFrame);
    MerchantFrame:SetPoint("BOTTOMRIGHT", scrollChildFrame);
end

--初始化tab布局选项
function MerchantModule:InitTabls()
    local RegisterTabsButtonDown = function(gamePadInitor)
        gamePadInitor:Register("PADRTRIGGER,PADLTRIGGER", function(currentItem, preItem)
            if (preItem and preItem.OnLeave) then
                preItem:OnLeave();
            end
            if (currentItem and currentItem.OnEnter) then
                currentItem:OnEnter();
            end
        end);

        --tab选项选择
        gamePadInitor:Register("PAD1", function(currentItem, preItem)
            gamePadInitor:SelectTab(currentItem.tabName);
            self.mode = currentItem.tabName;
            MaskFrameModule:TopContent();
        end);

        --注册这个框架关闭
        gamePadInitor:Register("PADSYSTEM", function(currentItem, prrItem)
            MerchantModule:MERCHANT_CLOSED() --2个gamepadInitor都被关闭了
            gamePadInitor:Destroy();
        end);
    end

    local callback = function(headFrame)
        local frame = CreateFrame("Frame", nil, nil, "MerchantTabsFrameTemplate");
        frame.buy:SetHeight(headFrame:GetHeight() - 2);
        frame.rebuy:SetHeight(headFrame:GetHeight() - 2);
        local gamePadInitor = GamePadInitor:Init("TabFrame", 10);
        gamePadInitor:Add(frame.buy, "group", "buy");
        gamePadInitor:Add(frame.rebuy, "group", "buyback");
        gamePadInitor:SetRegion(frame);
        RegisterTabsButtonDown(gamePadInitor);
        return frame;
    end
    HeaderRegions:Register("merchantTab", callback);
end

--处理MerchantFrame Hook
function MerchantModule:UpdateMerchantPositions()
    self:HiddeMerchantSomeFrame();
    MerchantFrame:ClearAllPoints();
    MerchantFrame:SetParent(self.scrollChildFrame);
    MerchantFrame:SetPoint("TOPLEFT", self.scrollChildFrame);
    MerchantFrame:SetPoint("BOTTOMRIGHT", self.scrollChildFrame);

    local count = nil;
    local region = nil;

    if (self.mode == "buy") then
        count = GetMerchantNumItems();
        region = self.frame_buy;
    else
        count = GetNumBuybackItems();
        region = self.frame_buyback;
    end
    local middle = math.ceil(count / self.maxColum);

    for index = 1, count do
        local source = self:PointMerchantItem(index, middle, region);
        if (source) then
            source:Show();
        end
    end
end

function MerchantModule:PointMerchantItem(index, middle, region)
    local source = _G["MerchantItem" .. index];
    if (source ~= nil) then
        source:ClearAllPoints();
        local col = math.ceil(index / middle);
        local offsetX, offsetY = self:GetColInfo(index, col, middle);
        source:SetPoint("TOPLEFT", region, offsetX, offsetY);
    end
    return source;
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
