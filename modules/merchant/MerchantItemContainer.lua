--物品容器框体
MerchantItemContainer = {};


function MerchantItemContainer:NewScrollFrame(maxColum, templateWidht, templateHeigt, headFrame)
    local count = GetMerchantNumItems();

    local scale = UIParent:GetEffectiveScale();
    local height = GetScreenHeight() * scale - 30;

    local scrollFrame = CreateFrame("ScrollFrame", nil, nil)
    scrollFrame:SetSize(templateWidht * maxColum * 1.5, height)
    scrollFrame:SetPoint("TOP", headFrame, "BOTTOM", 0, 0);

    local scrollChildFrame = CreateFrame("Frame", nil, scrollFrame)
    scrollFrame:SetScrollChild(scrollChildFrame)
    scrollChildFrame:SetSize(templateWidht * maxColum * 1.5, (templateHeigt * count) / 2);

    return scrollFrame, scrollChildFrame;
end

function MerchantItemContainer:NewTabs(headFrame)
    local frame = CreateFrame("Frame", nil, headFrame, "MerchantTabsFrame1");
    frame:SetPoint("CENTER");
    frame:SetFrameStrata("FULLSCREEN");
    frame.buy:SetHeight(headFrame:GetHeight() - 2);
    frame.rebuy:SetHeight(headFrame:GetHeight() - 2);
    local loseFocusCallback = function()
        MerchantModule:TabLoseFocus();
        MaskFrameModule:SetBackground();
    end
    frame:InitEableGamePadButtonGroup("BuyItem", "group", 1, loseFocusCallback);
    frame:Show();
    return frame;
end
