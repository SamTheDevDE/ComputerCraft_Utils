-- client.lua

local modem = peripheral.find("modem")
if not modem then
    error("No modem found.")
end

modem.open(100) -- Listening on channel 100
local SERVER_ID = 100 -- Server computer ID
local message = "Hello, Server!"

-- Function to send a message to the server
local function sendMessage(msg)
    modem.transmit(SERVER_ID, os.getComputerID(), msg)
    print("Sent message: " .. msg)
end

-- Set up the monitor (if available)
local monitor = peripheral.find("monitor")
if monitor then
    monitor.clear()
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(1, 1)
    monitor.write("Client Started!")
end

-- Send the message
sendMessage(message)

-- Listen for the server's acknowledgment
while true do
    local event, side, channel, replyChannel, msg, distance = os.pullEvent("modem_message")
    
    if channel == os.getComputerID() then
        -- Display server's acknowledgment
        print("Received from server: " .. msg)
        
        -- If a monitor is available, display the message
        if monitor then
            monitor.clear()
            monitor.setCursorPos(1, 1)
            monitor.write("Server: " .. msg)
        end
        break
    end
end
