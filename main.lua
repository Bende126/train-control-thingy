if shell.dir() ~= "/" then shell.setDir("/") end

local settings = require("settings")
local peripheral_list = require("peripherals")
 local i = 1
for k,v in pairs(peripheral_list.get_interfaces()) do
    v.func = "-"
    settings.save_data{cfile = "peripherals.json", key = tostring(i), data = v}
    i = i+1
end
