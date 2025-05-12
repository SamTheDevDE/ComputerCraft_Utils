-- startup.lua

local GITHUB_VERSION_URL = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/main/PCN/version.txt"
local LOCAL_VERSION_FILE = "version.txt"
local GITHUB_FILES_URL = "https://raw.githubusercontent.com/YourUser/YourRepo/main/"

-- Function to center text on the screen
local function centerPrint(text, y)
    local w, _ = term.getSize()
    term.setCursorPos(math.floor((w - #text) / 2) + 1, y)
    print(text)
end

-- Function to check for updates
local function checkForUpdates()
    -- Download version file from GitHub
    local githubVersion = http.get(GITHUB_VERSION_URL)
    if not githubVersion then
        print("Failed to fetch version info from GitHub.")
        return nil
    end
    local latestVersion = githubVersion.readAll()
    githubVersion.close()

    -- Read local version
    local localVersion = nil
    if fs.exists(LOCAL_VERSION_FILE) then
        local file = fs.open(LOCAL_VERSION_FILE, "r")
        localVersion = file.readAll()
        file.close()
    else
        localVersion = "0.0.0" -- If no local version, assume the first run
    end

    -- Return if the local version is outdated
    if localVersion ~= latestVersion then
        return latestVersion
    else
        return nil
    end
end

-- Function to download the update
local function downloadUpdate()
    print("Downloading latest version...")

    -- Download all necessary files (client/server/encryption)
    shell.run("wget", GITHUB_FILES_URL .. "client.lua", "client.lua")
    shell.run("wget", GITHUB_FILES_URL .. "server.lua", "server.lua")
    shell.run("wget", GITHUB_FILES_URL .. "encryption.lua", "shared/encryption.lua")

    -- Update the version file
    local githubVersion = http.get(GITHUB_VERSION_URL)
    local latestVersion = githubVersion.readAll()
    githubVersion.close()

    local file = fs.open(LOCAL_VERSION_FILE, "w")
    file.write(latestVersion)
    file.close()

    print("Update complete!")
end

-- Display UI
term.clear()
centerPrint("=== PCN - Private Chat Network ===", 2)

-- Check for updates
local latestVersion = checkForUpdates()
if latestVersion then
    -- Show update available message
    centerPrint("Update available! New version: " .. latestVersion, 4)
    centerPrint("Press any key to update.", 6)
    os.pullEvent("key")
    
    -- Download update
    downloadUpdate()

    -- Restart the client/server after updating
    if fs.exists("client_config") then
        shell.run("client.lua")
    elseif fs.exists("server_config") then
        shell.run("server.lua")
    end
else
    -- Show up-to-date message
    centerPrint("You are running the latest version!", 4)
    centerPrint("Press any key to continue.", 6)
    os.pullEvent("key")
    
    -- Start the client or server depending on the config
    if fs.exists("client_config") then
        shell.run("client.lua")
    elseif fs.exists("server_config") then
        shell.run("server.lua")
    end
end
