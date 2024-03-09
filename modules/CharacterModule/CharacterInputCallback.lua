local MaskFrameModule = Gpe:GetModule('MaskFrameModule');


--可以重复利用
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
        print(currentItem.associateName);
        gamePadInitor:Switch(currentItem.associateName);
        MaskFrameModule:TopContent();
    end);

    --注册这个框架关闭
    gamePadInitor:Register("PADSYSTEM", function(currentItem, prrItem)
        MerchantModule:CLOSED();
        gamePadInitor:Destroy();
    end);
end

function RegisterEquipmentItemGamepadButtonDown(gamePadInitor)
    gamePadInitor:Register("PADDDOWN,PADDUP,PADDLEFT,PADDRIGHT", function(currentItem, preItem)
        PlaySoundFile("Interface\\AddOns\\GamePadExt\\media\\sound\\1.mp3", "Master");
        if (preItem and preItem.OnLeave) then
            preItem:OnLeave();
        end
        if (currentItem and currentItem.OnEnter) then
            currentItem:OnEnter();
        end
    end);

    --返回上一级菜单
    gamePadInitor:Register("PADSYSTEM", function(currentItem)
        gamePadInitor:Switch(GamePadInitorNames.CharacterTabFrame.Name);
        MaskFrameModule:TopHead();
    end);
end
