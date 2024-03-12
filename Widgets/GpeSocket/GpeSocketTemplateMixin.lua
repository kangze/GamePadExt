GpeSocketTemplateMixin = {};


local width=12;
local height=12;
local fontSize=8;



local socketTypeMap={
    PunchcardRed="punchcard-red",
    PunchcardBlue="punchcard-blue",
    PunchchardYellow="punchcard-yellow",
    Prismatic="prismatic",
}

function GpeSocketTemplateMixin:OnLoad()
    self:SetSize(width, height);
    self.iconBackground:SetSize(width, height);
    self.iconBorder:SetSize(width, height);
    self.text:SetFont("Fonts\\FRIZQT__.TTF", fontSize, "OUTLINE");
end

function GpeSocketTemplateMixin:SetSocket(socketType)
    self.iconBackground:SetAtlas("socket-" .. socketTypeMap[socketType] .. "-background");
    self.iconBorder:SetAtlas("socket-" .. socketTypeMap[socketType] .. "-open");
end