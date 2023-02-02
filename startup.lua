local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(15)

modem.transmit(43, 15, os.getComputerLabel())

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

