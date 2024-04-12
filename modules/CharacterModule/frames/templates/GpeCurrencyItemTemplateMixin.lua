GpeCurrencyItemTemplateMixin = {};

function GpeCurrencyItemTemplateMixin:OnLoad()
end

function GpeCurrencyItemTemplateMixin:OnEnter()
    self.background:SetAtlas("dragonflight-landingpage-renownbutton-tuskarr-hover");
end

function GpeCurrencyItemTemplateMixin:OnLeave()
    self.background:SetAtlas("dragonflight-landingpage-renownbutton-tuskarr");
end
