local settings = require("options")
local peripheral_list = require("peripherals")

local modem = peripheral.find("modem")
if not modem then error("No modem attached", 0) end

local main_ch = tonumber(settings.main_channel())
local reply_ch = tonumber(string.sub(os.getComputerLabel(), -1)) + 5 --different reply channel from same track computers
local track = string.sub(os.getComputerLabel(), 7)

modem.open(reply_ch)

--[[ local message_table = {name = os.getComputerLabel(), message = "startup"}
modem.transmit(main_ch, reply_ch, message_table) ]]

local peripheralss = peripheral_list.get_peripherals()

-- peripheral list
local detector = peripheral_list.find_peripheral("train_detect", track, peripheralss)
local storage = peripheral_list.find_peripheral("color_storage", track, peripheralss)
local scan_hopper = peripheral_list.find_peripheral("train_in_color", track, peripheralss)
local return_loop = peripheral_list.find_peripheral("train_in_organizer", track, peripheralss)
local stop = peripheral_list.find_peripheral("train_stop", track, peripheralss)


-- its necessary if color sequence matters
local function item_spin()
    -- close storage barrel loading hopper
    scan_hopper.func.setOutput(scan_hopper.side, true)
    sleep(0.1)
    -- return colors to the cart
    return_loop.func.setOutput(return_loop.side, false)
    sleep(5)
    
    -- close return loop
    return_loop.func.setOutput(return_loop.side, true)
    sleep(0.1)
    
    -- reopen storage barrel loading hopper
    scan_hopper.func.setOutput(scan_hopper.side, false)
    sleep(2)
    -- close storage barrel loading hopper
    scan_hopper.func.setOutput(scan_hopper.side, true)
    sleep(0.1)
    -- return colors to the cart
    return_loop.func.setOutput(return_loop.side, false)
    sleep(5)
end

local function recv_message()
    local event, side, channel, replyChannel, message, distance
    repeat
      event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == reply_ch
end

local function wait_for_train()
    while true do
        local colorcode = {}

        print("waiting for train")

        while detector.func.getInput(detector.side) ~= true do
        end

        print("the train is here")

        stop.func.setOutput(stop.side, true)

        sleep(5)

        -- load from last cart to storage barrel
        scan_hopper.func.setOutput(scan_hopper.side, false)

        sleep(2)

        for slot, item in ipairs(storage.func.list()) do
            colorcode[slot] = item
        end

        -- send info to the server
        local message_table = {name = os.getComputerLabel(), message = "train at etrance", track = tonumber(string.sub(os.getComputerLabel(), -1)), color = colorcode}
        modem.transmit(main_ch, reply_ch, message_table)

        item_spin()

    end
end

local function wait_for_q()
    repeat
        local _, key = os.pullEvent("key")
    until key == keys.q
    print("Q was pressed!")
end

parallel.waitForAny(wait_for_q, wait_for_train)