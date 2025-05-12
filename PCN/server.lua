-- server.lua

-- Function to center text on the screen
local function centerPrint(text, y)
    local w, h = term.getSize()
    term.setCursorPos(math.floor((w - #text) / 2) + 1, y)
    print(text)
end

-- Function to check if a monitor is attached
local function getMonitor()
    local monitor = peripheral.find("monitor")
    return monitor
end

-- Server Info Variables
local serverID = "server001"  -- Unique server ID
local clientCount = 0
local messageCount = 0
local uptimeStart = os.time()

-- Function to update the info page
local function updateInfoPage()
    local monitor = getMonitor()
    if monitor then
        monitor.clear()
        monitor.setTextColor(colors.white)
        monitor.setBackgroundColor(colors.black)
        monitor.setCursorPos(1, 1)
    else
        term.clear()
        term.setTextColor(colors.white)
        term.setBackgroundColor(colors.black)
    end

    -- Display general server information
    centerPrint("=== Server Info ===", 2)
    print("Server ID: " .. serverID)
    print("Clients connected: " .. clientCount)
    print("Messages sent: " .. messageCount)
    print("Uptime: " .. os.date("%X", os.time() - uptimeStart))

    if monitor then
        monitor.setCursorPos(1, 7)
        monitor.write("Press 'Q' to exit.")
    else
        print("Press 'Q' to exit.")
    end
end

-- Function to handle client connections and messages
local function handleConnections()
    -- Simulate client connections and messages
    while true do
        -- Wait for a message (this could be from RedNet or another system, depending on your communication method)
        -- In this example, it's just a simulation
        sleep(1)
        messageCount = messageCount + 1  -- Increment message count
        clientCount = math.random(1, 5)  -- Random client count for demo
        updateInfoPage()  -- Update the info page with new statistics
    end
end

-- Main server loop
term.clear()
centerPrint("=== PCN Server ===", 2)

-- Start handling connections and updating the info page
handleConnections()
