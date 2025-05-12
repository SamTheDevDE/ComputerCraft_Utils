-- server.lua
local modem = peripheral.find("modem")
if not modem then
    error("No modem found.")
end

local BROADCAST_CHANNEL = 100
modem.open(BROADCAST_CHANNEL) -- Open broadcast channel

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

-- Handle messages from clients
local function handleClientMessages()
    while true do
        local event, side, channel, replyChannel, msg, dist = os.pullEvent("modem_message")
        if channel == BROADCAST_CHANNEL then
            print("Received message: " .. msg)
            -- Respond to the client
            local response = "Hello from the server!"
            send(replyChannel, response)
        end
    end
end

-- Send message to a target
local function send(toId, payload)
    local msg = xor(payload, config.authKey)
    modem.transmit(toId, os.getComputerID(), msg)
end

-- Main server loop
local function main()
    print("Server is running...")
    handleClientMessages()
end

main()
