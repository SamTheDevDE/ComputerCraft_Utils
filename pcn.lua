local monitor = require "lib.monitor"

monitor.writeAt(monitor, 1, 1, "Hello, world!", colors.red)
monitor.setScale(monitor, 2)
local width, height = monitor.getSize(monitor)
monitor.writeAt(monitor, 1, 3, "Monitor size: " .. width .. "x" .. height, colors.green)
monitor.clear(monitor)