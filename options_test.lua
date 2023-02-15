local options = require("options")
local qmanager = require("queue_manager")

options.save_data("main channel", 43)

local tmp = {}
tmp["asd"] = 12
tmp["message"] = "testing"

qmanager.add_queue(tmp, "left_side", 1)