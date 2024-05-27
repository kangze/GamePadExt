local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local MerchantModule = Gpe:GetModule('MerchantModule');

local MaskFrameModule = Gpe:GetModule('MaskFrameModule');

function MerchantModule:OnInitialize()
    --DeveloperConsole:Toggle()

    self:RegisterEvent("MERCHANT_SHOW");
    self:RegisterEvent("ITEM_DATA_LOAD_RESULT");
    --self:RegisterEvent("MERCHANT_CLOSED")
    --self:SecureHook("OpenAllBags", "test");

    self.maxColum = 2;        --配置最大展示列数字

    self.templateWidth = 210; --配置模板宽度
    self.templateHeight = 45; --配置模板高度

    self.height_space = 10;   --配置高度间隔
    self.width_space = 40;    --配置宽度间隔

    UIErrorsFrame.originalAddMessage = UIErrorsFrame.AddMessage
end

function MerchantModule:OnEnable()
    MerchantFrame:SetAlpha(0);
    MerchantFrame:ClearAllPoints();


    --初始化布局滚动,以及幻化窗口
    local buy_scrollFrame, buy_scrollChildFrame = MerchantScorll_Create();
    local buyback_scrollFrame, buyback_scrollChildFrame = MerchantScorll_Create();

    self.buy_scrollFrame = buy_scrollFrame;
    self.buy_scrollChildFrame = buy_scrollChildFrame;
    self.buyback_scrollFrame = buyback_scrollFrame;
    self.buyback_scrollChildFrame = buyback_scrollChildFrame;

    local bodyFrame = MaskFrameModule.bodyFrame;
    local dressUpFrame = MerchantDressUpFrame_Create(bodyFrame);
    self.dressUpFrame = dressUpFrame;

    --初始化tab选项
    local callback = function(frame)
        frame.buy.content = self.buy_scrollFrame;
        frame.rebuy.content = self.buyback_scrollFrame;
    end
    HeaderRegions:Register("MerchantTabFrameHeader", MerchantTabActiveCallBack, callback);
    
end

--Sample:Masque
-- local group = Masque:Group("GamePadExt", "MerchantItem");
-- group:AddButton(MerchantItem.button);


--尝试幻化
function MerchantModule:MerchantItemTryMog(merchantItem)
    self.dressUpFrame:Show();
    self.dressUpFrame:SetPlayer();
    self.dressUpFrame:TryOn(merchantItem.itemLink);
end

--幻化关闭
function MerchantModule:MerchantItemTryMogHide()
    self.dressUpFrame:Hide();
end

--展示物品详情
function MerchantModule:ShowMerchantItemTooltip(merchantItem)
    MerchantItemGameTooltip:ClearAllPoints();
    MerchantItemGameTooltip:SetOwner(merchantItem, "ANCHOR_NONE", 0);
    MerchantItemGameTooltip:SetPoint("LEFT", merchantItem, "RIGHT", 0, 0);
    MerchantItemGameTooltip:SetHyperlink(merchantItem.itemLink);
    MerchantItemGameTooltip:Show();
end

--买回或者购买物品
function MerchantModule:MerchantItemBuyOrBuyback(merchantItem)
    if (merchantItem.isbuy) then
        BuyMerchantItem(merchantItem.index, 1);
    else
        BuybackItem(merchantItem.index);
    end
end

--滚动窗体
function MerchantModule:Scroll(merchantItem)
    local scrollFrame = merchantItem.scrollFrame;
    local total_height = scrollFrame:GetHeight();
    local item_height = merchantItem:GetHeight();
    local current_index = merchantItem.currentIndex;
    local ratio = 3;
    local current_position = scrollFrame:GetVerticalScroll();

    --判断是否需要滚动
    if (current_index == 0) then
        scrollFrame.animation_scroll:Play(current_position, 0);
        return;
    end
    if (item_height * current_index > total_height / ratio) then
        scrollFrame.animation_scroll:Play(current_position,
            item_height * current_index - total_height / ratio);
        return;
    end
    if (item_height * current_index > total_height / ratio) then
        scrollFrame.animation_scroll:Play(current_position,
            item_height * current_index - total_height / ratio);
        return;
    end
end

--销毁所有的框体
function MerchantModule:Destory()
    local buyItems = GetAllChildren(self.buy_scrollChildFrame);
    if (buyItems) then
        for i = 1, #buyItems do
            local child = buyItems[i];
            child:UnregisterAllEvents();
            child:ClearAllPoints();
            child:SetParent(nil);
            child:Hide();
        end
    end

    local buybackItems = GetAllChildren(self.buyback_scrollChildFrame);
    if (buybackItems) then
        for i = 1, #buybackItems do
            local child = buybackItems[i];
            child:UnregisterAllEvents();
            child:ClearAllPoints();
            child:SetParent(nil);
            child:Hide();
        end
    end
end
