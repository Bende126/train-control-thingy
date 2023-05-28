local settings = require("options")
local peripheral_list = require("peripherals")

--[[ local message_table = {name = os.getComputerLabel(), message = "startup"}
modem.transmit(main_ch, reply_ch, message_table) ]]

local peripheralss = peripheral_list.get_peripherals()

-- peripheral list
local detector = peripheral_list.find_peripheral("train_detect", track, peripheralss)
local storage = peripheral_list.find_peripheral("color_storage", track, peripheralss)
local scan_hopper = peripheral_list.find_peripheral("train_in_color", track, peripheralss)
local return_loop = peripheral_list.find_peripheral("train_in_organizer", track, peripheralss)
local stop = peripheral_list.find_peripheral("train_stop", track, peripheralss)


local function wait_for_train()
    while true do
        local colorcode = {}

        print("Waiting for train")

        while detector.func.getInput(detector.side) ~= true do
        end

        print("The train is here")

        stop.func.setOutput(stop.side, true)

        sleep(5)

        -- load from last cart to storage barrel
        scan_hopper.func.setOutput(scan_hopper.side, false)

        sleep(2)

        for slot, item in ipairs(storage.func.list()) do
            colorcode[slot] = item
        end

        scan_hopper.func.setOutput(scan_hopper.side, true)

        -- send info to the server
        local message_table = {name = os.getComputerLabel(), message = "train at etrance", track = tonumber(string.sub(os.getComputerLabel(), -1)), color = colorcode}
        modem.transmit(main_ch, reply_ch, message_table)

        --wait for server instruction
        local event, side, channel, replyChannel, message, distance
        repeat
          event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        until channel == reply_ch
        if message.message == "ok, go" then
            return_loop.func.setOutput(return_loop.side, false)
            sleep(2)
            stop.func.setOutput(stop.side, false)
        end
        return_loop.func.setOutput(return_loop.side, true)
    end
end

local function wait_for_q()
    repeat
        local _, key = os.pullEvent("key")
    until key == keys.q
    print("Q was pressed!")
end

parallel.waitForAny(wait_for_q, wait_for_train)