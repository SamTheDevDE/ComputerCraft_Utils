-- installer.lua

local GITHUB_FILES_URL = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/main/PCN/"
local GITHUB_VERSION_URL = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/main/PCN/version.txt"

-- Function to center text on the screen
local function centerPrint(text, y)
    local w, _ = term.getSize()
    term.setCursorPos(math.floor((w - #text) / 2) + 1, y)
    print(text)
end

-- Function to download a file from GitHub
local function downloadFile(fileURL, savePath)
    print("Downloading " .. savePath .. " from GitHub...")
    local response = http.get(fileURL)
    if not response then
        print("Error: Unable to download " .. savePath)
        return false
    end
    local file = fs.open(savePath, "w")
    file.write(response.readAll())
    file.close()
    response.close()
    return true
end

-- Function to create the client configuration file
local function createClientConfig()
    print("Creating client configuration...")
    local config = {
        id = math.random(100, 999),  -- Unique client ID (up to 3 digits)
        server = "server",  -- Server ID
        password = "password123",  -- Default password
        authKey = "secretKey",  -- Default authorization key
        port = 12345  -- Default communication port
    }
    local file = fs.open("client_config", "w")
    file.write(textutils.serialize(config))
    file.close()
    print("Client configuration created!")
end

-- Function to create the server configuration file
local function createServerConfig()
    print("Creating server configuration...")
    local config = {
        id = "server",  -- Server ID
        password = "password123",  -- Default password
        authKey = "secretKey",  -- Default authorization key
        port = 12345  -- Default communication port
    }
    local file = fs.open("server_config", "w")
    file.write(textutils.serialize(config))
    file.close()
    print("Server configuration created!")
end

-- Function to check for the modem
local function checkModem()
    local modemSide = "back"
    if not peripheral.isPresent(modemSide) then
        print("No modem detected on side " .. modemSide .. ". Please attach a modem.")
        return false
    end
    return true
end

-- Function to set up the installer
local function runInstaller()
    term.clear()
    centerPrint("=== PCN Installer ===", 2)

    -- Check for modem
    if not checkModem() then
        return
    end

    -- Ask the user if they want to install as client or server
    print("Do you want to install as client or server?")
    print("Type 'client' for client or 'server' for server.")
    local choice = read()

    -- Install files and configurations based on the choice
    if choice == "client" then
        print("Installing as client...")
        -- Download the necessary client files
        if not downloadFile(GITHUB_FILES_URL .. "client.lua", "client.lua") then return end
        if not downloadFile(GITHUB_FILES_URL .. "encryption.lua", "shared/encryption.lua") then return end
        createClientConfig()
        print("Client installation complete!")

    elseif choice == "server" then
        print("Installing as server...")
        -- Download the necessary server files
        if not downloadFile(GITHUB_FILES_URL .. "server.lua", "server.lua") then return end
        if not downloadFile(GITHUB_FILES_URL .. "encryption.lua", "shared/encryption.lua") then return end
        createServerConfig()
        print("Server installation complete!")
    else
        print("Invalid choice. Please type 'client' or 'server'.")
        return
    end

    -- Check if updates are available
    local githubVersion = http.get(GITHUB_VERSION_URL)
    if not githubVersion then
        print("Error: Unable to check for updates.")
        return
    end

    local latestVersion = githubVersion.readAll()
    githubVersion.close()

    local localVersion = "0.0.0"  -- Default version
    if fs.exists("version.txt") then
        local file = fs.open("version.txt", "r")
        localVersion = file.readAll()
        file.close()
    end

    -- If version is outdated, download update
    if localVersion ~= latestVersion then
        print("Update available! Downloading new version...")
        downloadFile(GITHUB_FILES_URL .. "client.lua", "client.lua")
        downloadFile(GITHUB_FILES_URL .. "server.lua", "server.lua")
        downloadFile(GITHUB_FILES_URL .. "version.txt", "version.txt")
        print("Update complete!")
    else
        print("You are already using the latest version!")
    end

    -- Setup complete, prompt user to start the system
    print("Setup complete! Type 'start' to run the system.")
    local startChoice = read()
    if startChoice == "start" then
        if choice == "client" then
            shell.run("client.lua")
        elseif choice == "server" then
            shell.run("server.lua")
        end
    end
end

-- Run the installer
runInstaller()
