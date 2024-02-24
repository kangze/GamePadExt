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
    MerchantFrame:SetAlpha(0);
    MerchantFrame:ClearAllPoints();


    --初始化布局滚动,以及幻化窗口
    local buy_scrollFrame, buy_scrollChildFrame = self:InitLayout();
    local buyback_scrollFrame, buyback_scrollChildFrame = self:InitLayout();

    self.buy_scrollFrame = buy_scrollFrame;
    self.buy_scrollChildFrame = buy_scrollChildFrame;
    self.buyback_scrollFrame = buyback_scrollFrame;
    self.buyback_scrollChildFrame = buyback_scrollChildFrame;

    local dressUpFrame = self:InitDressUpFrame();
    self.dressUpFrame = dressUpFrame;

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

    --ScrollFade,0,0表示需要Play特定赋值
    scrollFrame.animation_scroll = Animation:new(0.3, 0, 0, function(current)
        scrollFrame:SetVerticalScroll(current);
    end, nil, EasingFunctions.OutSine);

    local leave_callback = function(frame)
        frame:SetAlpha(0);
    end
    local enter_callback = function(frame)
        frame:SetAlpha(1);
    end

    local scrollChildFrame = CreateFrame("Frame", nil, scrollFrame)
    scrollFrame.OnLeave = leave_callback;
    scrollFrame.OnEnter = enter_callback;
    scrollFrame.Destory = function() self:DestoryFrames() end;
    scrollFrame:SetScrollChild(scrollChildFrame)
    scrollChildFrame:SetSize(self.templateWidth * self.maxColum * 1.5, height);

    scrollFrame:SetPoint("TOP", UIParent, 0, -40);
    return scrollFrame, scrollChildFrame;
end

--初始化tab布局选项
function MerchantModule:InitTabls()
    local frameRegister = function(headFrame)
        local frame = CreateFrame("Frame", nil, nil, "MerchantTabsFrameTemplate");
        frame.buy:SetHeight(headFrame:GetHeight() - 2);
        frame.buy.content = self.buy_scrollFrame;

        frame.rebuy:SetHeight(headFrame:GetHeight() - 2);
        frame.rebuy.content = self.buyback_scrollFrame;
        local gamePadInitor = GamePadInitor:Init(GamePadInitorNames.MerchantTabFrame.Name,
            GamePadInitorNames.MerchantTabFrame.Level);
        gamePadInitor:Add(frame.buy, "group", GamePadInitorNames.MerchantBuyFrame.Name);
        gamePadInitor:Add(frame.rebuy, "group", GamePadInitorNames.MerchantBuyBackFrame.Name);
        gamePadInitor:SetRegion(frame);
        MerchantModule:RegisterMerchantTabGamepadButtonDown(gamePadInitor);
        return frame;
    end
    HeaderRegions:Register("MerchantTabFrameHeader", frameRegister);
end

function MerchantModule:InitDressUpFrame()
    local frame = CreateFrame("Frame", nil, nil, "DressupFrameTemplate");
    local bodyFrame = MaskFrameModule.bodyFrame;
    frame:ClearAllPoints();
    frame:SetPoint("RIGHT", bodyFrame, 0, 0);
    local scale = UIParent:GetEffectiveScale();
    frame:SetWidth(300);
    frame:SetHeight(GetScreenHeight() * scale - 100);
    frame:SetFrameStrata("DIALOG");
    frame:Hide();
    return frame;
end

--尝试幻化
function MerchantModule:MerchantItemTryMog(merchantItem)
    self.dressUpFrame:Show();
    self.dressUpFrame:SetPlayer();
    self.dressUpFrame:TryOn(merchantItem.itemLink);
end

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

--摧毁所有的相关的frames,目前主要是摧毁所有的MerchantItems
function MerchantModule:DestoryFrames()
    local buyItems = self.buy_scrollChildFrame:GetChildren();
    for i = 1, #buyItems do
        local child = buyItems[i];
        --释放child窗体
        child:UnregisterAllEvents();
        child:ClearAllPoints();
        child:SetParent(nil);
        child:Hide();
    end

    local buybackItems = self.buy_scrollChildFrame:GetChildren();
    for i = 1, #buybackItems do
        local child = buybackItems[i];
        --释放child窗体
        child:UnregisterAllEvents();
        child:ClearAllPoints();
        child:SetParent(nil);
        child:Hide();
    end
end
