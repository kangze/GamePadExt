local MerchantModule = Gpe:GetModule('MerchantModule');
local MaskFrameModule = Gpe:GetModule('MaskFrameModule');




function RegisterMerchantItemGamepadButtonDown(gamePadInitor, buyback)
    gamePadInitor:Register("PADDDOWN,PADDUP,PADDLEFT,PADDRIGHT", function(currentItem, preItem)
        PlaySoundFile("Interface\\AddOns\\GamePadExt\\media\\sound\\1.mp3", "Master");
        MaskFrameModule:TopContent();
        MerchantItemGameTooltip:Hide();
        MerchantModule:MerchantItemTryMogHide();
        if (preItem and preItem.OnLeave) then
            preItem:OnLeave();
        end
        if (currentItem and currentItem.OnEnter) then
            currentItem:OnEnter();
        end
    end);

    --返回上一级菜单
    gamePadInitor:Register("PADSYSTEM", function(currentItem)
        gamePadInitor:Switch(GamePadInitorNames.MerchantTabFrame.Name);
        MaskFrameModule:TopHead();
    end);

    --幻化
    gamePadInitor:Register("PAD4", function(currentItem)
        MerchantModule:MerchantItemTryMog(currentItem);
    end)

    --当前商品查看详情
    gamePadInitor:Register("PAD2", function(currentItem)
        --校验是否开启了详情
        if (currentItem.opendetail) then
            MaskFrameModule:TopContent();
            MerchantItemGameTooltip:Hide();
            currentItem.opendetail = false;
            return;
        end

        --背景设置最高和当前层级设置最高
        MaskFrameModule:SETDIALOG();
        currentItem:SetFrameStrata("DIALOG");
        MerchantModule:ShowMerchantItemTooltip(currentItem);
        currentItem.opendetail = true;
    end)

    --购买物品/买回物品
    gamePadInitor:Register("PAD1", function(currentItem)
        MerchantModule:MerchantItemBuyOrBuyback(currentItem);
    end)

    --窗体滚动
    gamePadInitor:Register("PADDDOWN,PADDUP", function(currentItem, preItem)
        MerchantModule:Scroll(currentItem);
    end);
end

function RegisterMerchantTabGamepadButtonDown(gamePadInitor)
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
