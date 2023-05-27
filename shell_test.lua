local shellid = multishell.launch({time = 10}, "./event_test.lua")
multishell.setTitle(shellid, "HAAAAAAAAAAAA")

while true do
    local myevent, msg = os.pullEvent("testing")
    print("Úristen, event történt: " .. myevent)
    if (msg == "baba") then
        multishell.setFocus(shellid)
        shell.exit()
    end
end