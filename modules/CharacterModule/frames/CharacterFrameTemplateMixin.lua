CharacterFrameTemplateMixin = {};


function CharacterFrameTemplateMixin:OnLoad()
    local col1Index = 1;
    local col3Index = 1;
    local yOffset = 16;
    local topSpace = -60;
    local cal1xoffSet = 20;
    local col3xOffset = 360;
    for index = 1, #slotNames do
        local itemButton = CreateFrame("ItemButton", nil, self, "GpeEquipmentTemplate");
        itemButton.col = slotNames[index][2];
        self[slotNames[index][1]] = itemButton;
        if (slotNames[index][2] == 1) then
            itemButton:SetPoint("TOPLEFT", cal1xoffSet, topSpace + -1 * (itemButton:GetHeight() + yOffset) * (col1Index - 1));
            col1Index = col1Index + 1;
        elseif (slotNames[index][2] == 3) then
            itemButton:SetPoint("TOPLEFT", col3xOffset, topSpace + -1 * (itemButton:GetHeight() + yOffset) * (col3Index - 1));
            col3Index = col3Index + 1;
        end
    end
end
