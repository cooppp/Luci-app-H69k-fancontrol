module("luci.controller.hk69fan", package.seeall)

function index()
    entry({"admin", "services", "hk69fan"}, cbi("hk69fan"), "风扇控制", 60)
    entry({"admin", "services", "hk69fan", "status"}, call("action_status")).leaf = true
end

function action_status()
    local sys = require "luci.sys"
    local data = {
        temp = tonumber(sys.exec("cat /sys/class/thermal/thermal_zone0/temp | awk '{printf \"%.1f\", $1/1000}'")),
        pwm  = tonumber(sys.exec("cat /sys/devices/platform/pwm-fan/hwmon/hwmon0/pwm1 2>/dev/null")),
        cfg  = {
            min = tonumber(sys.exec("uci get hk69fan.@global[0].min_pwm")),
            max = tonumber(sys.exec("uci get hk69fan.@global[0].max_pwm"))
        }
    }
    luci.http.prepare_content("application/json")
    luci.http.write_json(data)
end
