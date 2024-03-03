function RegisterCharacterTabGamepadButtonDown(gamePadInitor)
    gamePadInitor:Register("PADRTRIGGER,PADLTRIGGER", function(currentItem, preItem)
        if (preItem and preItem.OnLeave) then
            preItem:OnLeave();
        end
        if (currentItem and currentItem.OnEnter) then
            currentItem:OnEnter();
        end
        --currentItem 所关联的Frame 进行显示
        if (currentItem.content and currentItem.content.OnEnter) then
            currentItem.content:OnEnter();
        end
        if (preItem.content and preItem.content.OnLeave) then
            preItem.content:OnLeave();
        end
    end); --tab选项选择
    gamePadInitor:Register("PAD1", function(currentItem, preItem)
        gamePadInitor:Switch(currentItem.associateName);
        MaskFrameModule:TopContent();
    end);

    --注册这个框架关闭
    gamePadInitor:Register("PADSYSTEM", function(currentItem, prrItem)
        MerchantModule:CLOSED() --2个gamepadInitor都被关闭了
        gamePadInitor:Destroy();
    end);
end
