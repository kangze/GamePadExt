local _, AddonData = ...;


GpeButtonTemplateMixin = {};


--[[
        text:按钮的文本
        shadow:启用显示阴影,以及阴影动画效果
        status:启用按钮状态,分别是OnEnable,OnDisable

]]

local default_text = "按钮";
local default_shadow = false;
local default_status = true;
local default_color = { r = 0.490, g = 0.345, b = 0.525, a = 1 };
local default_disable_ratio = 0.65;

function GpeButtonTemplateMixin:OnLoad()
    self.buttonText = self.buttonText or default_text;
    self.shadow = self.shadow or default_shadow;
    self.status = self.status or default_status;
    self.color = self.color or default_color;

    self.text:SetText(self.buttonText);
    if (self.shadow and self.GetShadowOptions) then
        self:InitShadowAndAnimation(self:GetShadowOptions());
    end
    self.background:SetColorTexture(self.color.r, self.color.g, self.color.b, self.color.a);
end

function GpeButtonTemplateMixin:OnLeave()
    if (self.shadow) then
        self:ShowShadowFadeOut();
    end

    if (self.status) then
        self:OnDisable();
    end
end

function GpeButtonTemplateMixin:OnEnter()
    if (self.shadow) then
        self:ShowShadowFadeIn();
    end
    if (self.status) then
        self:OnEnable();
    end
end

function GpeButtonTemplateMixin:OnEnable()
    --self.background:SetColorTexture(self.color.r, self.color.g, self.color.b, self.color.a);
    self:SetAlpha(1);
end

function GpeButtonTemplateMixin:OnDisable()
    --self.background:SetColorTexture(self.color.r, self.color.g, self.color.b, self.color.a * default_disable_ratio);
    self:SetAlpha(default_disable_ratio);
end
