local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(43) -- receives messages from other computers on this channel

local tracks = {}

local computers = {peripheral.find("computer")}

local function wait_for_response()
  local event, side, channel, replyChannel, message, distance
  repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
  until channel == 43
  print(message)
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


