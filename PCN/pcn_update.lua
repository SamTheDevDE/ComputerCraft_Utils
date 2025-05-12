-- pcn_update.lua

-- Helper function to download a file from the URL to the destination path
local function wget(url, dest, fileName)
    -- Create a progress bar
    term.setCursorPos(1, term.getSize() - 1)
    term.clearLine()
    term.setTextColor(colors.cyan)
    write("Downloading " .. fileName .. " ...")
    term.setTextColor(colors.white)

    -- Run wget command
    local result = shell.run("wget", url, dest)
    if not result then
        print("Error: Failed to download " .. fileName)
        return false
    end
    return true
end

-- Function to get the current version from the version.txt file
local function getCurrentVersion()
    local versionFile = fs.open("version.txt", "r")
    if not versionFile then
        print("Error: version.txt file is missing.")
        return nil
    end
    local version = versionFile.readLine()
    versionFile.close()
    return version
end

-- Function to update PCN files based on repository
local function updatePCNFiles(baseUrl, currentVersion)
    -- Fetch the manifest and version from the server
    local manifestUrl = baseUrl .. "manifest.txt"
    local remoteVersionUrl = baseUrl .. "version.txt"
    local tempManifest = "__manifest_temp.txt"
    local tempVersionFile = "__version_temp.txt"

    -- Download the remote version.txt file and compare it
    print("Fetching remote version...")
    if not wget(remoteVersionUrl, tempVersionFile, "version.txt") then
        print("Error: Failed to download remote version.")
        return false
    end
    local remoteVersionFile = fs.open(tempVersionFile, "r")
    local remoteVersion = remoteVersionFile.readLine()
    remoteVersionFile.close()
    fs.delete(tempVersionFile)

    -- If the current version is up to date
    if remoteVersion == currentVersion then
        print("No updates available. You are on the latest version!")
        return true
    end

    -- Inform the user about the update
    print("New update available! Current version: " .. currentVersion .. " -> New version: " .. remoteVersion)

    -- Download the manifest file
    print("Fetching manifest...")
    if not wget(manifestUrl, tempManifest, "manifest.txt") then
        return false
    end

    -- Read and process the manifest file
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

        -- Check if the file is a config (skip if it is)
        if fileName:match("^config") then
            print("Skipping config file: " .. fileName)
            goto continue
        end

        -- Download file and display progress
        if not wget(baseUrl .. filePath, fileName, fileName) then
            print("Error: Could not download " .. fileName)
            return false
        end

        ::continue::
    end

    -- Update the local version.txt file
    local versionFile = fs.open("version.txt", "w")
    versionFile.write(remoteVersion)
    versionFile.close()

    print("Update complete! You are now on version " .. remoteVersion)
    return true
end

-- Main update logic
local function startUpdate()
    -- Base URL for downloading files from the repository
    local baseRepoUrl = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/refs/heads/main/PCN/"

    -- Display a welcome message and clear the screen
    term.clear()
    term.setCursorPos(1, 1)
    term.setTextColor(colors.cyan)
    print("╔════════════════════════════════════╗")
    print("║          🛠️ PCN Update            ║")
    print("╚════════════════════════════════════╝")
    term.setTextColor(colors.white)

    -- Get current version from version.txt
    local currentVersion = getCurrentVersion()
    if not currentVersion then
        print("Error: Unable to read current version.")
        return
    end

    -- Start updating process
    if not updatePCNFiles(baseRepoUrl, currentVersion) then
        print("Error: Update failed.")
        return
    end
end

-- Run the update process
startUpdate()
