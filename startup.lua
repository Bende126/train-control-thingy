local settings = require("options")
local peripheral_list = require("peripherals")

local modem = peripheral.find("modem")
if not modem then error("No modem attached", 0) end

local me_system = peripheral.find("meBridge")
if not me_system then error("No ME attached", 0) end

local main_ch = tonumber(settings.main_channel())
local reply_ch = tonumber(string.sub(os.getComputerLabel(), -1)) + 10

local track = os.getComputerLabel()

modem.open(reply_ch)

local startup_message = {name = os.getComputerLabel(), message = "startup", track = tonumber(string.sub(os.getComputerLabel(), -1))}
modem.transmit(main_ch, reply_ch, startup_message)

local peripheralss = peripheral_list.get_peripherals()

local hopper_storage_in = peripheral_list.find_peripheral("hopper_storage_in", track, peripheralss)
local hopper_storage_out = peripheral_list.find_peripheral("hopper_storage_out", track, peripheralss)

local hopper_in = peripheral_list.find_peripheral("hopper_in", track, peripheralss)
local hopper_out = peripheral_list.find_peripheral("hopper_out", track, peripheralss)

local track_stop = peripheral_list.find_peripheral("track_stop", track, peripheralss)
local track_detect = peripheral_list.find_peripheral("track_detect", track, peripheralss)

-- inversed redstone controls for better readability
local function set_hoppers(input, output)
  hopper_in.func.setOutput(hopper_in.side, not input)
  hopper_out.func.setOutput(hopper_in.side, not output)
end

-- stop loading/unloading from the start
set_hoppers(false, false)

local function loop()
  while true do
    print("Waiting for train")

    while track_detect.func.getInput(track_detect.side) ~= true do
    end

    print("Train is here")

    track_stop.func.setOutput(track_stop.side, true)

    -- what to do with the train

  end
end

local function wait_for_q()
  repeat
      local _, key = os.pullEvent("key")
  until key == keys.q
  print("Q was pressed!")
end

parallel.waitForAny(loop, wait_for_q)

