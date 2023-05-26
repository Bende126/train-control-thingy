if time == nil then error("No variable", 0) end

sleep(time)

os.queueEvent("testing", "baba")

sleep(10)

shell.exit()