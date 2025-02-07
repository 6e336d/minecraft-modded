local function simpleJsonEncode(data)
  local result = "{"
  local first = true
  for k, v in pairs(data) do
    if not first then
      result = result .. ","
    end
    result = result .. "\"" .. tostring(k) .. "\":"
    if type(v) == "string" then
      result = result .. "\"" .. v .. "\""
    elseif type(v) == "number" or type(v) == "boolean" then
      result = result .. tostring(v)
    else -- Add more type handling as needed
        result = result .. "\"" .. tostring(v) .. "\"" -- Handle other types as strings for now
    end
    first = false
  end
  result = result .. "}"
  return result
end

-- Example usage:
local myData = { name = "Computer", uptime = 120, diskFree = 1000 }
local jsonString = simpleJsonEncode(myData)
print(jsonString)  -- Output: {"name":"Computer","uptime":120,"diskFree":1000}
