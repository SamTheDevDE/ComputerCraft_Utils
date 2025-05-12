local configPath = "config.cfg"

-- Skip if config already exists
if fs.exists(configPath) then
    print("Configuration already exists at " .. configPath)
    return
end

print("=== Configuration Setup ===")

-- Ask for each setting
local function ask(question, validator)
    while true do
        write(question .. " ")
        local input = read()
        if validator == nil or validator(input) then
            return input
        else
            print("Invalid input, try again.")
        end
    end
end

-- Example: ask for server ID (must be number)
local serverId = ask("Enter your Server ID (number):", function(v)
    return tonumber(v) ~= nil
end)

-- Example: ask for password (non-empty)
local password = ask("Enter the server password:", function(v)
    return #v > 0
end)

-- Example: ask for auth key
local authKey = ask("Enter the authorization key:", function(v)
    return #v > 0
end)

-- Save configuration
local file = fs.open(configPath, "w")
file.writeLine("serverId=" .. serverId)
file.writeLine("password=" .. password)
file.writeLine("authKey=" .. authKey)
file.close()

print("✅ Configuration saved to " .. configPath)
