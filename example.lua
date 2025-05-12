-- Wrap the chat box peripheral
local chat = peripheral.find("chatBox")
if not chat then
  error("No Chat Box connected!")
end

print("ChatBot is running...")

-- Main loop
while true do
  local event, username, message, uuid = os.pullEvent("chat_message")
  
  -- Debug print
  print("[" .. username .. "]: " .. message)
  
  -- Command handler
  if message == "!test" then
    chat.sendMessage("Hello, " .. username .. "! This is a test response.")
  elseif message == "!time" then
    local time = os.time()
    chat.sendMessage("Current in-game time is: " .. time)
  end
end
