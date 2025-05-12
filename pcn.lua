local basalt = require("basalt")

-- Get a reference to the monitor
local monitor = peripheral.find("monitor")

-- Create frame for monitor
local monitorFrame = basalt.createFrame():setTerm(monitor)

-- Title label
monitorFrame:addLabel()
    :setText("Login")
    :setPosition(10, 2)
    :setForeground(colors.yellow)
    :setBackground(colors.blue)

-- Username label and input
monitorFrame:addLabel()
    :setText("Username:")
    :setPosition(5, 5)
monitorFrame:addInput()
    :setPosition(15, 5)
    :setSize(15, 1)
    :setDefaultText("")

-- Password label and input
monitorFrame:addLabel()
    :setText("Password:")
    :setPosition(5, 7)
monitorFrame:addInput()
    :setPosition(15, 7)
    :setSize(15, 1)
    :setInputType("password")

-- Login button
monitorFrame:addButton()
    :setText("Login")
    :setPosition(12, 10)
    :setSize(10, 1)

-- Start Basalt
basalt.run()