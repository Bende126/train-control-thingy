local function starts_with(text, prefix)
    return text:find(prefix, 1, true) == 1
end

local files = {
    "peripherals.lua",
    "json.lua",
    "settings.lua",
    "settings/settings.json",
    "storage_settings/files.txt",
    "storage_settings/hopper_controls.txt",
    "storage_settings/hopper_storage_controls.txt",
    "storage_settings/train_detector.txt"
}

local header = "https://raw.githubusercontent.com/Bende126/train-control-thingy/version2/"

for _,i in ipairs(files) do
    local path = header .. i
    if not shell.run("wget", path, i) then
        error("Donwload error at: ".. i, 0)
    end
end

--[[ if starts_with(os.getComputerLabel(), "color_") then
    if not shell.run("rm", files[2]) then
        error("Rm error", 0)
    end

    local path = header .. "train_detector.lua"

    if not shell.run("wget", path, "train_detector.lua") then
        error("Download error", 0)
    end

    if not shell.run("rename", "train_detector.lua", "startup.lua") then
        error("Rename error", 0)
    end
elseif starts_with(os.getComputerLabel(), "server") then
    if not shell.run("rm", files[2]) then
        error("Rm error", 0)
    end

    local path = header .. "server.lua"

    if not shell.run("wget", path, "server.lua") then
        error("Download error", 0)
    end

    if not shell.run("rename", "server.lua", "startup.lua") then
        error("Rename error", 0)
    end
end
 ]]
