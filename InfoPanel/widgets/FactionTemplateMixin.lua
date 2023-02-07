FactionTemplateMixin = {};

function FactionTemplateMixin:OnLoad()
    self.tex_background:SetDrawLayer("BACKGROUND", 0)
    self.tex_icon:SetDrawLayer("BACKGROUND", 1)
end


function FactionTemplateMixin:OnEnter()
    GpeGameTooltip:ClearAllPoints();
    GpeGameTooltip:SetOwner(self, "ANCHOR_NONE",0);
    GpeGameTooltip:SetPoint("LEFT",self,"RIGHT",0,0);
    GpeGameTooltip:AddLine("123456789");
    print(GpeGameTooltip:IsOwned(self));
    -- GameTooltip:AddLine("测试", 1, 1, 1, true);
    -- GameTooltip:Show();
    GpeGameTooltip:Show();
end

function FactionTemplateMixin:OnLeave()
    GpeGameTooltip:Hide();
end