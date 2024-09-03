-- Util: kit print_table

---@class util.kit
local M = {}


function M.print_table(t, indent)
    indent = indent or 0  -- Default to zero indentation
    local prefix = string.rep(" ", indent)  -- Create prefix based on indentation

    for key, value in pairs(t) do
        if type(value) == "table" then
            print(prefix .. tostring(key) .. ":")
            M.print_table(value, indent + 2)  -- Increase indentation for nested tables
        else
            print(prefix .. tostring(key) .. ": " .. tostring(value))
        end
    end
end

return M
