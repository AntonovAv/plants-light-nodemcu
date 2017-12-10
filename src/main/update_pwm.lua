local cfg = loadScript("get_cfg")()

local rules = cfg["rules"]
if (#rules == 0) then return end

local curTime = getTime()
local cHour = curTime["hour"]
local cMin = curTime["min"]

local curRuleId = -1
table.sort(rules, function(a, b)
    local aH = a["h"]
    local bH = b["h"]
    if (aH == bH) then return a["m"] < b["m"] end
    return aH < bH
end)

for id, rule in ipairs(rules) do
    local h = rule["h"]
    local m = rule["m"]
    if (cHour > h or (cHour == h and cMin >= m)) then
        curRuleId = id
    end
end

if (curRuleId == -1) then
    curRuleId = #rules
end

local br = rules[curRuleId]["br"]
local duty = 0
if br > 0 then
    duty = (C.PWM_MAX_DUTY * br) / 100
end

pwm.setduty(C.PWM_PIN, duty)