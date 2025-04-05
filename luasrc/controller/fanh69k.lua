module("luci.controller.fanh69k", package.seeall)

function index()
    entry({"admin", "system", "fanh69k"}, cbi("fanh69k"), _("Fan Control"), 60)
    entry({"admin", "system", "fanh69k", "status"}, call("action_status"))
end

function action_status()
    local sys = require "luci.sys"
    local uci = require "luci.model.uci".cursor()
    
    local temp = sys.exec("cat /sys/class/thermal/thermal_zone0/temp | awk '{printf \"%.1f\", $1/1000}'")
    local pwm = sys.exec("cat /sys/devices/platform/pwm-fan/hwmon/hwmon0/pwm1")
    
    luci.http.prepare_content("application/json")
    luci.http.write_json({
        temp = temp,
        pwm = pwm,
        min_pwm = uci:get("fanh69k", "global", "min_pwm"),
        max_pwm = uci:get("fanh69k", "global", "max_pwm"),
        min_temp = uci:get("fanh69k", "global", "min_start_temp"),
        max_temp = uci:get("fanh69k", "global", "max_full_temp")
    })
end
