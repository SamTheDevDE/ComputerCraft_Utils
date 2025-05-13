-- PCN Installer

local BASE_URL = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/refs/heads/main/PCN/"
local MANIFEST_URL = BASE_URL .. "manifest.txt"
local VERSION_URL = BASE_URL .. "version.txt"

local monitor = peripheral.find("monitor")
if monitor then monitor.setTextScale(0.5) end

local function clear(term)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.clear()
    term.setCursorPos(1, 1)
end

local function printUI(text, color)
    local t = monitor or term
    t.setTextColor(color or colors.white)
    t.write(text .. "\n")
end

local function drawHeader()
    local t = monitor or term
    clear(t)
    printUI("====================================", colors.cyan)
    printUI("         PCN INSTALLER", colors.cyan)
    printUI("====================================", colors.cyan)
    printUI("")
end

local function downloadFile(path)
    local dest = path:match("([^/]+)$")
    if dest == "config.cfg" then
        printUI("Skipping config file: " .. dest, colors.yellow)
        return true
    end
    local url = BASE_URL .. path
    printUI("Installing: " .. dest, colors.lime)
    if fs.exists(dest) then fs.delete(dest) end
    return shell.run("wget", url, dest)
end

local function fetchManifest()
    local tmp = "__manifest.txt"
    if not shell.run("wget", MANIFEST_URL, tmp) then return nil end

    local file = fs.open(tmp, "r")
    local lines = {}
    while true do
        local line = file.readLine()
        if not line then break end
        line = line:match("^%s*(.-)%s*$")
        if line ~= "" and not line:match("^#") then
            table.insert(lines, line)
        end
    end
    file.close()
    fs.delete(tmp)
    return lines
end

local function fetchVersion()
    local tmp = "__version.txt"
    if not shell.run("wget", VERSION_URL, tmp) then return nil end

    local file = fs.open(tmp, "r")
    local version = file.readLine()
    file.close()
    fs.delete(tmp)
    return version
end

local function writeVersion(version)
    local f = fs.open("version.txt", "w")
    f.write(version)
    f.close()
end

-- Main logic
drawHeader()
printUI("Fetching manifest...", colors.lightBlue)
local files = fetchManifest()
if not files then
    printUI("Failed to fetch manifest!", colors.red)
    return
end

printUI("Fetching version...", colors.lightBlue)
local version = fetchVersion()
if not version then
    printUI("Failed to fetch version!", colors.red)
    return
end

printUI("Installing files...\n", colors.white)
for _, path in ipairs(files) do
    if not downloadFile(path) then
        printUI("Failed to install: " .. path, colors.red)
        return
    end
end

writeVersion(version)
printUI("\nInstallation complete!", colors.green)
printUI("Installed version: " .. version, colors.cyan)
