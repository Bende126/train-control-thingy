local json = require("json")
local options = require("options")

local function ensure_path(path)
    local path_ = "./" .. path
    if fs.exists(path_) and fs.isDir(path_) then
        return
    end
    fs.makeDir(path_)
end

local function ensure_settings(path)
    if not options.get_data(path) then
       local tmp = {}
       tmp["sequence index"] = 1
       tmp["queue"] = {}
       options.save_data(path, tmp) 
    end
end

local function save_to_file(path, data)
    local waiting_list = options.get_data(path)
    local filename = waiting_list["sequence index"] .. ".json"
    local path_to_file = fs.combine(path, filename)

    local tmp = {}
    tmp["path"] = path_to_file
    tmp["priority"] = 1

    waiting_list["queue"][waiting_list["sequence index"]] = tmp
    waiting_list["sequence index"] = waiting_list["sequence index"] + 1

    local f = io.open(path_to_file, "w")
    if f == nil then
        error("Error at save_to_file", 0)
    end
    f:write(json.encode(data))
    f:close()

    options.save_data(path, waiting_list)
end

local function add_queue(data, path)
    if not path then
        path = "queue"
    end
    ensure_path(path)
    ensure_settings(path)
    save_to_file(path, data)
end

local function get_first(path)
    
end

return {add_queue = add_queue, get_first = get_first}