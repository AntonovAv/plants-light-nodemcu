C = {}
C.TZ_OFFSET = 10800 -- 3 hours from UTC

wifi.setmode(wifi.STATION)

cfg = {}
cfg.ssid = "internet"
cfg.pwd = "654qwerty123"
cfg.save = true
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
    print("\n\tSTA - CONNECTED" .. "\n\tSSID: " .. T.SSID .. "\n\tBSSID: " ..
            T.BSSID .. "\n\tChannel: " .. T.channel)

    sntp.sync(nil,
        function(sec, usec, server, info)
            print('sync', sec, usec, server)
            local tm = getTime()
            print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
        end,
        nil,
        1)
end)
wifi.sta.config(cfg)

function getTime()
    return rtctime.epoch2cal(rtctime.get() + C.TZ_OFFSET)
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