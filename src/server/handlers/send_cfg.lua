local c, cb = ...

local cfg = loadScript('get_cfg')()
local result = cfg
result.ts = rtctime.get()

local snd = loadScript("sender")
local headers = "HTTP/1.0 200 OK\r\nAccess-Control-Allow-Origin: *\r\n\r\n"
snd(c, headers, function(c)
    local _, json = pcall(sjson.encode, result)
    snd(c, json, cb)
end)