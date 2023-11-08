local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local BussniessTradeModule = Gpe:GetModule('BussniessTradeModule');


function BussniessTradeModule:OnInitialize()
    --DeveloperConsole:Toggle()
    self:RegisterEvent("MERCHANT_SHOW");
end

function BussniessTradeModule:MERCHANT_SHOW()
    local numItems = GetMerchantNumItems()
    self.shadow.animation:Show();
    

    -- 遍历所有商品
    for i = 1, numItems do
        -- 获取商品的信息
        local name, texture, price, quantity, numAvailable, isUsable, extendedCost, isReadable, quality, _, itemID = GetMerchantItemInfo(i)
    end
end

function BussniessTradeModule:OnEnable()
    local group = Masque:Group("GamePadExt", "MerchantItem");
    group:AddButton(MerchantItem.button);
    
    -- local frame = CreateFrame("Frame", "MyBlackFrame", UIParent)
    -- frame:SetAllPoints(UIParent);

    -- -- 创建一个纯黑色背景 Texture
    -- frame.background = frame:CreateTexture(nil, "BACKGROUND")
    -- frame.background:SetAllPoints(frame)
    -- frame.background:SetColorTexture(0.1725, 0.2431, 0.3137, 0.5) -- 设置背景颜色为纯黑色
    -- frame:Show()
    
end
