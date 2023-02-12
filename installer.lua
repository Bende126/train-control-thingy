local files = {
    "https://github.com/Bende126/train-control-thingy/tree/master/settings",
    "https://github.com/Bende126/train-control-thingy/tree/master/storage_settings"
}

for _,i in ipairs(files) do
    if not shell.run("wget " .. i) then
        error("Error downloading the file" .. i, 0)
    end
end

