local _,Addon=...;

local PlaySound=PlaySound;
local CreateFrame=CreateFrame;

local Expansion={};

local Focus=function (self,index)
    PlaySound(852);
    if(self.index==index) then
        self.tex_highlight:Show();
        self.tex_selectedGlow:Show();
    else
        self.tex_highlight:Hide();
        self.tex_selectedGlow:Hide();
    end
end

function Expansion:Create(config)
    local index,name,factionIds=config.index,config.name,config.factionIds;
    local frame = CreateFrame("Frame");
    frame:SetSize(265, 45);

    frame.index=index;
    frame.factionIds=factionIds;

    frame.tex_background = frame:CreateTexture();
    frame.tex_background:SetAtlas("Campaign_Dragonflight");
    frame.tex_background:SetAllPoints();

    frame.tex_highlight = frame:CreateTexture();
    frame.tex_highlight:SetAtlas("Campaign_Dragonflight");
    frame.tex_highlight:SetAllPoints();
    frame.tex_highlight:Hide(); -- highlight

    -- factionItemFrame.tex_highlight = factionItemFrame:CreateTexture();
    -- factionItemFrame.tex_highlight:SetTexture("Interface/QuestFrame/UI-QuestLogTitleHighlight", "CLAMP");
    -- factionItemFrame.tex_highlight:SetBlendMode("BLEND");
    -- factionItemFrame.tex_highlight:SetSize(265, 47);
    -- factionItemFrame.tex_highlight:SetTexCoord(0.2,0.8,1,0);
    -- factionItemFrame.tex_highlight:SetVertexColor(HIGHLIGHT_LIGHT_BLUE:GetRGB());
    -- factionItemFrame.tex_highlight:SetPoint("TOPLEFT",factionItemFrame);
    -- factionItemFrame.tex_highlight:Hide();

    frame.tex_selectedGlow = frame:CreateTexture();
    frame.tex_selectedGlow:SetAtlas("CampaignHeader_SelectedGlow");
    frame.tex_selectedGlow:SetBlendMode("ADD");
    frame.tex_selectedGlow:SetPoint("TOPLEFT", 0, -3);
    frame.tex_selectedGlow:SetSize(265, 45);
    frame.tex_selectedGlow:Hide(); -- selected


    frame.font_name = frame:CreateFontString(nil, "OVERLAY", "GameTooltipText");
    frame.font_name:SetPoint("CENTER");
    frame.font_name:SetText(name);
    frame:SetScript("OnEnter", function(selfs, arg)
        selfs:Focus(selfs.index);
        --DEMO:
        -- local animationGroup=selfs:CreateAnimationGroup();
        -- local tran1=animationGroup:CreateAnimation("translation");
        -- tran1:SetDuration(1);
        -- tran1:SetOrder(1);
        -- tran1:SetOffset(0, -8);
        -- animationGroup:Play();

        -- local al = UIParentAlphaAnimtationFrame.New(0.5);
        -- al:Show();
    end);

    frame:SetScript("OnLeave", function(selfs, arg)
        selfs:Focus(nil);
    end);
    -- expansionContainerFrame.total = expansionContainerFrame.total + 1;
    -- table.insert(expansionContainerFrame.items, frame);

    frame.Focus=Focus;
    return frame;
end

Addon.Expansion=Expansion;