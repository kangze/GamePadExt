-- 0：粗糙（灰色）
-- 1：普通（白色）
-- 2：优秀（绿色）
-- 3：稀有（蓝色）
-- 4：史诗（紫色）
-- 5：传说（橙色）
-- 6：神器（金色）
-- 7：绑定（绿色）
-- 8：任务（白色）
local QualityBorderTexures = {
    [0] = "loottoast-itemborder-gray",
    [1] = "loottoast-itemborder-gray",
    [2] = "loottoast-itemborder-green",
    [3] = "loottoast-itemborder-blue",
    [4] = "loottoast-itemborder-purple",
    [5] = "loottoast-itemborder-orange",
    [6] = "loottoast-itemborder-artifact",
    [7] = "loottoast-itemborder-green",
    [8] = "loottoast-itemborder-gray",
}

function GetQualityBorder(quality)
    return QualityBorderTexures[quality];
end
