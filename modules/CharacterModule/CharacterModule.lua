local _, AddonData = ...;
local Gpe = _G["Gpe"];

local Masque, MSQ_Version = LibStub("Masque", true);
local CharacterModule = Gpe:GetModule('CharacterModule');

local MaskFrameModule = Gpe:GetModule('MaskFrameModule');

function CharacterModule:OnInitialize()

end

function CharacterModule:OnEnable()
    --初始化tab栏位

    HeaderRegions:Register("CharacterFrameHeader", CharacterFrameTabActiveCallBack, nil);
    self:Show();
end

function CharacterModule:Show()
    --顶部菜单开始激活
    MaskFrameModule:Active("CharacterFrameHeader");
    CharacterModule:InitEquipment();
end

function CharacterModule:InitEquipment()
    self.equipment_gamepadInitor = GamePadInitor:Init(GamePadInitorNames.CharacterEquipmentFrame.Name,
        GamePadInitorNames.CharacterEquipmentFrame.Level);
    local characterFrame = CreateFrame("Frame", nil, nil, "CharacterFrameTemplate");
    --TODO:还未做
    local equipments = CharacterCore_GetEquipments();
    for index = 1, #equipments do
        local slotName = equipments[index].slotName;
        local texture = equipments[index].texture;
        local itemLink = equipments[index].itemLink;

        characterFrame[slotName].name:SetText(itemLink);
        characterFrame[slotName].icon:SetTexture(texture);
        characterFrame[slotName].itemLink = itemLink;
        self.equipment_gamepadInitor:Add(characterFrame[slotName], "group" .. characterFrame[slotName].col);
    end
    self.equipment_gamepadInitor:SetRegion(characterFrame);
end
