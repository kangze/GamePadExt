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
    CharacterModule:InitEquipment();
end

function CharacterModule:InitEquipment()
    self.equipment_gamepadInitor = GamePadInitor:Init(GamePadInitorNames.CharacterEquipmentFrame.Name,
        GamePadInitorNames.CharacterEquipmentFrame.Level);
    local characterFrame = CreateFrame("Frame", nil, nil, "CharacterFrameTemplate");
    characterFrame:SetAllPoints(MaskFrameModule.bodyFrame);
    --TODO:还未做

    local equipments = CharacterCore_GetEquipments();
    for index = 1, #equipments do
        local slotName = equipments[index].slotName;
        local texture = equipments[index].texture;
        local itemLink = equipments[index].itemLink;
        local itemIcon = GetItemIcon(equipments[index].itemLink);
        local itemButton = characterFrame[slotName];
        itemButton:SetAttribute("item", itemLink)
        itemButton.icon:SetTexture(itemIcon)
        itemButton.name:SetText(itemLink);
        itemButton.itemLink = itemLink;
        itemButton:SetScript("OnEnter", function(selfs)
            GameTooltip:SetOwner(selfs, "ANCHOR_RIGHT");
            GameTooltip:SetHyperlink(selfs.itemLink);
            GameTooltip:Show()
        end)

        self.equipment_gamepadInitor:Add(itemButton, "group" .. characterFrame[slotName].col);
    end
    RegisterEquipmentItemGamepadButtonDown(self.equipment_gamepadInitor);
    self.equipment_gamepadInitor:SetRegion(characterFrame);
end
