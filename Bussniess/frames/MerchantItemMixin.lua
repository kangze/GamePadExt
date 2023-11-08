local _, AddonData = ...;
MerchantItemMixin = {};


function MerchantItemMixin:OnLoad()
    AddonData.ShadowFunctions.Create(self);
    _G.test = self;
end

function MerchantItemMixin:OnLeave()
    self.shadow.animation2:Show();
end

function MerchantItemMixin:OnEnter()
    self.shadow.animation:Show();
end

function MerchantItemMixin:CreateEnterAnimation()
        local function callback(total)
        local alpha = linear(total, 3, 8, 0.5);
        print(alpha);
        shadow:ClearBackdrop();
        shadow:SetBackdrop({ edgeFile = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\GlowTex", edgeSize = alpha })
        SetOutside(shadow, frame, alpha - 1, alpha - 1);
        shadow:SetBackdropColor(0, 0, 0, 0)
        shadow:SetBackdropBorderColor(0, 0, 0, 1);
        if (total >= duration or endAlpha == 0) then
            frame:Hide();
        end
    end
end
