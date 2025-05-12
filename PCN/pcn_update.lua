-- updater.lua

local GITHUB_VERSION_URL = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/main/PCN/version.txt"
local LOCAL_VERSION_FILE = "version.txt"
local GITHUB_FILES_URL = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/main/PCN/"
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

-- Run the update check
checkForUpdates()