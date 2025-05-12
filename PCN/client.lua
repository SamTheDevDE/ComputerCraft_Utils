-- client.lua

local config = {}

-- Load client configuration (client_config)
local function loadClientConfig()
    if fs.exists("client_config") then
        local file = fs.open("client_config", "r")
        config.serverID = file.readLine()
        config.clientID = file.readLine()
        config.authKey = file.readLine()
        file.close()
    else
        print("No client_config found. Creating a new one.")

        term.clear()
        term.setCursorPos(1,1)
        write("Enter server ID: ")
        config.serverID = read()

        write("Enter your client ID (3 digits max): ")
        config.clientID = read()

        write("Enter your authorization key: ")
        config.authKey = read("*")  -- hide input for security

        local file = fs.open("client_config", "w")
        file.writeLine(config.serverID)
        file.writeLine(config.clientID)
        file.writeLine(config.authKey)
        file.close()
    end
end

-- Attempt to authenticate with server (stub)
local function authenticate()
    -- You would normally send this to the server
    print("Authenticating as client " .. config.clientID .. " to server " .. config.serverID .. "...")
    sleep(1)
    -- Simulated success
    print("Authentication successful.")
end

-- Main
loadClientConfig()
authenticate()

-- Now client is ready to send messages
print("Ready to chat.")
