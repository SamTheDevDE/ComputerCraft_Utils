-- pcn_net.lua

local modem = peripheral.find("modem")
if not modem then
    error("No modem found.")
end

modem.open(os.getComputerID()) -- Open unique reply channel
local BROADCAST_CHANNEL = 100 -- All devices listen here

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

-- Send a packet to a target computer's ID channel
local function send(toId, payload)
    local msg = xor(payload, config.authKey)
    modem.transmit(toId, os.getComputerID(), msg)
end

-- Broadcast to all listening on main channel
local function broadcast(payload)
    local msg = xor(payload, config.authKey)
    modem.transmit(BROADCAST_CHANNEL, os.getComputerID(), msg)
end

-- Receive message with timeout
local function receive(timeout)
    local event, side, channel, replyChannel, msg, dist = os.pullEventTimeout("modem_message", timeout)
    if event and channel == os.getComputerID() then
        return replyChannel, xor(msg, config.authKey)
    end
    return nil, nil
end

return {
    send = send,
    receive = receive,
    broadcast = broadcast,
    getChannel = function() return os.getComputerID() end,
    getBroadcastChannel = function() return BROADCAST_CHANNEL end,
}
