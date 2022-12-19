
local frame=CreateFrame("Frame",nil,UIParent);
frame:EnableGamePadButton(true);
frame:SetAllPoints();

local arrs={
    {
        item=nil,
        item1=nil,
    },
    {
        item=nil,
        item1=nil,
    },
    {
        item=nil,
        item1=nil,
    },
    {
        item=nil,
        item1=nil,
    },
    {
        item=nil,
        item1=nil,
    },
    {
        item=nil,
        item1=nil,
    },
    {
        item=nil,
        item1=nil,
    },
    {
        item=nil,
        item1=nil,
    },
    {
        item=nil,
        item1=nil,
    },
    {
        item=nil,
        item1=nil,
    }
}

local index=1;
local len=#arrs;
local last1=nil;
local last2=nil;
frame:SetScript("OnGamePadButtonDown",function (arg1,key)
    index=index%len;
    if(index==0) then
        index=1;
    end
    print(index);
    if(key=="PADDDOWN") then
       if(last1) then
        last1:Hide();
        last2:Hide();
       end
       arrs[index].item1:Show();
       arrs[index].item:Show();
       last1=arrs[index].item1;
       last2=arrs[index].item;
       index=index+1;
    end
    return false;
end)




local with=60;
local span=5;
for i=1,len do
    local tex=frame:CreateTexture();
    tex:SetAtlas("Campaign_Dragonflight");
    tex:SetPoint("TOPLEFT",0,(i-1)*-(with+span));
    tex:SetSize(265,with);

    local tex2=frame:CreateTexture();
    tex2:SetTexture("Interface/QuestFrame/UI-QuestLogTitleHighlight","CLAMP");
    tex2:SetBlendMode("ADD");
    tex2:SetAllPoints(tex);
    tex2:SetSize(265,with);
    arrs[i].item1=tex2;
    tex2:Hide();
    
    local tex1=frame:CreateTexture();
    tex1:SetAtlas("CampaignHeader_SelectedGlow");
    tex1:SetPoint("TOPLEFT",0,(i-1)*-(with+span));
    tex1:SetSize(265,with);
    tex1:Hide();
    arrs[i].item=tex1;
end