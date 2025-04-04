module("luci.controller.H69k-fancontrol", package.seeall)

function index()
    entry({"admin", "system", "H69k-fancontrol"}, cbi("H69k-fancontrol"), _("H69k Fan Control"), 60).dependent = true
    entry({"admin", "system", "H69k-fancontrol", "status"}, call("action_status"))
end

function action_status()
    local util = require "luci.util"
    local temp_path = "/sys/devices/virtual/thermal/thermal_zone0/temp"
    local rpm_path = "/sys/devices/platform/pwm-fan/hwmon/hwmon0/pwm1"
    
    local temp = util.trim(util.exec("cat "..temp_path.." 2>/dev/null")) or "0"
    local rpm = util.trim(util.exec("cat "..rpm_path.." 2>/dev/null")) or "0"
    
    luci.http.prepare_content("application/json")
    luci.http.write_json({
        temperature = tonumber(temp) / 1000,
        rpm = tonumber(rpm)
    })
end
