local function download(url, dest)
    print("Downloading: " .. dest)
    local response = http.get(url)
    if response then
        local content = response.readAll()
        response.close()
        local file = fs.open(dest, "w")
        file.write(content)
        file.close()
        print("Saved: " .. dest)
    else
        print("Failed to download: " .. url)
    end
end

local function installFromRepo(baseUrl)
    local manifestUrl = baseUrl .. "manifest.txt"
    local response = http.get(manifestUrl)
    if not response then
        print("Failed to download manifest.")
        return
    end

    local manifest = response.readAll()
    response.close()

    for line in string.gmatch(manifest, "[^\r\n]+") do
        if line ~= "" and not string.match(line, "^#") then -- allow comments
            local fileUrl = baseUrl .. line
            download(fileUrl, line)
        end
    end

    print("Installation complete.")
end

-- EDIT THIS LINE with your base repo path
-- Example: "https://raw.githubusercontent.com/YourName/Repo/main/"
local baseRepoUrl = "https://github.com/SamTheDevDE/ComputerCraft_Utils/raw/refs/heads/main/"

if not http then
    print("HTTP API not enabled. Please run with HTTP API support.")
else
    installFromRepo(baseRepoUrl)
end
