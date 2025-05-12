-- server.lua

local authorizedClients = {}  -- Table to store authorized clients
local messageCount = 0
local clientCount = 0
local uptimeStart = os.time()
local serverID
local authKey

-- Load server configuration (server_config)
local function loadServerConfig()
    if fs.exists("server_config") then
        local file = fs.open("server_config", "r")
        serverID = file.readLine()  -- Read serverID from config
        authKey = file.readLine()   -- Read authorization key from config
        file.close()
    else
        -- If no config, create it
        local file = fs.open("server_config", "w")
        file.writeLine("server001")  -- Default server ID
        file.writeLine("authKey123")  -- Default authorization key
        file.close()
    end
end

-- Function to check if a monitor is connected
local function getMonitor()
    local monitor = peripheral.find("monitor")
    return monitor
end

-- Function to authenticate a client using an authorization key
local function authenticate(clientID, key)
    if key == authKey then
        authorizedClients[clientID] = true
        return true
    end
    return false
end

-- Function to process incoming messages
local function handleMessage(clientID, message)
    -- Only accept messages from authenticated clients
    if authorizedClients[clientID] then
        messageCount = messageCount + 1
        -- Process the message (e.g., broadcast to others)
        print("Message from " .. clientID .. ": " .. message)
    else
        print("Unauthorized message from " .. clientID)
    end
end

-- Function to display server info on the monitor
local function displayServerInfo(monitor)
    if monitor then
        monitor.clear()
        monitor.setTextColor(colors.white)
        monitor.setBackgroundColor(colors.black)
        monitor.setCursorPos(1, 1)
        monitor.write("=== Server Info ===")
        monitor.setCursorPos(1, 3)
        monitor.write("Server ID: " .. serverID)
        monitor.setCursorPos(1, 4)
        monitor.write("Clients connected: " .. clientCount)
        monitor.setCursorPos(1, 5)
        monitor.write("Messages sent: " .. messageCount)
        monitor.setCursorPos(1, 6)
        monitor.write("Uptime: " .. os.date("%X", os.time() - uptimeStart))
    else
        term.clear()
        term.setTextColor(colors.white)
        term.setBackgroundColor(colors.black)
        print("=== Server Info ===")
        print("Server ID: " .. serverID)
        print("Clients connected: " .. clientCount)
        print("Messages sent: " .. messageCount)
        print("Uptime: " .. os.date("%X", os.time() - uptimeStart))
    end
end

-- Function to simulate incoming client connections
local function listenForClients()
    -- Simulating a simple connection loop
    while true do
        sleep(1)
        clientCount = math.random(1, 5)  -- Simulating client count for demo
        handleMessage("client001", "Hello, Server!")  -- Simulated client message
        local monitor = getMonitor()
        displayServerInfo(monitor)  -- Update the server info display
    end
end

-- Load server configuration
loadServerConfig()

-- Main server loop
listenForClients()
