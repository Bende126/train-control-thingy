local function find_peripheral(name, track, interfaces)
  if track == nil then
    for i, line in ipairs(interfaces) do
      if line.name == name then return line
      end
    end
  else
    for i, line in ipairs(interfaces) do
      if line.name == name and line.track == track then return line
      end
    end
  end
end
  
  local function get_peripherals()
  
    local interfaces = {}

    InterFace = {name = 0, id = 0, track = 0, side = 0, io = 0, func = 0}

    function InterFace:new(o)
      o = o or {}
      setmetatable(o, self)
      self.__index = self
      return o
    end
  
  -- creates an array based on preset keywords
    local function mysplit (inputstr)
        local sep = "%s"
        local tmp={}
        local preset = {"name", "id", "track", "side", "io", "func"}
        local i = 1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
          local key = string.format(preset[i])
          tmp[key] = str
          i = i+1
        end
        return InterFace:new(tmp)
    end
  
  -- checks the file
    local function file_exists(file)
      local f = io.open(file, "rb")
      if f then f:close() end
      return f ~= nil
    end
  
  -- get all lines from a file, returns an empty
  -- list/table if the file does not exist
    local function lines_from(file, class)
      local lines = {}
      for line in io.lines(file) do
        if string.len(line) > 0 then
          if class then
            lines[#lines + 1] = mysplit(line)
          else
            lines[#lines + 1] = line
          end
        end
      end
      return lines
    end
  
  -- creates a merged list of peripherals
    local function create_merged(files)
      for i, filename in ipairs(files) do
        if file_exists(filename) then
          print("Now loading " .. filename)
          local tmp = lines_from(filename, true)
          for j, filename in ipairs(tmp) do
            interfaces[#interfaces+1] = tmp[j]
          end
        else
          print(filename .. " doesnt exists. Skipping file")
        end
      end
    end
  
    local file = 'storage_settings/files.txt'
    local files = lines_from(file, false)
  
    create_merged(files)
  
  -- wrap all the peripherals in the list
    for i, line in ipairs(interfaces) do
      for key, value in pairs(line) do
        if peripheral.isPresent(line.id) then
          line.func = peripheral.wrap(line.id)
        end
      end
    end
  
    return interfaces
  
  end
  
  return {get_peripherals = get_peripherals, find_peripheral = find_peripheral}