module("luci.controller.fanh69k", package.seeall)

function index()
    entry({"admin", "system", "fanh69k"}, cbi("fanh69k"), _("Fan Control"), 60)
    entry({"admin", "system", "fanh69k", "status"}, call("action_status"))
end

function action_status()
    local temp = luci.sys.exec("cat /sys/class/thermal/thermal_zone0/temp | awk '{printf \"%.1f\", $1/1000}'")
    local pwm = luci.sys.exec("cat /sys/devices/platform/pwm-fan/hwmon/hwmon0/pwm1")
    local min_pwm = luci.sys.exec("uci get fanh69k.@control[-1].min_pwm")
    local max_pwm = luci.sys.exec("uci get fanh69k.@control[-1].max_pwm")
    
    luci.http.prepare_content("application/json")
    luci.http.write_json({
        temp = temp,
        pwm = pwm,
        min_pwm = min_pwm,
        max_pwm = max_pwm
    })
end
