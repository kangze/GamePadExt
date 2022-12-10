local addonName, addonTable = ...

local N = {};
addonTable.N = N;

--local GetNamePlateForUnit=GetNamePlateForUnit;

function N:InitNamePlate()
    local GamePadExtAddon=addonTable.GamePadExtAddon;
    GamePadExtAddon:RegisterEvent("NAME_PLATE_UNIT_ADDED",self.NAME_PLATE_UNIT_ADDED);
    GamePadExtAddon:RegisterEvent("NAME_PLATE_UNIT_REMOVED",self.NAME_PLATE_UNIT_REMOVED);
    --var s="PLAYER_TARGET_CHANGED";
    C_CVar.SetCVar("NamePlateHorizontalScale",1.2);
    C_CVar.SetCVar("NamePlateVerticalScale",2.7);
end


function N:NAME_PLATE_UNIT_ADDED(...)
    local unitID=...;
    local plate=C_NamePlate.GetNamePlateForUnit(unitID);
    local level=UnitLevel(unitID);
    if(plate.gpe_healthbarborder~=nil) then
        plate.gpe_healthbarborder.levelfont:SetText(level);
        return;
    end
    local width=plate.UnitFrame.healthBar.border:GetWidth();
    width=width+width*0.21;
    local height=plate.UnitFrame.healthBar.border:GetHeight();
    height=height+4;
    plate.UnitFrame.healthBar.border:Hide();

    --plate.UnitFrame.castBar:SetSize(width,height);
    
    --create nameplate_healther_border frame
    local healthbarborder = CreateFrame("Frame", nil, plate.UnitFrame.healthBar);
    healthbarborder:SetSize(width, height);
    healthbarborder:SetPoint("CENTER",10,-1);
    

    --plate.UnitFrame.castBar:SetPoint("TOP",healthbarborder,0,0)
    --create texture
    local tex = healthbarborder:CreateTexture();
    tex:SetAllPoints(healthbarborder);
    tex:SetTexture("Interface/CustomMaterials/BlizzardPlates-Border", "CLAMPTOWHITE");
    tex:SetSize(width, height);
    tex:SetAllPoints(healthbarborder);
    tex:SetTexCoord(0.01, 0.99, 0.55, 1);
    healthbarborder.tex=tex;

    --create nameplate level fontstring
    local levelfont=healthbarborder:CreateFontString(nil, "OVERLAY", "GameTooltipText");
    levelfont:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
    levelfont:SetText(level);
    levelfont:SetPoint("RIGHT",-2,2);
    levelfont:SetTextColor(1, 0.5, 0.25, 1.0);
    healthbarborder.levelfont=levelfont;
    
    plate.gpe_healthbarborder=healthbarborder;
end

function N:NAME_PLATE_UNIT_REMOVED(...)
    local unitID=...;
    local plate=C_NamePlate.GetNamePlateForUnit(unitID);
end