-- server.lua

local modem = peripheral.find("modem")
if not modem then
    error("No modem found.")
end

modem.open(100) -- Listening on channel 100
local BROADCAST_CHANNEL = 100
local clients = {}

-- Function to handle received messages
local function handleMessage(message, senderID)
    print("Received message from " .. senderID .. ": " .. message)
    
    -- Send an acknowledgment to the sender
    modem.transmit(senderID, os.getComputerID(), "Message received: " .. message)
end

-- Set up the monitor (if available)
local monitor = peripheral.find("monitor")
if monitor then
    monitor.clear()
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(1, 1)
    monitor.write("Server Started!")
end

-- Main server loop
while true do
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    
    if channel == BROADCAST_CHANNEL then
        -- Handle the incoming message
        handleMessage(message, replyChannel)
        
        -- Display message on the monitor (if available)
        if monitor then
            monitor.clear()
            monitor.setCursorPos(1, 1)
            monitor.write("Received from " .. replyChannel .. ": " .. message)
        end
    end
end
