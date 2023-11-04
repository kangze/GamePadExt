local _, AddonData = ...;
local Gpe = _G["Gpe"];

local NamePlateModule = Gpe:GetModule('NamePlateModule')


function NamePlateModule:OnInitialize()
    local config = {
        profile = {
            namePlate = {
                style = {
                    show_old_blizzard_border = true,
                }
            }
        },
        options = {
            nameplate = {
                name = "姓名版",
                type = "group",
                args = {
                    showBlizzardBorder = {
                        name = "老版",
                        type = "toggle",
                        set = function(info, value)
                            local db = AddonData.db;
                            db.profile.namePlate.style.show_old_blizzard_border = value;
                        end,
                        get = function(info)
                            local db = AddonData.db;
                            return db.profile.namePlate.style.show_old_blizzard_border;
                        end,
                    }
                }
            }
        }
    };
    Gpe:RegisterConfig(config);
end

function NamePlateModule:OnEnable()
    local db=AddonData.db;
    if (db.profile.namePlate.style.show_old_blizzard_border) then
        self:RegisterEvent("NAME_PLATE_UNIT_ADDED", self.NAME_PLATE_UNIT_ADDED);
        self:RegisterEvent("NAME_PLATE_UNIT_REMOVED", self.NAME_PLATE_UNIT_REMOVED);
        hooksecurefunc(SettingsRegistrar, "OnLoad", function()
            VARIABLES_LOADED();
        end);
    end


    --GamePadExtAddon:RegisterEvent("VARIABLES_LOADED", self.VARIABLES_LOADED);
    --GamePadExtAddon:RegisterEvent("PLAYER_ENTERING_WORLD",self.VARIABLES_LOADED);
end

function NamePlateModule:NAME_PLATE_UNIT_ADDED(...)
    local unitID = ...;
    local plate = C_NamePlate.GetNamePlateForUnit(unitID);
    if (plate == nil) then return; end

    local level = UnitLevel(unitID);
    if (plate.gpe_healthbarborder ~= nil) then
        plate.gpe_healthbarborder.levelfont:SetText(level);
        return;
    end

    local width = plate.UnitFrame.healthBar.border:GetWidth();
    width = width + width * 0.21;
    local height = plate.UnitFrame.healthBar.border:GetHeight();
    height = height + 4;
    plate.UnitFrame.healthBar.border:Hide();
    local healthbarborder = CreateFrame("Frame", nil, plate.UnitFrame.healthBar);
    healthbarborder:SetSize(width, height);
    healthbarborder:SetPoint("CENTER", 10, -1);

    --create texture
    local tex = healthbarborder:CreateTexture();
    tex:SetAllPoints(healthbarborder);
    tex:SetTexture("Interface/CustomMaterials/BlizzardPlates-Border", "CLAMPTOWHITE");
    tex:SetSize(width, height);
    tex:SetAllPoints(healthbarborder);
    tex:SetTexCoord(0.01, 0.99, 0.55, 1);
    healthbarborder.tex = tex;

    --create nameplate level fontstring
    local levelfont = healthbarborder:CreateFontString(nil, "OVERLAY", "GameTooltipText");
    levelfont:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
    levelfont:SetText(level);
    levelfont:SetPoint("RIGHT", -4, 1);
    levelfont:SetTextColor(1, 0.5, 0.25, 1.0);
    healthbarborder.levelfont = levelfont;

    plate.gpe_healthbarborder = healthbarborder;
end

function NamePlateModule:NAME_PLATE_UNIT_REMOVED(...)
    local unitID = ...;
    local plate = C_NamePlate.GetNamePlateForUnit(unitID);
end

function VARIABLES_LOADED()
    --big nameplate settings
    SetCVar("NamePlateHorizontalScale", 1.2);
    SetCVar("NamePlateVerticalScale", 2.7);
    SetCVar("NamePlateClassificationScale", 1.25);
    SetCVar("nameplateMaxAlpha", 0.65);
    SetCVar("nameplateSelectedAlpha", 1);
    SetCVar("nameplateMinScale", 1.2);
    SetCVar("nameplateMinAlpha", 0.5);
    SetCVar("nameplateMaxAlpha", 0.5);
end
