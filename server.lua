local settings = require("options")
local peripheral_list = require("peripherals")

local modem = peripheral.find("modem")
if not modem then error("No modem attached", 0) end

local main_ch = tonumber(settings.main_channel())

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

local tracks_sorted = {}

for key, value in settings.pairsByKeys(tracks) do
  tracks_sorted[key] = value
end

local function first_unoccupied(track_num)
  if track_num <= 2 then
    for i=1, 3, 1 do
      if tracks_sorted[i].occupied == 0 then
        return tracks_sorted[i].track
      end
    end 
  end
  if track_num > 2 then
    for i=6, 4, -1 do
      if tracks_sorted[i].occupied == 0 then
        return tracks_sorted[i].track
      end
    end 
  end
end

local function get_route(from, to)
  --check same track
  if tonumber(from) == tonumber(to) then
    return
  end

  --check direct route
  local switch = peripheral_list.find_peripheral("train_switch:" .. from .. "-" .. to, nil, peripheralss)
  if switch then
    return switch
  end

  --check route
  local tmp = {}
  tmp[#tmp+1] = peripheral_list.partial_find("train_switch:" .. from, peripheralss)
  tmp[#tmp+1] = peripheral_list.partial_find("train_switch:" .. string.sub(tmp[1].name, -1), peripheralss)
  return tmp
end

local function train_at_entrance(tracknum)
  local target = first_unoccupied(tracknum)
  print(tracknum .. " " .. target)
  get_route(tracknum, target)
end

-- its a big ass switch
local function what_to_do(message)
  if message.message == "train at etrance" then
    train_at_entrance(message.track)
  end
end

-- left side tracks: 0, 1, 2
local function loop_left()
  while true do

    local event, side, channel, replyChannel, message, distance
    repeat
      event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == main_ch

    -- what to do with the train
    if message.track <= 2 then
      what_to_do(message)
    end

  end
end

-- right side tracks: 3, 4, 5
local function loop_right()
  while true do

    local event, side, channel, replyChannel, message, distance
    repeat
      event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == main_ch

    -- what to do with the train
    if message.track > 2 then
      what_to_do(message)
    end

  end
end

local function wait_for_q()
  repeat
      local _, key = os.pullEvent("key")
  until key == keys.q
  print("Q was pressed!")
end

parallel.waitForAny(loop_left, loop_right, wait_for_q)
