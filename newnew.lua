local function getComputerInfo()
    local info = {}

    info.computerName = os.getComputerLabel() or "Unnamed Computer"
    info.uptime = os.getUptime()
    info.freeMemory = os.getFreeMemory()
    info.totalMemory = os.getTotalMemory()

    local drive = "disk"  -- Replace with your actual drive name
    if fs.exists(drive) then
        info.diskFree = fs.getFreeSpace(drive)
        info.diskTotal = fs.getTotalSpace(drive)
    end

    local redstone_side = "back" -- Replace with the actual side your redstone is on
    local redstone = peripheral.wrap(redstone_side)
    if redstone then
        info.redstoneLevel = redstone.getInput(1) -- Get input from side 1
    else
        info.redstoneLevel = "No Redstone Device on " .. redstone_side
    end

    return info
end

local function handleRequest(request)
    if request == "/status" then
        local info = getComputerInfo()
        local response = ""
        for k, v in pairs(info) do
            response = response .. k .. "=" .. v .. "\n" -- Key-value pairs
        end
        return "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n" .. response  -- Plain text response
    else
        return "HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\n\r\nNot Found"
    end
end

while true do
    local request = read() -- Read input from the console
    if request then
        local response = handleRequest(request)
        if response then
            print(response) -- Print the response to the console
        end
    end
    os.sleep(0.1)
end
