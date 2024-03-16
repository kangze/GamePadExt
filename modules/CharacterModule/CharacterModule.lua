local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local CharacterModule = Gpe:GetModule('CharacterModule');

local MaskFrameModule = Gpe:GetModule('MaskFrameModule');

function CharacterModule:OnInitialize()
    self:RegisterEvent("UI_ERROR_MESSAGE");
end

function CharacterModule:OnEnable()
    --初始化tab栏位
    HeaderRegions:Register("CharacterFrameHeader", CharacterFrameTabActiveCallBack, nil);
end

function CharacterModule:UI_ERROR_MESSAGE()
    MaskFrameModule:Active("CharacterFrameHeader");

    self.equipment_gamepadInitor = GamePadInitor:Init(GamePadInitorNames.CharacterEquipmentFrame.Name,
        GamePadInitorNames.CharacterEquipmentFrame.Level);
    local characterFrame = CreateFrame("Frame", nil, nil, "CharacterFrameTemplate");
    characterFrame:SetAllPoints(MaskFrameModule.bodyFrame);

    CharacterModule:InitEquipment(characterFrame);
    CharacterModule:InitProperty(characterFrame);
end

function CharacterModule:InitEquipment(characterFrame)
    --TODO:还未做

    local equipments = CharacterCore_GetEquipments();
    for index = 1, #equipments do
        local slotName = equipments[index].slotName;
        local texture = equipments[index].texture;
        local itemLink = equipments[index].itemLink;
        local itemLevel = equipments[index].itemLevel;
        local itemIcon;
        if (itemLink) then
            itemIcon = GetItemIcon(itemLink);
        else
            itemIcon = texture;
        end
        local itemButton = characterFrame.equipment[slotName];
        itemButton:SetAttribute("item", itemLink)
        itemButton.icon:SetTexture(itemIcon)
        itemButton.name:SetText(itemLink);
        itemButton.itemLevel:SetText(itemLevel);
        itemButton.itemLink = itemLink;
        self:CreateSocket(itemButton, equipments[index].sockets);
        self:CreateGems(itemButton, equipments[index].gems);
        self:CreateEnchant(itemButton, equipments[index].enchants);
        itemButton:SetScript("OnEnter", function(selfs)
            GameTooltip:SetOwner(selfs, "ANCHOR_RIGHT");
            GameTooltip:SetHyperlink(selfs.itemLink);
            GameTooltip:Show()
        end)

        self.equipment_gamepadInitor:Add(itemButton, "group" .. characterFrame.equipment[slotName].col);
    end
    RegisterEquipmentItemGamepadButtonDown(self.equipment_gamepadInitor);
    self.equipment_gamepadInitor:SetRegion(characterFrame);
end

function CharacterModule:CreateSocket(itemButton, sockets)
    for index = 1, #sockets do
        local socket = CreateFrame("Frame", nill, itemButton, "GpeSocketTemplate");
        socket:ClearAllPoints();
        socket:SetPoint("RIGHT", itemButton, "LEFT", 0, 0);
        socket.text:SetText(sockets[index].leftText);
        socket:SetSocket(sockets[index].socketType);
    end
end

function CharacterModule:CreateGems(itemButton, gems)
    for index = 1, #gems do
        local gem = CreateFrame("Frame", nill, itemButton, "GpeGemTemplate");
        gem:ClearAllPoints();
        gem:SetPoint("RIGHT", itemButton, "LEFT", 0, 0);
        gem:SetGem(gems[index].gemLink);
    end
end

function CharacterModule:CreateEnchant(itemButton, enchants)
    for index = 1, #enchants do
        print(enchants[index]);
    end
end

function CharacterModule:InitProperty(characterFrame)
    local propertyFrame = characterFrame.property;
    local properties = CharacterCore_GetEnchantProperties()

    for index=1, #properties do
        local propertyFrame = CreateFrame("Frame", nil, propertyFrame, "PropertyItemTemplate");
        propertyFrame.propertyName:SetText(properties[index].name);
        propertyFrame.propertyValue:SetText(properties[index].value);
        propertyFrame:SetPoint("TOPLEFT", 0, -30 * (index - 1));
    end
end
