_SRV = net.createServer(net.TCP, 10)
_SRV:listen(80, function(c)
    loadScript("server_listener")(c)
end)

local function onEnd(c)
    if _CP[c] then
        _CP[c] = nil
        c:close()
        coroutine.resume(_SERVER_CO)
    end
end

_SERVER_CO = coroutine.create(function()
    while (true) do
        if (cPoolSize() > 0) then
            for c, d in pairs(_CP) do
                loadScript("server")(c, d, onEnd)
                break
            end
        end
        coroutine.yield()
    end
end)
