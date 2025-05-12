-- client.lua
local modem = peripheral.find("modem")
if not modem then
    error("No modem found.")
end

local BROADCAST_CHANNEL = 100 -- Channel for broadcasting
modem.open(os.getComputerID()) -- Open unique reply channel (client's own channel)

local config = {}
if fs.exists("config.cfg") then
    for line in io.lines("config.cfg") do
        local key, value = line:match("([^=]+)=([^=]+)")
        if key and value then
            config[key] = value
        end
    end
else
    error("Missing config.cfg")
end

-- Util: XOR encryption
local function xor(str, key)
    local out = {}
    for i = 1, #str do
        local char = str:byte(i)
        local k = key:byte((i - 1) % #key + 1)
        out[i] = string.char(bit.bxor(char, k))
    end
    return table.concat(out)
end

-- Receive message with timeout
local function receive(timeout)
    local startTime = os.clock()
    while true do
        local event, side, channel, replyChannel, msg, dist = os.pullEvent("modem_message")
        if os.clock() - startTime > timeout then
            return nil, nil  -- Timeout reached
        end
        if channel == os.getComputerID() then
            return replyChannel, xor(msg, config.authKey)
        end
    end
end

-- Connect to the server (send a handshake)
local function connectToServer(serverID)
    local handshakeMessage = "Hello, Server!"
    print("Sending handshake to server " .. serverID)
    send(serverID, handshakeMessage)  -- send function should be defined elsewhere

    -- Wait for response from server
    local replyChannel, response = receive(5)  -- 5 second timeout for response
    if response then
        print("Received reply: " .. response)
    else
        print("No response from server.")
    end
end

-- Send message to server
local function send(toId, payload)
    local msg = xor(payload, config.authKey)
    modem.transmit(toId, os.getComputerID(), msg)
end

-- Main client loop
local function main()
    -- Attempt to connect to server (replace with your server ID)
    local serverID = 1  -- Set your server's computer ID here
    connectToServer(serverID)
end

main()
