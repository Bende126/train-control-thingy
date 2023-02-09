local peripheral_list = require("peripherals")

local function wait_for_train()
    while true do
        local colorcode = {}
        -- colorcode detector peripherals
        local track2_detector = peripheral_list.find_peripheral("train_detect", "track_2")
        local track2_storage = peripheral_list.find_peripheral("color_storage", "track_2")
        local track2_scan_hopper = peripheral_list.find_peripheral("train_in_color", "track_2")
        local track2_return_loop = peripheral_list.find_peripheral("train_in_organizer", "track_2")
        local track2_stop = peripheral_list.find_peripheral("train_stop", "track_2")

        print("waiting for train")

        while track2_detector.func.getInput(track2_detector.side) ~= true do
        end

        print("the train is here")

        track2_stop.func.setOutput(track2_stop.side, true)

        sleep(5)

        -- load from last cart to storage barrel
        track2_scan_hopper.func.setOutput(track2_scan_hopper.side, false)

        sleep(2)

        for slot, item in ipairs(track2_storage.func.list()) do
            colorcode[slot] = item
        end

        -- close storage barrel loading hopper
        track2_scan_hopper.func.setOutput(track2_scan_hopper.side, true)
        sleep(0.1)
        -- return colors to the cart
        track2_return_loop.func.setOutput(track2_return_loop.side, false)
        sleep(5)

        -- close return loop
        track2_return_loop.func.setOutput(track2_return_loop.side, true)
        sleep(0.1)

        -- reopen storage barrel loading hopper
        track2_scan_hopper.func.setOutput(track2_scan_hopper.side, false)
        sleep(2)
        -- close storage barrel loading hopper
        track2_scan_hopper.func.setOutput(track2_scan_hopper.side, true)
        sleep(0.1)
        -- return colors to the cart
        track2_return_loop.func.setOutput(track2_return_loop.side, false)
        sleep(5)

        for i, item in ipairs(colorcode) do
            print(item.name)
        end

    end
end

local function wait_for_q()
    repeat
        local _, key = os.pullEvent("key")
    until key == keys.q
    print("Q was pressed!")
end

parallel.waitForAny(wait_for_q, wait_for_train)