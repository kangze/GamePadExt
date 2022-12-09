local addonName, addonTable = ...

local N = {};
addonTable.N = N;

--local GetNamePlateForUnit=GetNamePlateForUnit;

function N:InitNamePlate()
    local GamePadExtAddon=addonTable.GamePadExtAddon;
    GamePadExtAddon:RegisterEvent("NAME_PLATE_UNIT_ADDED",self.Event);
end


function N:Event(...)
    local unitID=...;
    local plate=C_NamePlate.GetNamePlateForUnit(unitID);
    local healthframe = CreateFrame("Frame", nil, plate);
    plate.UnitFrame.healthBar:SetHeight(100);
    healthframe:SetSize(109, 32);
    healthframe:SetPoint("CENTER",7,7);
    healthframe:SetFrameStrata("TOOLTIP");
    healthframe.tex2 = healthframe:CreateTexture();
    healthframe.tex2:SetAllPoints(healthframe);
    healthframe.tex2:SetTexture("Interface/CustomMaterials/BlizzardPlates-Border", "CLAMPTOWHITE");
    healthframe.tex2:SetSize(109, 32);
    healthframe.tex2:SetTexCoord(0.01, 0.99, 0, 1);
end