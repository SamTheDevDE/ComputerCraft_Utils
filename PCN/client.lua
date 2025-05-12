-- client.lua

-- Load config
if not fs.exists("client_config") then
    print("Missing client_config file. Run client_installer.lua first.")
    return
end

local file = fs.open("client_config", "r")
local config = textutils.unserialize(file.readAll())
file.close()

local encryption = require("encryption")

-- Open modem
local modemSide = "back"
if not peripheral.isPresent(modemSide) then
    print("Modem not found on side: " .. modemSide)
    return
end

rednet.open(modemSide)

-- GUI loop
local function drawUI()
    term.clear()
    term.setCursorPos(1, 1)
    print("=== Private Chat Client ===")
    print("Your ID: " .. config.id)
    print("Talking to Server ID: " .. config.server)
    print("To send a message, type below:")
    print("------------------------------")
end

local function receiveMessages()
    while true do
        local senderID, raw = rednet.receive()
        local data = textutils.unserialize(raw)
        if type(data) == "table" and data.from and data.text then
            print()
            print("[" .. data.from .. "]: " .. data.text)
            write("> ")
        elseif type(data) == "table" and data.error then
            print()
            print("! Server: " .. data.error)
            write("> ")
        end
    end
end

local function sendMessages()
    while true do
        write("> ")
        local msg = read()
        if #msg > 0 then
            local encrypted = encryption.xor(msg, config.authKey)
            local packet = {
                from = config.id,
                to = config.targetID,
                password = config.password,
                payload = encrypted
            }
            rednet.send(config.server, textutils.serialize(packet))
        end
    end
end

drawUI()
parallel.waitForAny(receiveMessages, sendMessages)
