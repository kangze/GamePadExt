local addonName, addonTable = ...;
local H                     = addonTable.H;
local PlayerName            = PlayerName;
local HealthBar             = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar;

function H:InitHeaderExt()
    local db = addonTable.D;
    self:SetPlayerNameSize(db.profile.headerExt.playerExt.namefontsize);
    self:SetPlayerHealthStatusText(db.profile.headerExt.playerExt.healthfontsize);
end

function H:SetPlayerNameSize(size)
    PlayerName:SetFont("Fonts\\FRIZQT__.TTF", size, "OUTLINE");
end

function H:SetPlayerHealthStatusText(size)
    if (HealthBar.LeftText) then
        HealthBar.LeftText:SetFont("Fonts\\FRIZQT__.TTF", size, "");
    end
    if (HealthBar.RightText) then
        HealthBar.RightText:SetFont("Fonts\\FRIZQT__.TTF", size, "");
    end
    if (HealthBar.TextString) then
        HealthBar.TextString:SetFont("Fonts\\FRIZQT__.TTF", size, "");
    end
end
