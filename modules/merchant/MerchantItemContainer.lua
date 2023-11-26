--物品容器框体
MerchantItemContainer = {
    scrollFrame = nil,
    scrollChildFrame = nil,
    tabsFrame = nil,
};

local MaskFrameModule = Gpe:GetModule('MaskFrameModule');


--创建滚动框体以及其他
function MerchantItemContainer:New(maxColum, templateWidht, templateHeigt, headFrame)
    local count = GetMerchantNumItems();

    local scale = UIParent:GetEffectiveScale();
    local height = GetScreenHeight() * scale - 30;

    local scrollFrame = CreateFrame("ScrollFrame", nil, nil)
    scrollFrame:SetSize(templateWidht * maxColum * 1.5, height)
    scrollFrame:SetPoint("TOP", headFrame, "BOTTOM", 0, 0);

    local scrollChildFrame = CreateFrame("Frame", nil, scrollFrame)
    scrollFrame:SetScrollChild(scrollChildFrame)
    scrollChildFrame:SetSize(templateWidht * maxColum * 1.5, (templateHeigt * count) / 2);

    local tabsFrame = self:NewTabs(headFrame);

    self.scrollFrame = scrollFrame;
    self.scrollChildFrame = scrollChildFrame;
    self.tabsFrame = tabsFrame;


    return scrollFrame, scrollChildFrame, tabsFrame;
end

function MerchantItemContainer:NewTabs(headFrame)
    local frame = CreateFrame("Frame", nil, headFrame, "MerchantTabsFrameTemplate");
    frame:SetPoint("CENTER");
    frame:SetFrameStrata("FULLSCREEN");
    frame.buy:SetHeight(headFrame:GetHeight() - 2);
    frame.rebuy:SetHeight(headFrame:GetHeight() - 2);
    local loseFocusCallback = function()
        MerchantItemContainer:ScollFrameGetFocus();
        MerchantItemContainer:TabsFrameLoseFocus();
    end
    frame:InitEableGamePadButtonGroup("TabFrame", "group", 10, loseFocusCallback);
    frame:Show();
    self.tabsFrame = frame;
    return frame;
end

--商品列表失去焦点
function MerchantItemContainer:ScollFrameLoseFocus()
    MaskFrameModule:SETDIALOG();
end

--商品列表得到焦点
function MerchantItemContainer:ScollFrameGetFocus()
    MaskFrameModule:SetBackground();
end

--Tabs得到焦点
function MerchantItemContainer:TabsFrameGetFocus()

end

--Tabs失去焦点
function MerchantItemContainer:TabsFrameLoseFocus()

end
