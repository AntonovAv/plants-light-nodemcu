local c, data, cb = ...

local config = loadScript('decode')(data)
local _, config = pcall(sjson.decode, config)

data = nil
local forSave = {}
forSave["rules"] = config["rules"]

local ok, json = pcall(sjson.encode, forSave)
if ok then
    local fd = file.open("cfg", "w")
    print("file", fd)
    if fd then
        fd:write(json)
        fd:close()
    else
        ok = false
    end
end

local snd = loadScript("sender")
local headers = "HTTP/1.0 200 OK\r\nAccess-Control-Allow-Origin: *\r\n\r\n"
if ok then
    loadScript("update_pwm")()
    snd(c, headers .. "{\"result\": \"OK\"}", cb)
else
    snd(c, headers .. "{\"result\": \"Err\"}", cb)
end
