local c, data, cb = ...
c:on("sent", function(c)
    if cb then
        cb(c)
    else
        c:close()
    end
end)
c:send(data)