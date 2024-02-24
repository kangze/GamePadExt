function GetAllChildren(frame)
    local children = { frame:GetChildren() }
    for i, child in ipairs(children) do
        local grandChildren = GetAllChildren(child)
        for _, grandChild in ipairs(grandChildren) do
            table.insert(children, grandChild)
        end
    end
    return children
end
