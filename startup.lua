-- URL of the script to download (replace with your desired URL)
local scriptUrl = "https://raw.githubusercontent.com/username/repo/main/script.lua"
local scriptPath = "downloaded_script.lua"  -- Path to save the downloaded script

-- Function to download the script
local function downloadScript(url, path)
  print("Downloading script...")
  local success, err = pcall(function()
    http.request(url)
  end)

  if not success then
    print("Error with the HTTP request:", err)
    return false
  end

  -- Wait for the download to finish
  while true do
    local event, url, response = os.pullEvent("http_response")
    if url == scriptUrl then
      if response then
        local file = fs.open(path, "w")
        file.write(response.readAll())
        file.close()
        print("Script downloaded successfully.")
      else
        print("Failed to download the script.")
      end
      break
    end
  end
  return true
end

-- Download the script and run it
if downloadScript(scriptUrl, scriptPath) then
  print("Running downloaded script...")
  shell.run(scriptPath)
end
