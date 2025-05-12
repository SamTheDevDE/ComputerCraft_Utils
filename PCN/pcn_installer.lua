-- installer.lua

local GITHUB = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/main/"

local function centerPrint(text, y)
    local w, _ = term.getSize()
    term.setCursorPos(math.floor((w - #text) / 2) + 1, y)
    print(text)
end

term.clear()
centerPrint("=== Private Chat Installer ===", 2)

term.setCursorPos(2, 4)
print("Are you installing a server or client?")
print("1) Server")
print("2) Client")
write("> ")
local choice = tonumber(read())

if choice == 1 then
    -- Server setup
    term.clear()
    centerPrint("=== Server Setup ===", 2)
    term.setCursorPos(2, 4)
    write("Enter Server ID (1-999): ")
    local id = tonumber(read())

    term.setCursorPos(2, 6)
    write("Set server password: ")
    local pass = read("*")

    term.setCursorPos(2, 8)
    write("Set authorization key: ")
    local key = read("*")

    local config = {
        id = id,
        password = pass,
        authKey = key
    }

    local f = fs.open("server_config", "w")
    f.write(textutils.serialize(config))
    f.close()

    print("Downloading server files...")
    shell.run("wget", GITHUB .. "server.lua", "server.lua")
    shell.run("wget", GITHUB .. "encryption.lua", "encryption.lua")

    print("Launching server...")
    sleep(1)
    shell.run("server.lua")

elseif choice == 2 then
    -- Client setup
    term.clear()
    centerPrint("=== Client Setup ===", 2)
    term.setCursorPos(2, 4)
    write("Enter your Client ID (1-999): ")
    local id = tonumber(read())

    term.setCursorPos(2, 6)
    write("Enter Server ID to connect to: ")
    local serverID = tonumber(read())

    term.setCursorPos(2, 8)
    write("Enter Recipient Client ID (1-999): ")
    local targetID = tonumber(read())

    term.setCursorPos(2, 10)
    write("Enter server password: ")
    local pass = read("*")

    term.setCursorPos(2, 12)
    write("Enter authorization key: ")
    local key = read("*")

    local config = {
        id = id,
        password = pass,
        authKey = key,
        server = serverID,
        targetID = targetID
    }

    local f = fs.open("client_config", "w")
    f.write(textutils.serialize(config))
    f.close()

    print("Downloading client files...")
    shell.run("wget", GITHUB .. "client.lua", "client.lua")
    shell.run("wget", GITHUB .. "encryption.lua", "encryption.lua")

    print("Launching client...")
    sleep(1)
    shell.run("client.lua")

else
    print("Invalid selection. Exiting.")
end
