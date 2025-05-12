local monitor = require("lib.monitor")

-- Get the first available monitor
local mon = monitor.get()

-- Set scale and clear
monitor.setScale(mon, 0.5)
monitor.clear(mon, colors.blue)

-- Write centered title
monitor.writeCentered(mon, 1, "Monitor Library Demo", colors.yellow)

-- Draw a box and border
monitor.drawBox(mon, 2, 3, 26, 7, colors.gray)
monitor.drawBorder(mon, 2, 3, 26, 7, colors.lightGray)

-- Write wrapped text inside the box
local demoText = "This is a demonstration of the monitor utility library. It supports wrapping, centering, and drawing boxes."
monitor.writeWrapped(mon, 4, 5, demoText, colors.white)

-- Write at a specific position
monitor.writeAt(mon, 4, 10, "End of demo.", colors.lime)