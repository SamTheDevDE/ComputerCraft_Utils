-- startup.lua

local GITHUB_VERSION_URL = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/main/PCN/version.txt"
local LOCAL_VERSION_FILE = "version.txt"
local GITHUB_FILES_URL = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/main/PCN/"

-- Function to center text on the screen
local function centerPrint(text, y)
    local w, h = term.getSize()
    term.setCursorPos(math.floor((w - #text) / 2) + 1, y)
    print(text)
end

-- Function to check and download updates
local function checkForUpdates()
    print("Checking for updates...")
    local response = http.get(GITHUB_VERSION_URL)
    if not response then
        print("Error: Unable to check for updates.")
        return
    end

    local latestVersion = response.readAll()
    response.close()

    local localVersion = "0.0.0"
    if fs.exists(LOCAL_VERSION_PATH) then
        local file = fs.open(LOCAL_VERSION_PATH, "r")
        localVersion = file.readAll()
        file.close()
    end

    if localVersion ~= latestVersion then
        print("Update available! Downloading...")
        http.get(GITHUB_FILES_URL .. "version.txt")
        http.get(GITHUB_FILES_URL .. "client.lua")
        http.get(GITHUB_FILES_URL .. "server.lua")
        print("Update complete!")
    else
        print("You are already using the latest version.")
    end
end

-- Function to start the client or server
local function startProgram()
    if fs.exists("client_config") then
        shell.run("client.lua")
    elseif fs.exists("server_config") then
        shell.run("server.lua")
    else
        print("Error: No configuration found!")
    end
end

-- Main startup process
checkForUpdates()
startProgram()
