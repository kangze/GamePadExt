local _, AddonData = ...;
local Gpe = _G["Gpe"];

local merchantModuleConfig = {
	profile = {
		merchantModule = {
			merchantItem = {
				width = 210,
				width_space = 40,
				height = 45,
				height_space = 10
			}
		}
	},

	options = {
		merchantModule = {
			name = "Merchant Module",
			type = "group",
			args = {
				merchantItem = {
					name = "Merchant Item",
					type = "group",
					inline = true,
					args = {
						width = {
							name = "Width",
							type = "range",
							min = 100,
							max = 300,
							step = 5,
							get = function(info)
								return AddonData.profile.merchantModule.merchantItem.width;
							end,
							set = function(info, value)
								AddonData.profile.merchantModule.merchantItem.width = value;
							end
						},
						width_space = {
							name = "Width Space",
							type = "range",
							min = 10,
							max = 100,
							step = 5,
							get = function(info)
								return AddonData.profile.merchantModule.merchantItem.width_space;
							end,
							set = function(info, value)
								AddonData.profile.merchantModule.merchantItem.width_space = value;
							end
						},
						height = {
							name = "Height",
							type = "range",
							min = 30,
							max = 100,
							step = 5,
							get = function(info)
								return AddonData.profile.merchantModule.merchantItem.height;
							end,
							set = function(info, value)
								AddonData.profile.merchantModule.merchantItem.height = value;
							end
						},
						height_space = {
							name = "Height Space",
							type = "range",
							min = 5,
							max = 50,
							step = 5,
							get = function(info)
								return AddonData.profile.merchantModule.merchantItem.height_space;
							end,
							set = function(info, value)
								AddonData.profile.merchantModule.merchantItem.height_space = value;
							end
						}
					}
				}
			}
		}
	}
}
