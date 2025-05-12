local basalt = require("basalt")

-- Get a reference to the monitor
local monitor = peripheral.find("monitor") 
-- Or specific side: peripheral.wrap("right")

-- Create frame for monitor
local monitorFrame = basalt.createFrame():setTerm(monitor) -- :setTerm is the important method here

-- Add elements like normal
monitorFrame:addButton()
    :setText("Monitor Button")
    :setWidth(24)
    :setPosition(2, 2)

-- Start Basalt
basalt.run()