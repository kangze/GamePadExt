CharacterFrameTemplateMixin = {};


function CharacterFrameTemplateMixin:OnLoad()
    local col1Index = 1;
    local col3Index = 1;
    local yOffset = 16;
    local topSpace = -70;
    local cal1xoffSet = 45;
    local col3xOffset = 450;
    for index = 1, #slotNames do
        local itemFrame = CreateFrame("Frame", nil, self.equipment, "GpeEquipmentTemplate");
        itemFrame.col = slotNames[index][2];
        self.equipment[slotNames[index][1]] = itemFrame;
        if (slotNames[index][2] == 1) then
            itemFrame:SetPoint("TOPLEFT", cal1xoffSet,
                topSpace + -1 * (itemFrame:GetHeight() + yOffset) * (col1Index - 1));
            col1Index = col1Index + 1;
        elseif (slotNames[index][2] == 3) then
            itemFrame:SetPoint("TOPLEFT", col3xOffset,
                topSpace + -1 * (itemFrame:GetHeight() + yOffset) * (col3Index - 1));
            itemFrame.ext:ClearAllPoints();
            itemFrame.ext:SetPoint("RIGHT", itemFrame.button, "LEFT", 0, 0);
            itemFrame.ext.name:ClearAllPoints();
            itemFrame.ext.name:SetPoint("TOPRIGHT", itemFrame.ext,"TOPRIGHT",-5,-8);
            itemFrame.ext.name:SetJustifyH("RIGHT");

            -- itemFrame.ext.itemLevel:ClearAllPoints();
            -- itemFrame.ext.itemLevel:SetPoint("BOTTOMRIGHT", itemFrame, "BOTTOMLEFT", -5, 17);
            -- itemFrame.ext.itemLevel:SetJustifyH("RIGHT");
            col3Index = col3Index + 1;
        end
    end
end

function CharacterFrameTemplateMixin:OnSizeChanged()
    self.equipment:SetHeight(self:GetHeight());
    self.equipment:SetWidth(self:GetWidth() / 2.5);

    self.property:SetHeight(self:GetHeight());
    self.property:SetWidth(self:GetWidth() / 8);


    self.property.background1:SetHeight(self:GetHeight() / 2);
    self.property.background1:SetWidth(self.property:GetWidth());

    self.property.background1_title:SetHeight(30);
    self.property.background1_title:SetWidth(self.property:GetWidth());

    self.property.background2:SetHeight(self:GetHeight() / 2);
    self.property.background2:SetWidth(self.property:GetWidth());

    self.property.background2_title:SetHeight(30);
    self.property.background2_title:SetWidth(self.property:GetWidth());


    self.equipment.background_1:SetWidth(self:GetHeight() * 0.7);
    self.equipment.background_1:SetHeight(48);
    self.equipment.background_1:SetRotation(math.rad(90));
end
