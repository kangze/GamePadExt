local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local MerchantModule = Gpe:GetModule('MerchantModule');
local MaskFrameModule = Gpe:GetModule('MaskFrameModule');
local UIErrorFrameModule = Gpe:GetModule('UIErrorFrameModule');


function MerchantModule:MERCHANT_SHOW()
    --全局UI进行隐藏
    --UIParent:Hide();
    UIErrorFrameModule:AddMessage("MerchantItemGamepadButtonDown");

    --顶部菜单开始激活
    MaskFrameModule:Active("MerchantTabFrameHeader");

    self:ResetScrollFrame();

    --初始化买入和卖出2个GamePadInitor
    self:InitGamePadInitors();

    MaskFrameModule:SetContents(self.buy_scrollFrame, self.buyback_scrollFrame);
end

function MerchantModule:MERCHANT_CLOSED()
    UIParent:Show();
    --通知MaskFrameModule关闭一些实例
    MaskFrameModule:Destroy("merchantTab");
    --取消gamepad监听以及对应窗体的销毁
    self:Destory();
    self.buy_gamePadInitor:Destroy();
    self.buyback_gamePadInitor:Destroy();
end

function MerchantModule:ResetScrollFrame()
    self.buy_scrollFrame:SetVerticalScroll(0);
    self.buy_scrollFrame:Show();
    self.buy_scrollFrame:SetAlpha(1);

    self.buyback_scrollFrame:SetVerticalScroll(0);
    self.buyback_scrollFrame:Hide();
    self.buyback_scrollFrame:SetAlpha(1);
end

function MerchantModule:InitGamePadInitors()
    --买入GamePadInitor
    buy_gamePadInitor = GamePadInitor:Init(GamePadInitorNames.MerchantBuyFrame.Name,
        GamePadInitorNames.MerchantBuyFrame.Level);
    buy_gamePadInitor:SetRegion(self.buy_scrollFrame);
    self.buy_gamePadInitor = buy_gamePadInitor;
    local merchantItemInfos = MerchantApi:GetMerchantBuyItemInfos();
    local merchantItems = MerchantItem_Render(merchantItemInfos, self.buy_scrollChildFrame, self.buy_scrollFrame, true);
    test = merchantItems;
    for index = 1, #merchantItems do
        buy_gamePadInitor:Add(merchantItems[index], "group" .. merchantItems[index].col);
    end
    RegisterMerchantItemGamepadButtonDown(buy_gamePadInitor);

    --买回GamePadInitor
    buyback_gamePadInitor = GamePadInitor:Init(GamePadInitorNames.MerchantBuyBackFrame.Name,
        GamePadInitorNames.MerchantBuyBackFrame.Level);
    buyback_gamePadInitor:SetRegion(self.buyback_scrollFrame);
    self.buyback_gamePadInitor = buyback_gamePadInitor;
    local merchantbuybackItemInfos = MerchantApi:GetMerchantBuybackItemInfos();
    local merchantbuybackItems = MerchantItem_Render(merchantbuybackItemInfos, self.buyback_scrollChildFrame,
        self.buyback_scrollFrame, false);
    for index = 1, #merchantbuybackItems do
        buyback_gamePadInitor:Add(merchantbuybackItems[index], "group" .. merchantbuybackItems[index].col);
    end
    RegisterMerchantItemGamepadButtonDown(buyback_gamePadInitor);
end
