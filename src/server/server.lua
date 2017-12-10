local c, data, onEnd = ...

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
    loadScript("send_cfg")(c, onEnd)
elseif path == "/page.js" then
    sfile(c, "page.js", false)
elseif (path == "/" and method == "GET") then
    sfile(c, "index.html", false)
else
    pcall(sender, c, "HTTP/1.0 404", onEnd)
end

