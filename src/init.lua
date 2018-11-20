C = {}
C.TZ_OFFSET = 10800 -- 3 hours from UTC
C.PWM_PIN = 1
C.PWM_MAX_DUTY = 700
C.PWM_FREQ = 1000

-- WIFI
cfg = {
    ssid = "internet",
    pwd = "654qwerty123",
    save = true
}
wifi.setmode(wifi.STATION)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
    print("\n\tSTA - GOT IP" .. "\n\tStation IP: " .. T.IP .. "\n\tSubnet mask: " ..
            T.netmask .. "\n\tGateway IP: " .. T.gateway)
    syncTime()
end)
wifi.sta.config(cfg)

--PWM
pwm.setup(C.PWM_PIN, C.PWM_FREQ, 0)
pwm.start(1)

-- GLOBAL functions
function getTime()
    return rtctime.epoch2cal(rtctime.get() + C.TZ_OFFSET)
end

function syncTime()
    sntp.sync({ "0.ru.pool.ntp.org", "1.ru.pool.ntp.org", "2.ru.pool.ntp.org" },
        function(sec, usec, server)
            print('sync', sec, usec, server)
            printTime()
        end,
        nil,
        1)
end

function printTime()
    local tm = getTime()
    print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
end

function loadScript(script)
    return assert(loadfile(script .. ".lua"))
end

_CP = {}
function cPoolSize()
    local ind = 0;
    for _, _ in pairs(_CP) do
        ind = ind + 1;
    end
    return ind
end

loadScript("init_server")()

cron.schedule("* * * * *", function(e)
    loadScript("update_pwm")()
end)

cron.schedule("*/10 * * * *", function(e)
    syncTime()
end)