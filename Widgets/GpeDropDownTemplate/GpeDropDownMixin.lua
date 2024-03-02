GpeDropDownMixin = {};

local config = {
    width = 150,
    height = 45,
    itemWidth = 100,
    itemHeight = 15
}

local enter_shadow_animation = function(frame)
    return function(current)
        frame:SetShadowSize(current);
    end
end

function GpeDropDownMixin:OnLoad()
    self:SetSize(config.width, config.height);
    self.container:SetSize(config.itemWidth, 0);
    self:AppendShadow(2, nil);
    self.enter_shadowAinimation = Animation:new(0.3, 2, 10, enter_shadow_animation(self), nil, EasingFunctions.OutSine);
end

function GpeDropDownMixin:OnEnter()
    self.enter_shadowAinimation:Play();
end

function GpeDropDownMixin:OnLeave()
    self.enter_shadowAinimation:PlayReverse();
end

--展开子选项面板
function GpeDropDownMixin:Expand()
    self.container:Show();
end

--添加项
function GpeDropDownMixin:AddItem(item)
    local width, height = self.container:GetSize();
    height = height + config.itemHeight;
    self.container:SetSize(width, height);
    local frame = CreateFrame("Frame", nil, self.container, "GpeDropDownItemTemplate");
    frame.text:SetText(item.text);
end
