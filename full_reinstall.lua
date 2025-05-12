local function deleteAllExceptSelfAndRom(selfName)
    local function isProtected(path)
        return path == selfName or path:sub(1, 4) == "rom/"
    end

    local function recursiveDelete(path)
        if isProtected(path) then return end
        if fs.isDir(path) then
            local items = fs.list(path)
            for _, item in ipairs(items) do
                recursiveDelete(fs.combine(path, item))
            end
        end
        print("Deleting: " .. path)
        fs.delete(path)
    end

    local items = fs.list("/")
    for _, item in ipairs(items) do
        recursiveDelete(item)
    end
end

local function wget(url, dest)
    print("Downloading: " .. dest)
    local result = shell.run("wget", url, dest)
    if not result then
        print("Failed to download: " .. url)
    end
end

local function installFromRepo(baseUrl)
    local manifestUrl = baseUrl .. "manifest.txt"
    local tempManifest = "__manifest_temp.txt"

    -- Download manifest
    if not shell.run("wget", manifestUrl, tempManifest) then
        print("Failed to download manifest.")
        return
    end

    -- Read and process manifest
    local file = fs.open(tempManifest, "r")
    local lines = {}
    for line in file.readLine do
        table.insert(lines, line)
    end
    file.close()
    fs.delete(tempManifest)

    -- Download each listed file
    for _, line in ipairs(lines) do
        if line ~= "" and not line:match("^#") then
            wget(baseUrl .. line, line)
        end
    end

    print("Installation complete.")
end

-- 🔧 EDIT THIS URL to your repo's raw base path
local baseRepoUrl = "https://github.com/SamTheDevDE/ComputerCraft_Utils/raw/refs/heads/main/"

-- 🧼 Clean everything except self and /rom
local selfName = shell.getRunningProgram()
deleteAllExceptSelfAndRom(selfName)

-- 🔄 Install everything
installFromRepo(baseRepoUrl)
