module("luci.controller.h69kfan", package.seeall)

function index()
    entry({"admin", "services", "h69kfan"}, cbi("h69kfan"), "风扇控制", 60)
    entry({"admin", "services", "h69kfan", "status"}, call("action_status")).leaf = true
end

function action_status()
    local sys = require "luci.sys"
    local data = {
        temp = tonumber(sys.exec("cat /sys/class/thermal/thermal_zone0/temp | awk '{printf \"%.1f\", $1/1000}'")),
        pwm  = tonumber(sys.exec("cat /sys/devices/platform/pwm-fan/hwmon/hwmon0/pwm1 2>/dev/null")),
        cfg  = {
            min = tonumber(sys.exec("uci get h69kfan.@global[0].min_pwm || echo 100")),
            max = tonumber(sys.exec("uci get h69kfan.@global[0].max_pwm || echo 255"))
        }
    }
    luci.http.prepare_content("application/json")
    luci.http.write_json(data)
end
