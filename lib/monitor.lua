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

function monitor.writeWrapped(mon, x, y, text, color, bg)
    local w = select(1, mon.getSize())
    local line = ""
    local cx, cy = x, y
    for word in text:gmatch("%S+") do
        if #line + #word + 1 > w - x + 1 then
            if bg then mon.setBackgroundColor(bg) end
            monitor.writeAt(mon, cx, cy, line, color)
            cy = cy + 1
            line = word .. " "
        else
            line = line .. word .. " "
        end
    end
    if #line > 0 then
        if bg then mon.setBackgroundColor(bg) end
        monitor.writeAt(mon, cx, cy, line, color)
    end
    if bg then mon.setBackgroundColor(colors.black) end
end

-- Draws a filled box (rectangle), optionally leaving a 1-char border for use with drawBorder
-- If colorOnly is true, only changes background color without overwriting text
function monitor.drawBox(mon, x, y, w, h, bg, inner, colorOnly)
    bg = bg or colors.gray
    local prevBg = mon.getBackgroundColor and mon.getBackgroundColor() or colors.black
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
        if colorOnly then
            -- Only set background color for each cell, don't overwrite text
            for i = startX, endX do
                mon.setCursorPos(i, j)
                mon.setBackgroundColor(bg)
                -- No write!
            end
        else
            mon.setBackgroundColor(bg)
            mon.write(string.rep(" ", math.max(0, endX - startX + 1)))
        end
    end
    mon.setBackgroundColor(prevBg)
end
-- Returns how many lines the wrapped text will take on the monitor, given width
function monitor.getWrappedHeight(text, width)
    local line, lines = "", 1
    for word in text:gmatch("%S+") do
        if #line + #word + 1 > width then
            lines = lines + 1
            line = word .. " "
        else
            line = line .. word .. " "
        end
    end
    return lines
end

return monitor