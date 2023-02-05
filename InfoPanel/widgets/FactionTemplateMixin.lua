FactionTemplateMixin = {};

function FactionTemplateMixin:OnLoad()
    self.tex_background:SetDrawLayer("BACKGROUND", 0)
    self.tex_icon:SetDrawLayer("BACKGROUND", 1)
    print(self.statusbaar);
    print(self.statusbaar:GetWidth());
    self.statusbaar:SetDrawLayer("BACKGROUND",1);
end


function FactionTemplateMixin:OnEnter()
    print(1);
end