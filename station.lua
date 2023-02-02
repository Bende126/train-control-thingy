local files = {}
local peripheralss = {}

local me_system = peripheral.find("meBridge")
if not me_system then error("ME bridge error") end

local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(15) -- receives messages from other computers on this channel

modem.transmit(43, 15, os.getComputerLabel())

local preset = {"control", "name", "track", "side", "io", "func"}

--[[ local function starts_with(String,Start)
  return string.sub(String,1,string.len(Start))==Start
end
 ]]

local function starts_with(text, prefix)
  return text:find(prefix, 1, true) == 1
end

local function find_peripheral(control, track)
  for i, line in ipairs(peripheralss) do
    if line.control == control and line.track == track then return line
    end
  end
end

-- létrehozza a dictionaryt a preset alapján
local function mysplit (inputstr)
    local sep = "%s"
    local tmp={}
    local i = 1;
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      local key = string.format(preset[i])
      tmp[key] = str
      i = i+1
    end
    return tmp
end

local function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
local function lines_from(file, class)
  local lines = {}
  for line in io.lines(file) do
    if string.len(line) > 0 then
      if class then
        lines[#lines + 1] = mysplit(line)
      else
        lines[#lines + 1] = line
      end
    end
  end
  return lines
end

local function create_merged(files)
  for i, filename in ipairs(files) do
    if file_exists(filename) then
      print("Now loading " .. filename)
      local tmp = lines_from(filename, true)
      for j, filename in ipairs(tmp) do
        peripheralss[#peripheralss+1] = tmp[j]
      end
    else
      print(filename .. " doesnt exists. Skipping file")
    end
  end
end

local file = 'settings/files.txt'
local files = lines_from(file, false)

create_merged(files)

-- funkciók hozzárendelése
for i, line in ipairs(peripheralss) do
  for key, value in pairs(line) do
    if peripheral.isPresent(line.name) then
      line.func = peripheral.wrap(line.name)
    end
  end
end

--[[ --test from track_0 to me system

for i, line in ipairs(peripheralss) do
  if line.track == "track_0" and line.control == "hopper_storage_in" and line.func ~= nil then
    for slot, item in ipairs(line.func.list()) do
      me_system.importItemFromPeripheral(item, peripheral.getName(line.func))
    end
  end
end

--test from me_system to track_5, item/items needed as table

for i, line in ipairs(peripheralss) do
  if line.track == "track_5" and line.control == "hopper_storage_out" and line.func ~= nil then
    for slot, item in ipairs(line.func.list()) do
      me_system.importItemFromPeripheral(item, peripheral.getName(line.func))
    end
  end
end ]]

--[[ for i, line in ipairs(peripheralss) do
  print(line.control .. " " .. line.name)
  sleep(0.5)
end

print("---") ]]

--[[ for i, line in ipairs(peripheralss) do
  if line.func ~= nil then
    if starts_with(line.control, "track_stop") then
      line.func.setOutput(line.side, true)
      print(line.control .. " " .. line.name)
    end
  end
end

]]

--basic setting
for i, line in ipairs(peripheralss) do
  if line.func ~= nil then
    if starts_with(line.control, "hopper") or starts_with(line.control, "train_in") then
      if line.io == "output" then
        line.func.setOutput(line.side, true)
        --print(line.control .. " " .. line.name)
      end
    else
      if line.io == "output" then
        line.func.setOutput(line.side, false)
      end
    end
  end
end

--[[ local function wait_for_train()
  local rgblist = {}
  -- colorcode detector peripherals
  local track2_detector = find_peripheral("train_detect", "track_2")
  local track2_storage = find_peripheral("color_storage", "track_2")
  local track2_scan_hopper = find_peripheral("train_in_color", "track_2")
  local track2_return_loop = find_peripheral("train_in_organizer", "track_2")
  local track2_stop = find_peripheral("train_stop", "track_2")

  print("waiting for train")

  while track2_detector.func.getInput(track2_detector.side) ~= true do
  end

  print("the train is here")

  track2_stop.func.setOutput(track2.side, true)

  sleep(5)

  -- load from last cart to storage barrel
  track2_scan_hopper.func.setOutput(track2_scan_hopper.side, false)

  sleep(2)

  for slot, item in ipairs(track2_storage.func.list()) do
    rgblist[slot] = item
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

  for i, item in ipairs(rgblist) do
    print(item.name)
  end

end

local function wait_for_q()
    repeat
        local _, key = os.pullEvent("key")
    until key == keys.q
    print("Q was pressed!")
end

parallel.waitForAny(wait_for_q, wait_for_train) ]]


--[[ local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(15) -- Open 43 so we can receive replies

-- Send our message
modem.transmit(15, 15, "Hello, world!")
 ]]
--[[ -- And wait for a reply
local event, side, channel, replyChannel, message, distance
repeat
  event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
until channel == 43

print("Received a reply: " .. tostring(message)) ]]