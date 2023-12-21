TabInitor = {
    container = nil,
    frames = nil,
};
TabInitor.__index = TabInitor;


function TabInitor:Init(container)
    self.container = container;
    self.frames = {};
end

function TabInitor:AddTab(tabName, frame)
    table.insert(self.frames, { tabName = tabName, frame = frame });
end

--激活其中一个tab页
function TabInitor:Active(tabName)
    for _, value in ipairs(self.frames) do
        if (value.tabName == tabName) then
            value.frame:Show();
        else
            value.frame:Hide();
        end
    end
end
