if shell.dir() ~= "/" then shell.setDir("/") end

local settings = require("settings")
local peripheral_list = require("peripherals")

print(peripheral_list.get_interfaces())