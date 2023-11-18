function ApplyMoney(fontString, copper)
    local gold = math.floor(copper / 10000)
    copper = copper - gold * 10000
    local silver = math.floor(copper / 100)
    copper = copper - silver * 100

    local goldIcon = "|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t"
    local silverIcon = "|TInterface\\MoneyFrame\\UI-SilverIcon:14:14:2:0|t"
    local copperIcon = "|TInterface\\MoneyFrame\\UI-CopperIcon:14:14:2:0|t"

    fontString:SetFormattedText("%d%s %d%s %d%s", gold, goldIcon, silver, silverIcon, copper, copperIcon)
end

Gpe:AddFontStringApi("ApplyMoney", ApplyMoney);
