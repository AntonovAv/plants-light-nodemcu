local conn = ...
print("new connection ", conn)

conn:on("receive",
    function(conn, req)
        if not _CP[conn] then
            _CP[conn] = {}
        end

        print("recieved", conn)
        local data = _CP[conn]
        if data ~= nil and data.needBody then
            data.body = req
            data.needBody = false
        else
            local _, _, method, path, vars = string.find(req, "([A-Z]+) (.+)?(.+) HTTP")
            if (method == nil) then
                _, _, method, path = string.find(req, "([A-Z]+) (.+) HTTP")
            end
            data.method = method
            data.path = path
            if (method == "POST") then
                local _, _, body = string.find(req, "\r\n\r\n(.+)")
                if body then
                    data.body = body
                else
                    data.needBody = true
                    return -- wait data
                end
            end
        end

        -- TODO create coroutine by connection and kill on disconnection
        if (cPoolSize() == 1) then
            coroutine.resume(_SERVER_CO)
        end
    end)
conn:on("disconnection",
    function(conn)
        if _CP[conn] then
            _CP[conn] = nil
        end -- it is for safety
    end)
