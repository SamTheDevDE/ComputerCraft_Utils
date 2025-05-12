local demoText = "This is a demonstration of the monitor utility library. It supports wrapping, centering, and drawing colored boxes."
local textWidth = 24
local textX, textY = 4, 5
local textBg = colors.white

-- Calculate required height for the wrapped text
local textHeight = monitor.getWrappedHeight(demoText, textWidth)

-- Draw the white box for the text area, sized to fit the text
monitor.drawBox(mon, textX, textY, textWidth, textHeight, textBg)

-- Write wrapped text with matching background
monitor.writeWrapped(mon, textX, textY, demoText, colors.black, textBg)