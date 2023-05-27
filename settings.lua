local json = require("json")

FILES = {
    "settings.json",
    "peripherals.json"
}

FOLDER = "/settings"

local function ensure_files(path)
    --[[
    Ensure config files for my unconsistent use of io
    ]]
    
    for _,i in FILES do
        local file_path = fs.combine(path, i)
        if fs.exists(file_path) == false then
            local f = fs.open(file_path, "w")
            f:write("{}")
            f:close()
        end
    end
end

local function read_settings(t)
    --[[
    read settings from the settings file
    cfile: from which settings file you want to read. Default is settings.json
    ]]

    -- named default arguments
    setmetatable(t, {__index = {cfile = "settings.json"}})
    local cfile = t.cfile

    ensure_files(FOLDER)

    local f = io.open(fs.combine(FOLDER, cfile), "r")
    local ch = f:read()
    f:close()

    return ch
end

local function write_settings(t)
    --[[
    cfile: the settings file you want to write to. The default is settings.json
    data: the data you want to write. The default is TODO
    ]]

    setmetatable(t, {__index = {
        cfile = "settings.json", 
        data = nil
    }})
    local cfile = t.cfile
    local data = t.data

    ensure_files(FOLDER)

    local f = io.open(fs.combine(FOLDER, cfile), "w")
    f:write(data)
    f:close()
end

local function get_data(t)
    --[[
    Read saved data
    cfile: the file you want to read from. The default is settings.json
    key: the key that contains your data. The default is TODO
    ]]

    setmetatable(t, {__index = {
        cfile = "settings.json", 
        key = nil
    }})
    local cfile = t.cfile
    local key = t.key
    
    local decoded = json.decode(read_settings{cfile = cfile})
    return decoded[key]
end

local function save_data(t)
    --[[
    Save data to the setting files
    cfile: the file you want to read from. The default is settings.json
    key: the key that contains your data. The default is TODO
    data: the data you want to write. If you write no data, it will do no update to the file
    ]]
    
    setmetatable(t, {__index = {
        cfile = "settings.json", 
        key = nil,
        data = nil
    }})
    local cfile = t.cfile
    local key = t.key
    local data = t.data

    local decoded = json.decode(read_settings{cfile = cfile})
    if data then
        decoded[key] = data
    end
    write_settings{cfile = cfile,data = json.encode(decoded)}
end

local function remove_data(t)
    --[[
    Save data to the setting files
    cfile: the file you want to read from. The default is settings.json
    key: the key that contains your data. The default is TODO
    ]]
    
    setmetatable(t, {__index = {
        cfile = "settings.json", 
        key = nil
    }})
    local cfile = t.cfile
    local key = t.key
    
    local decoded = json.decode(read_settings{cfile = cfile})
    decoded[key] = nil
    write_settings{cfile = cfile, data = json.encode(decoded)}
end

local function starts_with(text, prefix) -- TODO
    return text:find(prefix, 1, true) == 1
end

return {get_data = get_data, starts_with = starts_with, save_data = save_data, remove_data = remove_data}