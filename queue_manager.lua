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

local function save_to_file(path, data, priority)
    local waiting_list = options.get_data(path)
    local filename = waiting_list["sequence index"] .. ".json"
    local path_to_file = fs.combine(path, filename)

    local tmp = {}
    tmp["path"] = path_to_file
    tmp["priority"] = priority

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

local function del_file(data)
    if fs.exists(data.path) then
        fs.delete(data.path)
    end
end

local function add_queue(data, path, priority)
    if not path then
        path = "queue"
    end

    if not priority then
        priority = 1
    end
    
    ensure_path(path)
    ensure_settings(path)
    save_to_file(path, data, priority)
end

local function get_first(path)
    local waiting_list = options.get_data(path)
    return waiting_list["queue"][1]
end

local function remove_queue(path, data)
    local waiting_list = options.get_data(path)
    for i, v in ipairs(waiting_list["queue"]) do
        if v.path == data.path and v.priority == data.priority then
            del_file(data)
            waiting_list["queue"][i] = nil
        end
    end
    options.save_data(path, waiting_list)
end

local function get_priority(path)
    local waiting_list = options.get_data(path)
    local max_prio = 0
    local index = 0
    for i,v in ipairs(waiting_list["queue"]) do 
        if v.priority >= max_prio then
            max_prio = v.priority
            index = i
        end
    end
    return waiting_list["queue"][index]
end

return {add_queue = add_queue, get_first = get_first, get_priority = get_priority, remove_queue = remove_queue}