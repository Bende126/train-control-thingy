local files = {
    "station.lua",
    "startup.lua",
    "server.lua",
    "settings/main_channel.txt",
    "options.lua"
}

local header = "https://github.com/Bende126/train-control-thingy/blob/master/"

for _,i in ipairs(files) do
    local path = header .. i
    shell.run("wget", path, i)
end

