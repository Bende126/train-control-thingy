local files = {
    "options.lua",
    "startup.lua",
    "peripherals.lua",
    "settings/main_channel.txt",
    "storage_settings/files.txt",
    "storage_settings/hopper_controls.txt",
    "storage_settings/hopper_storage_controls.txt",
    "storage_settings/train_detector.txt"
}

local header = "https://raw.githubusercontent.com/Bende126/train-control-thingy/master/"

for _,i in ipairs(files) do
    local path = header .. i
    if not shell.run("wget", path, i) then
        error("Donwload error at: ".. i, 0)
    end
end

local settings = require("options")

if settings.starts_with(os.getComputerLabel(), "color_") then
    if not shell.run("rm", files[2]) then
        error("Rm error", 0)
    end

    local path = header .. "train_detector.lua"

    if not shell.run("wget", path, "train_detector.lua") then
        error("Download error", 0)
    end

    if not shell.run("rename", "train_detector.lua", "startup.lua") then
        error("Download error", 0)
    end
end

