local modem = peripheral.find("modem")
if not modem then error("No modem attached", 0) end

local settings = require("options")

local main_ch = tonumber(settings.main_channel())

modem.open(main_ch) -- receives messages from other computers on this channel

local tracks = {}

local computers = {peripheral.find("computer")}

local function wait_for_response()
  local event, side, channel, replyChannel, message, distance
  repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
  until channel == main_ch
  -- print(message)
  if message.message == "startup" then
    local tmp = {occupied = 0, replych = replyChannel}
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

for key, value in pairs(tracks) do
  print(key .. " " .. value.replych .. " " .. value.occupied)
end


local function navigation()
  while true do

    local event, side, channel, replyChannel, message, distance
    repeat
      event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == settings.main_channel()



  end
end
