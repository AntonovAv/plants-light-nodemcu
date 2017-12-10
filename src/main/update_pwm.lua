local cfg = loadScript("get_cfg")()

if (#cfg["rules"] == 0) then return end

local curTime = getTime()
local cHour = curTime["hour"]
local cMin = curTime["min"]

local curRuleId = -1
for id, rule in pairs(cfg["rules"]) do
    local h = rule["h"]
    local m = rule["m"]
    if (cHour > h or (cHour == h and cMin >= m)) then
        curRuleId = id
    end
end

if (curRuleId == -1) then
    curRuleId = 1
end

local br = cfg["rules"][curRuleId]["br"]
local duty = 0
if br > 0 then
    duty = (C.PWM_MAX_DUTY * br) / 100
end

pwm.setduty(C.PWM_PIN, duty)