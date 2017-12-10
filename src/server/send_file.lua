local c, fname, cb = ...

local fileBuffer = {}
local busyFileSend = false

pcall(file.open(fname))
local k, buf = pcall(file.read)
while k and buf do
    fileBuffer[#fileBuffer + 1] = buf
    k, buf = pcall(file.read)
    if (not k) then print("can not read file: ", fname) end
end
file.close()

local function sendProcess()
    tmr.wdclr()
    if not busyFileSend then
        if (#fileBuffer > 0) then
            busyFileSend = true
            local part = table.remove(fileBuffer, 1)
            c:send(part)
        else
            tmr.unregister(3)
            if cb then
                cb(c)
            else
                c:close()
            end
        end
    end
end

c:on("sent", function(c) tmr.wdclr() busyFileSend = false end)
tmr.register(_C.FILE_TMR, 10, tmr.ALARM_AUTO, sendProcess)
tmr.start(_C.FILE_TMR)
