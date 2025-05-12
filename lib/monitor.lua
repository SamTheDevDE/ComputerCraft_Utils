-- monitor.lua
-- Basic ComputerCraft: Tweaked library for monitor interaction

local monitor = {}

-- Wraps a peripheral by side or name
function monitor.wrap(side)
    local mon = peripheral.wrap(side)
    assert(mon and mon.isColor, "Not a valid monitor peripheral")
    return mon
end

-- Clears the monitor and sets cursor to top-left
function monitor.clear(mon)
    mon.setBackgroundColor(colors.black)
    mon.clear()
    mon.setCursorPos(1, 1)
end

-- Writes text at a specific position
function monitor.writeAt(mon, x, y, text, color)
    mon.setCursorPos(x, y)
    if color then mon.setTextColor(color) end
    mon.write(text)
    mon.setTextColor(colors.white)
end

-- Sets text scale
function monitor.setScale(mon, scale)
    mon.setTextScale(scale)
end

-- Gets monitor size
function monitor.getSize(mon)
    return mon.getSize()
end

return monitor