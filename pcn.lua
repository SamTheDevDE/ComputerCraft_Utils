local basalt = require("basalt")

-- Get the main frame (your window)
local main = basalt.getMainFrame()

-- Add a button
main:addButton()
    :setText("Click me!")
    :setPosition(4, 4)
    :onClick(function()
        -- Do something when clicked
    end)

-- Start Basalt
basalt.run()