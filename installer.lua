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
    shell.run("wget", path, i)
end

