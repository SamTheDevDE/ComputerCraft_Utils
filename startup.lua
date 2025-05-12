local function deleteAllExceptSelf(selfName)
    local items = fs.list(".")
    for _, item in ipairs(items) do
        if item ~= selfName then
            print("Deleting: " .. item)
            fs.delete(item)
        end
    end
end

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
        if line ~= "" and not string.match(line, "^#") then
            download(baseUrl .. line, line)
        end
    end

    print("Installation complete.")
end

-- 🔧 EDIT THIS URL to match your GitHub RAW base path
local baseRepoUrl = "https://github.com/SamTheDevDE/ComputerCraft_Utils/raw/refs/heads/main/"

-- 🧼 Self-clean
local selfName = shell.getRunningProgram()
deleteAllExceptSelf(selfName)

-- 🔄 Reinstall
installFromRepo(baseRepoUrl)
