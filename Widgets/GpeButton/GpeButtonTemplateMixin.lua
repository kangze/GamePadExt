local _, AddonData = ...;


GpeButtonTemplateMixin = {};

local shadow_animation = function(frame)
    return function(current)
        frame:SetShadowSize(current);
    end
end

local default_text = "按钮";
local default_shadow = false;
local default_status = true;
local default_color = { r = 0.490, g = 0.345, b = 0.525, a = 1 };
local default_disable_ratio = 0.65;

function GpeButtonTemplateMixin:OnLoad_Intrinsic(buttonText)
    if (buttonText) then
        self.buttonText = buttonText;
    end
    self.text:SetText(self.buttonText);
    self.background:SetColorTexture(default_color.r, default_color.g, default_color.b, default_color.a);
    self:AppendShadow(2, nil);
    self.enter_shadowAinimation = Animation:new(0.3, 2, 10, shadow_animation(self), nil, EasingFunctions.OutSine);
    self.leave_shadowAinimation = Animation:new(0.3, 10, 2, shadow_animation(self), nil, EasingFunctions.OutSine);
end

function GpeButtonTemplateMixin:OnLeave_Intrinsic()
    self.leave_shadowAinimation:Play();
end

function GpeButtonTemplateMixin:OnEnter_Intrinsic()
    self.enter_shadowAinimation:Play();
    print(self.buttonText);
    print("我进入了")
end

function GpeButtonTemplateMixin:OnEnable()
    self:SetAlpha(1);
end

function GpeButtonTemplateMixin:OnDisable()
    self:SetAlpha(default_disable_ratio);
end
