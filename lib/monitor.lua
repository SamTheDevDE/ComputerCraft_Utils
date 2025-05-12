-- monitor.lua
-- Enhanced ComputerCraft: Tweaked library for monitor interaction

local monitor = {}

-- Attempts to wrap a monitor peripheral by side, name, or auto-detects the first monitor
function monitor.get(sideOrName)
    local mon
    if sideOrName then
        mon = peripheral.wrap(sideOrName)
    else
        for _, name in ipairs(peripheral.getNames()) do
            if peripheral.getType(name) == "monitor" then
                mon = peripheral.wrap(name)
                break
            end
        end
    end
    assert(mon and mon.isColor, "No valid monitor peripheral found")
    return mon
end

-- Clears the monitor and resets cursor
function monitor.clear(mon, bg)
    bg = bg or colors.black
    mon.setBackgroundColor(bg)
    mon.clear()
    mon.setCursorPos(1, 1)
end

-- Sets text scale safely
function monitor.setScale(mon, scale)
    if scale then mon.setTextScale(scale) end
end

-- Gets monitor size
function monitor.getSize(mon)
    return mon.getSize()
end

-- Writes text at (x, y) with optional color
function monitor.writeAt(mon, x, y, text, color)
    mon.setCursorPos(x, y)
    if color then mon.setTextColor(color) end
    mon.write(text)
    mon.setTextColor(colors.white)
end

-- Writes centered text on a given line
function monitor.writeCentered(mon, y, text, color)
    local w = select(1, mon.getSize())
    local x = math.floor((w - #text) / 2) + 1
    monitor.writeAt(mon, x, y, text, color)
end

-- Writes text with wrapping, starting at (x, y)
function monitor.writeWrapped(mon, x, y, text, color)
    local w = select(1, mon.getSize())
    local line = ""
    local cx, cy = x, y
    for word in text:gmatch("%S+") do
        if #line + #word + 1 > w - x + 1 then
            monitor.writeAt(mon, cx, cy, line, color)
            cy = cy + 1
            line = word .. " "
        else
            line = line .. word .. " "
        end
    end
    if #line > 0 then
        monitor.writeAt(mon, cx, cy, line, color)
    end
end

-- Draws a filled box (rectangle), optionally leaving a 1-char border for use with drawBorder
function monitor.drawBox(mon, x, y, w, h, bg, inner)
    bg = bg or colors.gray
    local prevBg = mon.getBackgroundColor and mon.getBackgroundColor() or colors.black
    mon.setBackgroundColor(bg)
    local startX, endX = x, x + w - 1
    local startY, endY = y, y + h - 1
    if inner then
        startX = startX + 1
        endX = endX - 1
        startY = startY + 1
        endY = endY - 1
    end
    for j = startY, endY do
        mon.setCursorPos(startX, j)
        mon.write(string.rep(" ", math.max(0, endX - startX + 1)))
    end
    mon.setBackgroundColor(prevBg)
end

-- Draws a border box
function monitor.drawBorder(mon, x, y, w, h, color)
    color = color or colors.white
    mon.setTextColor(color)
    -- Top and bottom
    mon.setCursorPos(x, y)
    mon.write(("─"):rep(w))
    mon.setCursorPos(x, y + h - 1)
    mon.write(("─"):rep(w))
    -- Sides
    for i = 1, h - 2 do
        mon.setCursorPos(x, y + i)
        mon.write("│")
        mon.setCursorPos(x + w - 1, y + i)
        mon.write("│")
    end
    -- Corners
    mon.setCursorPos(x, y)
    mon.write("┌")
    mon.setCursorPos(x + w - 1, y)
    mon.write("┐")
    mon.setCursorPos(x, y + h - 1)
    mon.write("└")
    mon.setCursorPos(x + w - 1, y + h - 1)
    mon.write("┘")
    mon.setTextColor(colors.white)
end

return monitor