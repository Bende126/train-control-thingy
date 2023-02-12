local settings = require("options")
local peripheral_list = require("peripherals")

local modem = peripheral.find("modem")
if not modem then error("No modem attached", 0) end

local main_ch = tonumber(settings.main_channel())
local reply_ch = tonumber(string.sub(os.getComputerLabel(), -1)) + 5 --different reply channel from same track computers
local track = string.sub(os.getComputerLabel(), 7)


modem.open(reply_ch)

local message_table = {name = os.getComputerLabel(), message = "startup"}
modem.transmit(main_ch, reply_ch, message_table)


local peripheralss = peripheral_list.get_peripherals()

-- peripheral list
local track_detector = peripheral_list.find_peripheral("train_detect", track, peripheralss)
local track_storage = peripheral_list.find_peripheral("color_storage", track, peripheralss)
local track_scan_hopper = peripheral_list.find_peripheral("train_in_color", track, peripheralss)
local track_return_loop = peripheral_list.find_peripheral("train_in_organizer", track, peripheralss)
local track_stop = peripheral_list.find_peripheral("train_stop", track, peripheralss)

local function wait_for_train()
    while true do
        local colorcode = {}

        print("waiting for train")

        while track_detector.func.getInput(track_detector.side) ~= true do
        end

        print("the train is here")

        track_stop.func.setOutput(track_stop.side, true)

        sleep(5)

        -- load from last cart to storage barrel
        track_scan_hopper.func.setOutput(track_scan_hopper.side, false)

        sleep(2)

        for slot, item in ipairs(track_storage.func.list()) do
            colorcode[slot] = item
        end

        -- close storage barrel loading hopper
        track_scan_hopper.func.setOutput(track_scan_hopper.side, true)
        sleep(0.1)
        -- return colors to the cart
        track_return_loop.func.setOutput(track_return_loop.side, false)
        sleep(5)

        -- close return loop
        track_return_loop.func.setOutput(track_return_loop.side, true)
        sleep(0.1)

        -- reopen storage barrel loading hopper
        track_scan_hopper.func.setOutput(track_scan_hopper.side, false)
        sleep(2)
        -- close storage barrel loading hopper
        track_scan_hopper.func.setOutput(track_scan_hopper.side, true)
        sleep(0.1)
        -- return colors to the cart
        track_return_loop.func.setOutput(track_return_loop.side, false)
        sleep(5)

    end
end

local function wait_for_q()
    repeat
        local _, key = os.pullEvent("key")
    until key == keys.q
    print("Q was pressed!")
end

parallel.waitForAny(wait_for_q, wait_for_train)