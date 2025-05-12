-- server.lua

-- Load config
if not fs.exists("server_config") then
    print("Missing server_config file. Run server_installer.lua first.")
    return
end

local file = fs.open("server_config", "r")
local config = textutils.unserialize(file.readAll())
file.close()

local encryption = require("shared.encryption")

-- Open modem
local modemSide = "back" -- Change if needed
if not peripheral.isPresent(modemSide) then
    print("Modem not found on side: " .. modemSide)
    return
end

rednet.open(modemSide)
print("Server ID: " .. config.id)
print("Waiting for client messages...")

local connectedClients = {}

while true do
    local senderID, message = rednet.receive()

    local success, data = pcall(textutils.unserialize, message)
    if not success or type(data) ~= "table" then
        print("Invalid message from ID " .. senderID)
        goto continue
    end

    -- Authenticate the message
    if data.password ~= config.password then
        print("Auth failed from ID " .. senderID)
        rednet.send(senderID, textutils.serialize({ error = "Auth failed" }))
        goto continue
    end

    -- Decrypt message
    local decryptedText = encryption.xor(data.payload, config.authKey)
    print("[" .. data.from .. " ➜ Everyone]: " .. decryptedText)

    -- Add the sender to the list of connected clients
    if not connectedClients[senderID] then
        connectedClients[senderID] = true
        print("Client ID " .. senderID .. " connected.")
    end

    -- Broadcast the message to all connected clients
    for clientID, _ in pairs(connectedClients) do
        if clientID ~= senderID then -- Don't send to the sender
            local forwardPayload = {
                from = data.from,
                text = decryptedText
            }
            rednet.send(clientID, textutils.serialize(forwardPayload))
        end
    end

    ::continue::
end
