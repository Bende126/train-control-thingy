local files = {
    "peripherals.lua",
    "json.lua",
    "settings.lua",
    "storage_settings/files.txt",
    "storage_settings/hopper_controls.txt",
    "storage_settings/hopper_storage_controls.txt",
    "storage_settings/train_detector.txt"
}

local header = "https://raw.githubusercontent.com/Bende126/train-control-thingy/version2/"

for _,i in ipairs(files) do
    local path = header .. i

    if not shell.run("rm", i) then
        error("Rm error at: ".. i, 0)
    end

    sleep(1)
    
    if not shell.run("wget", path, i) then
        error("Donwload error at: ".. i, 0)
    end
end

if not shell.run("wget", "https://cloud-catcher.squiddev.cc/cloud.lua") then
    error("Donwload error at: cloud.lua", 0)
end

print("Finished downloading the files")

sleep(5)
if not shell.run("clear") then
    error("Shell error at clear", 0)
end

