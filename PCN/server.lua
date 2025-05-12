-- server.lua

local net = require("pcn_net")

-- Load config
local config = {}
if fs.exists("config.cfg") then
    for line in io.lines("config.cfg") do
        local key, value = line:match("([^=]+)=([^=]+)")
        if key and value then
            config[key] = value
        end
    end
else
    error("Missing config.cfg")
end

local serverId = tonumber(config.serverId)
local password = config.password
local authKey = config.authKey

-- Monitor detection
local monitor = peripheral.find("monitor")
if monitor then
    monitor.setTextScale(0.5)
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
    monitor.setCursorPos(1, 1)
end

-- Helper to write to screen + monitor
local function writeLog(msg, color)
    color = color or colors.white
    term.setTextColor(color)
    print(msg)
    if monitor then
        local x, y = monitor.getCursorPos()
        monitor.setTextColor(color)
        monitor.write(msg)
        monitor.setCursorPos(1, y + 1)
    end
    term.setTextColor(colors.white)
end

-- Draw header
local function drawHeader()
    term.setTextColor(colors.cyan)
    print("╔════════════════════════════════════╗")
    print("║     🛰️ PCN Server - Channel " .. serverId .. "      ║")
    print("╚════════════════════════════════════╝")
    term.setTextColor(colors.white)
    if monitor then
        monitor.setTextColor(colors.cyan)
        monitor.setCursorPos(1, 1)
        monitor.write("╔════════════════════════════════════╗\n")
        monitor.write("║     🛰️ PCN Server - Channel " .. serverId .. "      ║\n")
        monitor.write("╚════════════════════════════════════╝\n")
        monitor.setTextColor(colors.white)
        monitor.setCursorPos(1, 4)
    end
end

-- Start
os.setComputerLabel("PCN_Server_" .. tostring(serverId))
drawHeader()
writeLog("[INFO] Server started.", colors.lime)

-- Client state
local clients = {}

-- Main loop
while true do
    local senderId, rawMsg = net.receive()
    if senderId and rawMsg then
        local cmd, payload = rawMsg:match("^(%S+)%s(.+)$")
        if cmd == "AUTH" then
            if payload == password then
                clients[senderId] = true
                net.send(senderId, "AUTH_OK")
                writeLog("[AUTH] ✅ Client " .. senderId .. " authenticated.", colors.green)
            else
                net.send(senderId, "AUTH_FAIL")
                writeLog("[AUTH] ❌ Client " .. senderId .. " failed auth.", colors.red)
            end
        elseif cmd == "MSG" then
            if clients[senderId] then
                writeLog("[MSG] <" .. senderId .. "> " .. payload, colors.yellow)
                for otherId in pairs(clients) do
                    if otherId ~= senderId then
                        net.send(otherId, "MSG " .. senderId .. ": " .. payload)
                    end
                end
            else
                net.send(senderId, "ERROR Unauthorized")
                writeLog("[WARN] Blocked unauthorized message from " .. senderId, colors.orange)
            end
        else
            net.send(senderId, "ERROR InvalidCommand")
            writeLog("[WARN] Unknown command from " .. senderId, colors.lightGray)
        end
    end
end
