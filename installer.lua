local files = {
    "https://github.com/Bende126/train-control-thingy"
}

for _,i in ipairs(files) do
    if not shell.run("wget " .. i) then
        error("Error downloading the file" .. i, 0)
    end
end

