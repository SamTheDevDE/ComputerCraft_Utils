-- Path to the script you want to download (replace with your URL)
local scriptUrl = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/refs/heads/main/example.lua"
local scriptPath = "example.lua"  -- This is the file to store the downloaded script.

-- Function to remove old startup script
local function removeOldScript()
  if fs.exists(scriptPath) then
    fs.delete(scriptPath)
    print("Old script removed.")
  else
    print("No old script found.")
  end
end

-- Function to download the new script
local function downloadNewScript()
  local success, err = pcall(function()
    http.request(scriptUrl)
  end)

  if not success then
    print("Error with the HTTP request:", err)
    return
  end

  -- Wait for the download to complete
  while true do
    local event, url, response = os.pullEvent("http_response")
    if url == scriptUrl then
      if response then
        local file = fs.open(scriptPath, "w")
        file.write(response.readAll())
        file.close()
        print("New script downloaded successfully!")
      else
        print("Failed to download the script.")
      end
      break
    end
  end
end

-- Run the functions
removeOldScript()
downloadNewScript()

-- Optionally, you can execute the downloaded script
-- shell.run(scriptPath)
