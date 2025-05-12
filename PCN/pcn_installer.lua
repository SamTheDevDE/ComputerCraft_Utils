-- PCN Installer
term.clear()
term.setCursorPos(1,1)
print("=== PCN Installer ===")
write("Install as server or client? (s/c): ")
local mode = read()

local baseURL = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/main/PCN/"
local function download(file, target)
    target = target or file
    print("Downloading " .. target .. "...")
    local response = http.get(baseURL .. file)
    if response then
        local content = response.readAll()
        response.close()
        local f = fs.open(target, "w")
        f.write(content)
        f.close()
        print("✓ " .. target .. " installed.")
    else
        print("✗ Failed to download " .. file)
    end
end

-- Download shared files
download("startup.lua")
download("pcn_update.lua")
download("shared/encryption", "shared/encryption")

-- Download role-specific files
if mode == "s" then
    download("server.lua")
    if not fs.exists("server_config") then
        local f = fs.open("server_config", "w")
        f.writeLine("server001")      -- default server ID
        f.writeLine("authKey123")     -- default auth key
        f.close()
    end
    print("✓ Server installed successfully.")
elseif mode == "c" then
    download("client.lua")
    if not fs.exists("client_config") then
        term.clear()
        print("Creating client_config...")
        write("Enter server ID: ")
        local sid = read()
        write("Enter client ID (3 digits max): ")
        local cid = read()
        write("Enter auth key: ")
        local auth = read("*")
        local f = fs.open("client_config", "w")
        f.writeLine(sid)
        f.writeLine(cid)
        f.writeLine(auth)
        f.close()
    end
    print("✓ Client installed successfully.")
else
    print("✗ Invalid mode selected.")
end

print("\nReboot to launch PCN.")
