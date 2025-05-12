-- client.lua
local net = require("pcn_net")
local config = {}

-- Load config
for line in io.lines("config.cfg") do
    local k, v = line:match("([^=]+)=([^=]+)")
    if k and v then config[k] = v end
end

-- Setup
os.setComputerLabel("PCN_Client")
term.setTextColor(colors.cyan)
print("╔═══════════════════════════════╗")
print("║     🤖 PCN Client Terminal      ║")
print("╚═══════════════════════════════╝")
term.setTextColor(colors.white)
print("Connecting to server " .. config.serverId .. "...")

-- Helper
local function log(msg, color)
    term.setTextColor(color or colors.gray)
    print("[Client] " .. msg)
    term.setTextColor(colors.white)
end

-- Authenticate
net.send(tonumber(config.serverId), "AUTH " .. config.password)

local authenticated = false

while true do
    if not authenticated then
        local from, msg = net.receive(5)
        if msg == "AUTH_OK" then
            log("✅ Authenticated!", colors.lime)
            authenticated = true
        elseif msg == "AUTH_FAIL" then
            log("❌ Authentication failed.", colors.red)
            return
        end
    else
        parallel.waitForAny(
            function()
                term.setTextColor(colors.gray)
                write("> ")
                term.setTextColor(colors.white)
                local input = read()
                if #input > 0 then
                    net.send(tonumber(config.serverId), "MSG " .. input)
                end
            end,
            function()
                local from, msg = net.receive()
                if msg then
                    log(msg, colors.lightBlue)
                end
            end
        )
    end
end
