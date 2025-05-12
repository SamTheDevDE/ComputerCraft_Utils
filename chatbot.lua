-- Wrap the chat box peripheral
local chat = peripheral.find("chatBox")
if not chat then
  error("No Chat Box connected!")
end

-- Announce that the chatbot is listening
chat.sendMessage("Chatbot is now listening to the chat!")

-- Main loop to listen for chat messages
while true do
  local event, username, message, uuid = os.pullEvent("chat")
  
  -- Debug print (optional)
  print("[" .. username .. "]: " .. message)
  
  -- Check if the message starts with a command (e.g., !test)
  if string.sub(message, 1, 1) == "!" then
    -- Strip the command (first word) and check against known commands
    local command = string.lower(message:match("^%S+"))
    
    -- Command handler for !test
    if command == "!test" then
      chat.sendMessage("Hello, " .. username .. "! This is a test response.")
    
    -- Command handler for !time
    elseif command == "!time" then
      local time = os.time()
      chat.sendMessage("Current in-game time is: " .. time)
    
    -- You can add more commands here
    else
      chat.sendMessage("Unknown command: " .. command)
    end
  end
end
