local c, data = ...

print("handle", data.path, data.method, data.body, c)

local path = data.path
local method = data.method
--TODO implement cache of data
--local okResp = "HTTP/1.0 200 OK\r\nCache-Control:max-age=604800\r\n\r\n" -- max-age=604800
local ok = "HTTP/1.0 200 OK\r\n"
--local cache = "Cache-Control:max-age=604800\r\n"
local cType = "Content-Type: "
local gZip = "Content-Encoding: gzip\r\n"
local mt = { css = "text/css", html = "text/html", js = "application/javascript", png = "image/png" }

local sender = loadScript("sender")
--local sfile = loadScript("send_file")
local function onEnd(c)
    if _CP[c] then
        _CP[c] = nil
        c:close()
        coroutine.resume(_SERVER_CO)
    end
end

local function sfile(c, fileName, isGz)
    local headers = ok
    if isGz then
        local _, _, type = string.find(fileName, "%.(.+)")
        headers = headers .. cType .. mt[type] .. "\r\n" .. gZip
    end
    headers = headers .. "\r\n"
    sender(c, headers, function(c)
        loadScript("send_file")(c, fileName, onEnd)
    end)
end

if (path == "/conf") then
    sfile(c, "cfg", false)
--[[elseif (path == "/refresh.png") then
    sfile(c, "refresh.png", true)
elseif (path == "/start_page.css") then
    sfile(c, "start_page.css", true)
elseif (path == "/start_page.js") then
    sfile(c, "start_page.js", true)
elseif (method == "POST" and path == "/settings") then
    loadScript("settings_handler")(c, data.body, onEnd)
elseif (method == "POST" and path == "/lights") then
    loadScript("custom_lights")(c, data.body, onEnd)
elseif (method == "GET" and path == "/settings") then
    loadScript("send_settings")(c, onEnd)
elseif (path == "/") then
    sfile(c, "start_page.html", true)]]
else
    pcall(sender, c, "HTTP/1.0 404", onEnd)
end

