module("luci.controller.fan_ctrl", package.seeall)

function index()
    entry({"admin", "services", "fan_ctrl"}, cbi("fan_ctrl/basic"), _("Fan Control"), 60).dependent = true
    entry({"admin", "services", "fan_ctrl", "status"}, call("action_status"))
    entry({"admin", "services", "fan_ctrl", "control"}, call("action_control"))
end

function action_status()
    local sys = require "luci.sys"
    local util = require "luci.util"
    local uci = require "luci.model.uci".cursor()
    
    local pwm_path = uci:get("fan_ctrl", "settings", "pwm_ctrl") or
        "/sys/devices/platform/pwm-fan/hwmon/hwmon0/pwm1"
    
    local data = {
        temp = util.trim(sys.exec(
            "cat $(uci -q get fan_ctrl.settings.temp_sensor || "..
            "echo '/sys/class/thermal/thermal_zone0/temp') | "..
            "awk '{printf \"%.1f\", $1/1000}'"
        )),
        pwm = util.trim(sys.exec(
            "[ -r '%s' ] && cat '%s' || echo 'N/A'" % {pwm_path, pwm_path}
        )),
        running = sys.call("pgrep fan_ctrl.sh >/dev/null") == 0
    }
    
    luci.http.prepare_content("application/json")
    luci.http.write_json(data)
end

function action_control()
    local cmd = luci.http.formvalue("cmd")
    if cmd == "start" then
        os.execute("/etc/init.d/fan_ctrl start >/dev/null 2>&1")
    elseif cmd == "stop" then
        os.execute("/etc/init.d/fan_ctrl stop >/dev/null 2>&1")
    end
    luci.http.prepare_content("application/json")
    luci.http.write_json({success = true})
end
