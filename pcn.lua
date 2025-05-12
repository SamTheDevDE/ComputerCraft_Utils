local monitor = require("lib.monitor")

-- Get the first available monitor
local mon = monitor.get()

-- Set scale and clear
monitor.setScale(mon, 0.5)
monitor.clear(mon, colors.blue)

-- Write centered title
monitor.writeCentered(mon, 1, "Monitor Library Demo", colors.yellow)

-- Draw a main gray box
monitor.drawBox(mon, 2, 3, 26, 7, colors.gray)

-- Draw a smaller white box inside for text area
monitor.drawBox(mon, 3, 4, 24, 5, colors.white)

-- Write wrapped text inside the white box
local demoText = "This is a demonstration of the monitor utility library. It supports wrapping, centering, and drawing colored boxes."
monitor.writeWrapped(mon, 4, 5, demoText, colors.black)

-- Write at a specific position
monitor.writeAt(mon, 4, 10, "End of demo.", colors.lime)