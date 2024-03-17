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
        local itemFrame = characterFrame.equipment[slotName];
        itemFrame:SetAttribute("item", itemLink)
        itemFrame.button.icon:SetTexture(itemIcon)
        if (#equipments[index].sockets == 0 and #equipments[index].gems == 0) then
            itemFrame.ext.name:ClearAllPoints();
            itemFrame.ext.name:SetPoint("CENTER", itemFrame.ext, "CENTER", 0, 0);
            itemFrame.ext.name:SetFont("Fonts\\FRIZQT__.TTF", 10);
        elseif (#equipments[index].sockets + #equipments[index].gems >= 3) then
            itemFrame.ext.name:ClearAllPoints();
            itemFrame.ext.name:SetPoint("TOP", itemFrame.ext, "TOP", 5, 5);
            itemFrame.ext.name:SetFont("Fonts\\FRIZQT__.TTF", 9);
        end
        local shortItemLink;
        if (itemLink) then
            shortItemLink = string.gsub(itemLink, "%[", "", 1);
            shortItemLink = string.gsub(shortItemLink, "%]", "", 1);
        end
        itemFrame.ext.name:SetText(shortItemLink);
        itemFrame.ext.itemLevel:SetText(itemLevel);
        itemFrame.itemLink = itemLink;
        self:CreateSocket(itemFrame, equipments[index].sockets);
        self:CreateGems(itemFrame, equipments[index].gems);
        self:CreateEnchant(itemFrame, equipments[index].enchants);
        itemFrame:SetScript("OnEnter", function(selfs)
            GameTooltip:SetOwner(selfs, "ANCHOR_RIGHT");
            GameTooltip:SetHyperlink(selfs.itemLink);
            GameTooltip:Show()
        end)

        self.equipment_gamepadInitor:Add(itemFrame, "group" .. characterFrame.equipment[slotName].col);
    end
    RegisterEquipmentItemGamepadButtonDown(self.equipment_gamepadInitor);
    self.equipment_gamepadInitor:SetRegion(characterFrame);
end

function CharacterModule:CreateSocket(itemFrame, sockets)
    for index = 1, #sockets do
        local socket = CreateFrame("Frame", nill, itemFrame.ext, "GpeSocketTemplate");
        socket:ClearAllPoints();
        socket:SetPoint("LEFT", itemFrame.ext, "LEFT", 5, -4);
        socket.text:SetText(sockets[index].leftText);
        socket:SetSocket(sockets[index].socketType);
    end
end

function CharacterModule:CreateGems(itemFrame, gems)
    for index = 1, #gems do
        local gem = CreateFrame("Frame", nill, itemFrame, "GpeGemTemplate");
        gem:ClearAllPoints();
        gem:SetPoint("TOPLEFT", itemFrame.ext, "TOPLEFT", 5, -6 + (index - 1) * -12);
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
    local properties = CharacterCore_GetEnchantProperties();
    local offsetTopY = -45;
    local offsetY = -60; ---60
    for index = 1, #properties do
        local propertyItemFrame = CreateFrame("Frame", nil, propertyFrame, "PropertyItemTemplate");
        propertyItemFrame.propertyName:SetText(properties[index].name);
        propertyItemFrame.propertyValue:SetText(BreakUpLargeNumbers(properties[index].value) .. "%");
        propertyItemFrame.propertyTooltip:SetText(properties[index].tooltip);
        propertyItemFrame:SetPoint("TOPLEFT",propertyFrame.background2,"TOPLEFT", 0, offsetY * (index - 1) + offsetTopY);
    end
end
