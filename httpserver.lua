-- This program exposes some basic ComputerCraft information via HTTP.
-- It listens on port 8080 (you can change this).

local http = require("http")
local json = require("json")  -- For formatting data nicely (optional)

local port = 8080

local function getComputerInfo()
  local info = {}
  info.computerName = os.getComputerLabel() or "Unnamed Computer"
  info.uptime = os.getUptime()
  info.freeMemory = os.getFreeMemory()
  info.totalMemory = os.getTotalMemory()
  -- Add more information as needed (e.g., disk space, running programs)

    -- Example for disk space (replace with your actual drive name):
    local drive = "disk" -- Or whatever your disk drive is named
    if fs.exists(drive) then
        info.diskFree = fs.getFreeSpace(drive)
        info.diskTotal = fs.getTotalSpace(drive)
    end


  return info
end

local function handleRequest(request)
  if request.path == "/status" then
    local info = getComputerInfo()

    -- Format as JSON (recommended):
    local responseBody = json.encode(info)
    return {
      status = 200,
      headers = { ["Content-Type"] = "application/json" },
      body = responseBody
    }

    -- Or format as plain text (simpler):
    -- local responseBody = "Computer Name: " .. info.computerName .. "\nUptime: " .. info.uptime
    -- return {
    --   status = 200,
    --   headers = { ["Content-Type"] = "text/plain" },
    --   body = responseBody
    -- }

  else
    return {
      status = 404,  -- Not Found
      body = "Not Found"
    }
  end
end


local function startServer()
  http.createServer(function(request)
       local response = handleRequest(request)
       return response
  end, port)
  print("HTTP server started on port " .. port)
end

startServer()

-- Keep the program running to listen for requests:
while true do
    os.sleep(1) -- You can reduce this sleep time if needed
end
