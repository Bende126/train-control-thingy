local settings = require("options")
local peripheral_list = require("peripherals")
local qmanager = require("queue_manager")

local modem = peripheral.find("modem")
if not modem then error("No modem attached", 0) end

local main_ch = tonumber(settings.get_data("main channel"))

modem.open(main_ch) -- receives messages from other computers on this channel

local tracks = {}
local peripheralss = peripheral_list.get_peripherals()

local computers = {peripheral.find("computer")}

local function wait_for_response()
  local event, side, channel, replyChannel, message, distance
  repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
  until channel == main_ch
  if message.message == "startup" then
    local tmp = {occupied = 0, replych = replyChannel, loaded = 0, unloaded = 0, track = message.track}
    tracks[message.name] = tmp
  end
end

local function five_sec_timer()
  local timer_id = os.startTimer(5)
  local event, id
  repeat
    event, id = os.pullEvent("timer")
  until id == timer_id
  print("Timer with ID " .. id .. " was fired")
end

for i, comp in pairs(computers) do
  if comp.isOn() then
    comp.reboot()
  else
    comp.turnOn()
  end
  print("waiting")
  parallel.waitForAny(wait_for_response, five_sec_timer)
  print("done")
end

local function first_unoccupied(track_num)
  if track_num <= 2 then
    for i=1, 3, 1 do
      if tracks["track_"..i-1].occupied == 0 then
        return tracks["track_" .. i-1].track
      end
    end 
  end
  if track_num > 2 then
    for i=6, 4, -1 do
      if tracks["track_"..i-1].occupied == 0 then
        return tracks["track_"..i-1].track
      end
    end 
  end
end

local function set_route(from, to, input)
  --check same track
  if tonumber(from) == tonumber(to) then
    return
  end

  --check route with 1 switch
  local switch = peripheral_list.find_peripheral("train_switch:" .. from .. "-" .. to, nil, peripheralss)
  if switch then
    switch.func.setOutput(switch.side, input)
    return
  end

  --check route with 2 switches
  local first = peripheral_list.partial_find("train_switch:" .. from, peripheralss)
  local second = peripheral_list.partial_find("train_switch:" .. string.sub(first.name, -1), peripheralss)

  if first and second then
    first.func.setOutput(first.side, input)
    second.func.setOutput(second.side, input)
    return
  end

end

local function train_at_entrance(tracknum)
  local target = first_unoccupied(tracknum)
  set_route(tracknum, target, true)
  tracks["track_" .. target].occupied = 1
end

-- its a big ass switch
local function what_to_do(message)
  if message.message == "train at etrance" then
    train_at_entrance(message.track)
  end
end

local function recv_message()
  local event, side, channel, replyChannel, message, distance
    repeat
      event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == main_ch

    if message.track <= 2 then
      qmanager.add_queue(message, "left side")
    elseif message.track > 2 then
      qmanager.add_queue(message, "right side")
    end
end

-- left side tracks: 0, 1, 2
local function loop_left()
  while true do

  end
end

-- right side tracks: 3, 4, 5
local function loop_right()
  while true do

  end
end

local function wait_for_q()
  repeat
      local _, key = os.pullEvent("key")
  until key == keys.q
  print("Q was pressed!")
end

parallel.waitForAny(loop_left, loop_right, wait_for_q, recv_message)
