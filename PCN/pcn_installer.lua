-- installer.lua

-- Helper function to download a file from the URL to the destination path
local function wget(url, dest)
    print("Downloading: " .. url)
    local result = shell.run("wget", url, dest)
    if not result then
        print("Error: Failed to download " .. url)
        return false
    end
    print("Successfully downloaded " .. dest)
    return true
end

-- Function to read the manifest and install files
local function installFromRepo(baseUrl)
    -- Manifest file location
    local manifestUrl = baseUrl .. "manifest.txt"
    local tempManifest = "__manifest_temp.txt"

    -- Download the manifest file
    print("Fetching manifest...")
    if not wget(manifestUrl, tempManifest) then
        return false
    end

    -- Read and process the manifest to get file paths
    local file = fs.open(tempManifest, "r")
    local lines = {}
    if not file then
        print("Error: Manifest file is missing or corrupted.")
        fs.delete(tempManifest)
        return false
    end

    -- Process the manifest and extract file paths
    for line in file.readLine do
        line = line:match("^%s*(.-)%s*$") -- Trim spaces
        if line ~= "" and not line:match("^#") then  -- Skip empty or commented lines
            table.insert(lines, line)
        end
    end
    file.close()

    -- Delete the temporary manifest file
    fs.delete(tempManifest)

    -- Start installing files
    for _, filePath in ipairs(lines) do
        local fileName = filePath:match("([^/]+)$")  -- Extract file name from path
        print("Installing " .. fileName)
        if not wget(baseUrl .. filePath, fileName) then
            print("Error: Could not download " .. fileName)
            return false
        end
    end

    print("Installation complete!")
    return true
end

-- Main Installation Logic
local function startInstallation()
    -- Base URL for downloading files from the repository
    local baseRepoUrl = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/refs/heads/main/PCN/"

    -- Display a welcome message and clear the screen
    term.clear()
    term.setCursorPos(1, 1)
    term.setTextColor(colors.cyan)
    print("╔════════════════════════════════════╗")
    print("║          🛠️ PCN Installer          ║")
    print("╚════════════════════════════════════╝")
    term.setTextColor(colors.white)
    print("\nStarting installation...")

    -- Prompt user to choose between client or server
    local choice
    repeat
        print("\nPlease choose which file to install:")
        print("1. Install client.lua")
        print("2. Install server.lua")
        print("3. Install both (client.lua & server.lua)")
        print("4. Cancel")

        choice = tonumber(read())

        if choice == 1 then
            print("You chose to install client.lua.")
            if not wget(baseRepoUrl .. "client.lua", "client.lua") then
                print("Error: Could not download client.lua")
                return
            end
        elseif choice == 2 then
            print("You chose to install server.lua.")
            if not wget(baseRepoUrl .. "server.lua", "server.lua") then
                print("Error: Could not download server.lua")
                return
            end
        elseif choice == 3 then
            print("You chose to install both client.lua and server.lua.")
            if not wget(baseRepoUrl .. "client.lua", "client.lua") then
                print("Error: Could not download client.lua")
                return
            end
            if not wget(baseRepoUrl .. "server.lua", "server.lua") then
                print("Error: Could not download server.lua")
                return
            end
        elseif choice == 4 then
            print("Installation canceled.")
            return
        else
            print("Invalid choice. Please select a valid option (1-4).")
        end
    until choice >= 1 and choice <= 4

    -- Proceed with the generic file installation (using manifest.txt)
    if not installFromRepo(baseRepoUrl) then
        print("Installation failed! Please check the error above.")
        return
    end

    -- Installation complete message
    print("All files have been successfully installed.")
end

-- Run the installer
startInstallation()
