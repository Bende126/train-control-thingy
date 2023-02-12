local settings = require("options")

local modem = peripheral.find("modem")
if not modem then error("No modem attached", 0) end

local main_ch = tonumber(settings.main_channel())

modem.open(main_ch) -- receives messages from other computers on this channel

local tracks = {}

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

local function loop()
  while true do

    local event, side, channel, replyChannel, message, distance
    repeat
      event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == main_ch

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
