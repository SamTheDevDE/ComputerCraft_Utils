-- URL of the script to download (replace with your desired URL)
local scriptUrl = "https://raw.githubusercontent.com/SamTheDevDE/ComputerCraft_Utils/refs/heads/main/example.lua"
local scriptPath = "downloaded_script.lua"  -- Path to save the downloaded script

-- Function to download the script using wget
local function downloadScript(url, path)
  print("Downloading script using wget...")
  local success = shell.run("wget", url, path)  -- Use wget to download the script
  if success then
    print("Script downloaded successfully.")
    return true
  else
    print("Failed to download the script.")
    return false
  end
end

-- Download the script and run it
if downloadScript(scriptUrl, scriptPath) then
  print("Running downloaded script...")
  shell.run(scriptPath)
end
