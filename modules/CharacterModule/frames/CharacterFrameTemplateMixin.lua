CharacterFrameTemplateMixin = {};


function CharacterFrameTemplateMixin:OnLoad()
    local col1Index = 1;
    local col3Index = 1;
    local yOffset = 16;
    local topSpace = -100;
    local cal1xoffSet = 80;
    local col3xOffset = 500;
    for index = 1, #slotNames do
        local itemButton = CreateFrame("ItemButton", nil, self, "GpeEquipmentTemplate");
        itemButton.col = slotNames[index][2];
        self[slotNames[index][1]] = itemButton;
        if (slotNames[index][2] == 1) then
            itemButton:SetPoint("TOPLEFT", cal1xoffSet,
                topSpace + -1 * (itemButton:GetHeight() + yOffset) * (col1Index - 1));
            col1Index = col1Index + 1;
        elseif (slotNames[index][2] == 3) then
            itemButton:SetPoint("TOPLEFT", col3xOffset,
                topSpace + -1 * (itemButton:GetHeight() + yOffset) * (col3Index - 1));
            itemButton.name:ClearAllPoints();
            itemButton.name:SetPoint("BOTTOMRIGHT", itemButton, "BOTTOMLEFT", -5, 0);
            itemButton.name:SetJustifyH("RIGHT");

            itemButton.itemLevel:ClearAllPoints();
            itemButton.itemLevel:SetPoint("BOTTOMRIGHT", itemButton, "BOTTOMLEFT", -5, 17);
            itemButton.itemLevel:SetJustifyH("RIGHT");
            col3Index = col3Index + 1;
        end
    end
end
