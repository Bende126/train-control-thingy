local settings = require("options")

local modem = peripheral.find("modem")
if not modem then error("No modem attached", 0) end

local main_ch = tonumber(settings.main_channel())
local reply_ch = tonumber(string.sub(os.getComputerLabel(), -1)) + 10

print(main_ch .. " > " .. reply_ch)

modem.open(reply_ch)

local message_table = {name = os.getComputerLabel(), message = "startup"}
modem.transmit(main_ch, reply_ch, message_table)

local peripheral_list = require("peripherals")

local peripheralss = peripheral_list.get_peripherals()

local hopper_storage_in = peripheral_list.find_peripheral("hopper_storage_in", os.getComputerLabel(), peripheralss)
local hopper_storage_out = peripheral_list.find_peripheral("hopper_storage_out", os.getComputerLabel(), peripheralss)

local hopper_in = peripheral_list.find_peripheral("hopper_in", os.getComputerLabel(), peripheralss)
local hopper_out = peripheral_list.find_peripheral("hopper_out", os.getComputerLabel(), peripheralss)

local track_stop = peripheral_list.find_peripheral("track_stop", os.getComputerLabel(), peripheralss)

local track_detect = peripheral_list.find_peripheral("track_detect", os.getComputerLabel(), peripheralss)

hopper_in.func.setOutput(hopper_in.side, true)
hopper_out.func.setOutput(hopper_in.side, true)

local function loop()
  while true do
    print("Waiting for train")

    while track_detect.func.getInput(track_detect.side) ~= true do
    end

    print("Train is here")

    track_stop.func.setOutput(track_stop.side, true)

    -- mit kell csinálni

    sleep(10)

    track_stop.func.setOutput(track_stop.side, false)

  end
end

parallel.waitForAny(loop)

