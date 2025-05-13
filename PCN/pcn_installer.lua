-- PCN Installer Script

local BASE_URL = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/refs/heads/main/PCN/"
local MANIFEST_URL = BASE_URL .. "manifest.txt"
local VERSION_URL = BASE_URL .. "version.txt"

-- Optional: use monitor if connected
local screen = term
local monitor = peripheral.find("monitor")
if monitor then
    monitor.setTextScale(0.5)
    screen = monitor
end

local function centerText(text)
    local w, h = screen.getSize()
    screen.setCursorPos(math.floor((w - #text) / 2) + 1, select(2, screen.getCursorPos()))
    screen.write(text)
end

local function drawUI()
    screen.setBackgroundColor(colors.black)
    screen.setTextColor(colors.cyan)
    screen.clear()
    screen.setCursorPos(1, 2)
    centerText("=== PCN Installer ===")
    screen.setCursorPos(1, 4)
    screen.setTextColor(colors.white)
end

local function askRole()
    drawUI()
    screen.write("Do you want to install the client or server? [client/server]: ")
    return read()
end

local function downloadFile(remotePath, localName)
    local url = BASE_URL .. remotePath
    screen.setTextColor(colors.lightBlue)
    print("Downloading " .. remotePath .. " ...")
    local success = shell.run("wget", url, localName)
    screen.setTextColor(colors.white)
    return success
end

local function getRemoteLines(url)
    local tempFile = "__temp.txt"
    if not shell.run("wget", url, tempFile) then return nil end
    local file = fs.open(tempFile, "r")
    local lines = {}
    while true do
        local line = file.readLine()
        if not line then break end
        table.insert(lines, line)
    end
    file.close()
    fs.delete(tempFile)
    return lines
end

local function installFiles(role)
    -- Download manifest
    local files = getRemoteLines(MANIFEST_URL)
    if not files then
        print("Failed to download manifest.")
        return false
    end

    for _, file in ipairs(files) do
        file = file:match("^%s*(.-)%s*$") -- trim
        if file ~= "" and not file:match("^#") then
            local fileName = file:match("([^/]+)$")
            if fileName:match("^config") then
                print("Skipping config file: " .. fileName)
            elseif fileName == "client.lua" and role ~= "client" then
                -- skip
            elseif fileName == "server.lua" and role ~= "server" then
                -- skip
            else
                if not downloadFile(file, fileName) then
                    print("Failed to download: " .. fileName)
                    return false
                end
            end
        end
    end

    return true
end

local function installVersion()
    local lines = getRemoteLines(VERSION_URL)
    if not lines then
        print("Failed to download version.txt.")
        return
    end
    local f = fs.open("version.txt", "w")
    f.write(lines[1] or "unknown")
    f.close()
end

-- Main Logic
drawUI()
local role
repeat
    role = askRole():lower()
until role == "client" or role == "server"

drawUI()
centerText("Installing PCN (" .. role .. ") ...")
screen.setCursorPos(1, 6)

if installFiles(role) then
    installVersion()
    print("\nInstallation complete!")
else
    print("\nInstallation failed.")
end
