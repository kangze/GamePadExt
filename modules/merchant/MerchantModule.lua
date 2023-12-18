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


    local leave_callback = function(frame)
        local children = { frame:GetChildren() };
        for i = 1, #children do
            local child = children[i];
            --释放child窗体
            child:UnregisterAllEvents();
            child:ClearAllPoints();
            child:SetParent(nil);
            child:Hide();
        end
    end;
    local scrollChildFrame = CreateFrame("Frame", nil, scrollFrame)
    scrollChildFrame.OnLeave = leave_callback;
    scrollFrame:SetScrollChild(scrollChildFrame)
    scrollChildFrame:SetSize(self.templateWidth * self.maxColum * 1.5, height); --TODO:这里需要计算

    scrollFrame:SetPoint("TOP", UIParent, 0, -40);

    self.scrollFrame = scrollFrame;
    self.scrollChildFrame = scrollChildFrame;

    MerchantFrame:ClearAllPoints();
end

--初始化tab布局选项
function MerchantModule:InitTabls()
    --注册tab按键的内容
    local RegisterTabsButtonDown = function(gamePadInitor)
        --tab页面的切换
        gamePadInitor:Register("PADRTRIGGER,PADLTRIGGER", function(currentItem, preItem)
            if (preItem and preItem.OnLeave) then
                preItem:OnLeave();
            end
            if (currentItem and currentItem.OnEnter) then
                currentItem:OnEnter();
            end
        end); --tab选项选择
        gamePadInitor:Register("PAD1", function(currentItem, preItem)
            print(currentItem.associateName);
            gamePadInitor:Switch(currentItem.associateName);
            MerchantModule:Update(currentItem.associateName);
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
        local gamePadInitor = GamePadInitor:Init(GamePadInitorNames.MerchantTabFrame.Name,
            GamePadInitorNames.MerchantTabFrame.Level);
        gamePadInitor:Add(frame.buy, "group", GamePadInitorNames.MerchantBuyFrame.Name);
        gamePadInitor:Add(frame.rebuy, "group", GamePadInitorNames.MerchantBuyBackFrame.Name);
        gamePadInitor:SetRegion(frame);
        RegisterTabsButtonDown(gamePadInitor);
        return frame;
    end
    HeaderRegions:Register("MerchantTabFrameHeader", callback);
end
