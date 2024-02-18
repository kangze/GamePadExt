local MerchantModule = Gpe:GetModule('MerchantModule');
local MaskFrameModule = Gpe:GetModule('MaskFrameModule');



function MerchantModule:RegisterMerchantItemGamepadButtonDown(gamePadInitor, buyback)
    gamePadInitor:Register("PADDDOWN,PADDUP,PADDLEFT,PADDRIGHT", function(currentItem, preItem)
        PlaySoundFile("Interface\\AddOns\\GamePadExt\\media\\sound\\1.mp3", "Master");
        MaskFrameModule:TopContent();
        MerchantItemGameTooltip:Hide();
        if (preItem) then
            preItem:SetFrameStrata("HIGH");
            if (preItem.dressUpFrame) then
                preItem.dressUpFrame:Destroy();
                preItem.dressUpFrame = nil;
            end
        end

        if (preItem and preItem.OnLeave) then
            preItem:OnLeave();
        end
        if (currentItem and currentItem.OnEnter) then
            currentItem:OnEnter();
        end
    end);

    --返回上一级菜单
    gamePadInitor:Register("PADSYSTEM", function(...)
        gamePadInitor:Switch(GamePadInitorNames.MerchantTabFrame.Name);
        MaskFrameModule:TopHead();
    end);

    --幻化
    gamePadInitor:Register("PAD4", function(currentItem)
        if (currentItem.dressUpFrame) then
            currentItem.dressUpFrame:Destroy();
            currentItem.dressUpFrame = nil;
        end
        local frame = self:CreateDressUpFrame(currentItem.itemLink);
        frame:Show();
        currentItem.dressUpFrame = frame;
    end)

    --当前商品查看详情
    gamePadInitor:Register("PAD2", function(currentItem)
        --背景设置最高和当前层级设置最高
        MaskFrameModule:SETDIALOG();
        currentItem:SetFrameStrata("DIALOG");
        self:ShowMerchantItemTooltip(currentItem);
    end)

    --购买物品
    gamePadInitor:Register("PAD1", function(currentItem)
        if (buyback) then
            BuybackItem(currentItem.index);
        else
            BuyMerchantItem(currentItem.index, 1);
        end
    end)

    --窗体滚动
    gamePadInitor:Register("PADDDOWN,PADDUP", function(currentItem, preItem)
        self:Scroll(currentItem);
    end);
end

function MerchantModule:RegisterMerchantTabGamepadButtonDown(gamePadInitor)
    gamePadInitor:Register("PADRTRIGGER,PADLTRIGGER", function(currentItem, preItem)
        if (preItem and preItem.OnLeave) then
            preItem:OnLeave();
        end
        if (currentItem and currentItem.OnEnter) then
            currentItem:OnEnter();
        end
        --currentItem 所关联的Frame 进行显示
        if (currentItem.content) then
            currentItem.content:Show();
            currentItem.content:SetAlpha(1);
        end
        if (preItem.content) then
            preItem.content:Hide();
        end
    end); --tab选项选择
    gamePadInitor:Register("PAD1", function(currentItem, preItem)
        gamePadInitor:Switch(currentItem.associateName);
        MaskFrameModule:TopContent();
    end);

    --注册这个框架关闭
    gamePadInitor:Register("PADSYSTEM", function(currentItem, prrItem)
        MerchantFrame:Hide();
        MerchantModule:MERCHANT_CLOSED() --2个gamepadInitor都被关闭了
        gamePadInitor:Destroy();
    end);
end
