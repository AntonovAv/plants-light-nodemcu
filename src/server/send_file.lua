local c, fname, cb = ...

local fileBuffer = {}
local busyFileSend = false

local fd = file.open(fname, "r")
local k, buf = pcall(fd.read)
while k and buf do
    fileBuffer[#fileBuffer + 1] = buf
    k, buf = pcall(fd.read)
    if (not k) then print("can not read file: ", fname) end
end

if fd then
    fd:close()
    fd = nil
end

local sFileTmr = tmr.create()
local function sendProcess()
    if not busyFileSend then
        if (#fileBuffer > 0) then
            busyFileSend = true
            local part = table.remove(fileBuffer, 1)
            c:send(part)
        else
            sFileTmr:unregister()
            if cb then
                cb(c)
            else
                c:close()
            end
        end
    end
end

c:on("sent", function(c) busyFileSend = false end)
sFileTmr:register(10, tmr.ALARM_AUTO, sendProcess)
sFileTmr:start()
