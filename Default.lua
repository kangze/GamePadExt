local _, Addon = ...;


Addon.registration = {
    default_profile = {
       
        buffer = {
            from = true
        }
    },
    options = {
        type = "group",
        args = {}
    },
}


function Addon:RegisterConfig(config)
    if config and config.default_profile then
        for k, v in pairs(config.default_profile) do
            self.registration.default_profile[k] = v;
        end
    end
    if config and config.options then
        for k, v in pairs(config.options) do
            self.registration.options.args[k] = v;
        end
    end
end

function Addon:GetDefaultProfile()
    return self.registration.default_profile;
end

function Addon:GetDefaultOptions()
    return self.registration.options;
end


--无处安放的代码
CharacterFrame:HookScript("OnShow", function(arg)
    arg:SetScale(1.12);
end);

--CameraMover:Enter()