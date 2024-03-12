GpeGemTemplateMixin = {};


local width = 12;
local height = 12;
local fontSize = 8;

function GpeGemTemplateMixin:OnLoad()
    self:SetSize(width, height);
    self.icon:SetSize(width, height);
    self.text:SetFont("Fonts\\FRIZQT__.TTF", fontSize, "OUTLINE");
end

function GpeGemTemplateMixin:SetGem(gemLink)
    self.icon:SetTexture(GetItemIcon(gemLink));
    self.text:SetText(gemLink);
end
