local component = require("component")
local json = require("json")

local function getComputerInfo()
    local info = {}

    info.computerName = os.getComputerLabel() or "Unnamed Computer"
    info.uptime = os.getUptime()
    info.freeMemory = os.getFreeMemory()
    info.totalMemory = os.getTotalMemory()

    -- Disk Information (replace "disk" with actual drive name if needed)
    local drive = "disk"  -- Check with fs.list() to get the correct drive name
    if fs.exists(drive) then
        info.diskFree = fs.getFreeSpace(drive)
        info.diskTotal = fs.getTotalSpace(drive)
    end
    
    -- Example of getting a redstone signal (if you have a redstone card)
    local redstone = component.getPrimary("redstone") -- Get the redstone component
    if redstone then
      info.redstoneLevel = redstone.getInput(1) -- Get input from side 1
    else
      info.redstoneLevel = "No Redstone Card"
    end
    
    --Add more info as needed.
    return info
end

local function handleRequest(request)
    if request == "/status" then -- Simplified request handling
        local info = getComputerInfo()
        local responseBody = json.encode(info)
        return "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n" .. responseBody
    else
        return "HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\n\r\nNot Found"
    end
end


while true do
    local event, side, message = os.pullEvent("modem_message") -- Listen for modem messages
    if event == "modem_message" and side == "right" then -- Assuming the modem is on the right side
        if message then
            local response = handleRequest(message)
            if response then
                -- Send the response back through the modem
                component.proxy("right").transmit("left", response)  -- Transmit back on the left side
            end
        end
    end
    os.sleep(0.1)  -- Don't hog the CPU
end
