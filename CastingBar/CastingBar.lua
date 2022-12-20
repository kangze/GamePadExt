local _, Addon = ...;



function Addon:InitConfig_CastingBar()
    local config = {
        default_profile = {
            castingBar = {
                style = {
                    width = 255,
                    height = 12,
                    icon = true,
                    iconWidth = 24,
                }
            }
        }
    }
    self:RegisterConfig(config);
end

function Addon:OnLoad_CastingBar()
    local style=self.db.profile.castingBar.style;
    local width, height, icon, iconWidth = style.width,style.height,style.icon,style.iconWidth;
    PlayerCastingBarFrame:HookScript("OnEvent", function(arg)
        arg.Text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE");
        arg.Text:SetPoint("TOP", 0, -12);
        arg:SetHeight(height);
        arg:SetWidth(width);
        if (icon) then
            arg.Icon:Show();
            arg.Icon:SetWidth(iconWidth);
            arg.Icon:SetHeight(iconWidth);
            arg.Icon:ClearAllPoints();
            arg.Icon:SetPoint("RIGHT", arg, "LEFT", 0, -4);
        end
    end);
end
