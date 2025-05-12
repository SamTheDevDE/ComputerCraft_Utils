-- client.lua

-- Load config
if not fs.exists("client_config") then
    print("Missing client_config file. Run the installer first.")
    return
end

local file = fs.open("client_config", "r")
local config = textutils.unserialize(file.readAll())
file.close()

local encryption = require("shared.encryption")

-- Open modem
local modemSide = "back"
if not peripheral.isPresent(modemSide) then
    print("Modem not found on side: " .. modemSide)
    return
end

local modem = peripheral.wrap(modemSide)
modem.open(config.port)  -- Open the specific port to listen for messages

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
        local _, message, senderID, _ = os.pullEvent("modem_message")
        local data = textutils.unserialize(message)
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
                to = config.server,  -- This can be removed if broadcasting
                password = config.password,
                payload = encrypted
            }
            modem.transmit(config.server, config.port, textutils.serialize(packet))
        end
    end
end

drawUI()
parallel.waitForAny(receiveMessages, sendMessages)
