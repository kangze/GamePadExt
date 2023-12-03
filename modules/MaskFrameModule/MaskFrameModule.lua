local _, AddonData = ...;
local Gpe = _G["Gpe"];

local unpack = unpack;

local MaskFrameModule = Gpe:GetModule('MaskFrameModule');

HeaderRegions = {
    regions = {}
};

--注册功能区域_每个需要用的模块需要提前进行注册--
function HeaderRegions:Register(name, createframe_callback)
    self.regions[name] = createframe_callback;
end

function MaskFrameModule:OnInitialize()
    self.regions = {};
end

function MaskFrameModule:OnEnable()
    local headFrame = CreateFrame("Frame", nil, nil, "HeaderFrameTemplate");
    headFrame:ClearAllPoints();
    headFrame:SetPoint("TOP", UIParent, 0, 0);
    self.headFrame = headFrame;

    local bodyFrame = CreateFrame("Frame", nil, nil, "BodyFrameTemplate");
    bodyFrame:ClearAllPoints();
    bodyFrame:SetPoint("TOP", headFrame, "BOTTOM", 0, 0);
    self.bodyFrame = bodyFrame;
end

function MaskFrameModule:ShowFadeIn()
    self.headFrame:ShowFadeIn();
    self.bodyFrame:ShowFadeIn();
end

function MaskFrameModule:Active(name)
    local createframe_callback = HeaderRegions.regions[name];
    local frame = createframe_callback(self.headFrame);
    frame:SetParent(self.headFrame);
    frame:SetPoint("CENTER", 0, 0);
    frame:SetFrameStrata("FULLSCREEN");
    frame:SetHeight(self.headFrame:GetHeight());
    frame:Show();
    self.headFrame.childFrame = frame;
    if (not self.childs) then
        self.childs = {};
    end
    table.insert(self.childs, { name = name, frame = frame });
end

--转换到另外的Tab,代表的是,原来的tab必须给销毁掉
function MaskFrameModule:SwitchFeatureRegion(name)
    self.headFrame.childFrame:Hide();
    -- 销毁方法必须自己定义TODO
    -- self.headFrame.childFrame:UnregisterAllEvents();
    self.headFrame.childFrame = nil;
    for _, v in pairs(self.childs) do
        if (v.name == name) then
            self.headFrame.childFrame = v.frame;
            self.headFrame.childFrame:Show();
            break;
        end
    end
end

--摧毁注册区域
function MaskFrameModule:Destroy(name)
    self.headFrame:ShowFadeOut();
    self.bodyFrame:ShowFadeOut();
    local frame = HeaderRegions[name];
    frame:Destroy();
    HeaderRegions[name] = nil;
end

--让内容得到焦点
function MaskFrameModule:SelectContentFoucs()
    self.bodyFrame:SetFrameStrata("BACKGROUND");
end

------以下代码需要逐步弃用------------------

function MaskFrameModule:ShowAll()
    self.headFrame:Show();
    self.bodyFrame:Show();
end

function MaskFrameModule:HideBody()
    self.bodyFrame:Hide();
end

function MaskFrameModule:GetHeaderFrame()
    return self.headFrame
end

function MaskFrameModule:SetBackground()
    self.bodyFrame:SetFrameStrata("BACKGROUND");
end

function MaskFrameModule:SetFullScreen()
    self.bodyFrame:SetFrameStrata("FULLSCREEN");
end

function MaskFrameModule:SETDIALOG()
    self.bodyFrame:SetFrameStrata("DIALOG");
end

function MaskFrameModule:GetBodyFrameSize()
    return self.bodyFrame:GetSize();
end
