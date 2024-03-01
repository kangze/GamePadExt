GpeDropDownMixin = {};


function GpeDropDownMixin:OnLoad()

end

function GpeDropDownMixin:OnEnter()
end

function GpeDropDownMixin:OnLeave()
end

--展开子选项面板
function GpeDropDownMixin:Expand()
    self.container:Show();
end

--添加项
function GpeDropDownMixin:AddItem(item)
    local width, height = self.container:GetSize();
    height = height + 20;
    self.container:SetSize(width, height);
    local frame = CreateFrame("Frame", nil, self.container, "GpeDropDownItemTemplate");
    frame.text:SetText(item.text);
end
