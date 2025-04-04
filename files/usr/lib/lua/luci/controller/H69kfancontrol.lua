local fs = require "nixio.fs"
local sys = require "luci.sys"
local util = require "luci.util"
local template = require "luci.template"

function validate_temperature(temp)
    return tonumber(temp) and temp >= 0 and temp <= 100
end

function index()
    entry({"admin", "services", "h69k_fancontrol"}, alias("admin", "services", "h69k_fancontrol", "config"), _("H69K Fan Control"), 60).dependent = true
    entry({"admin", "services", "h69k_fancontrol", "config"}, cbi("h69k-fancontrol"), _("Configuration"), 10)
    entry({"admin", "services", "h69k_fancontrol", "status"}, call("action_status"), _("Status"), 20)
end

function action_status()
    local status = {
        running = (sys.call("pgrep h69k_fancontrol.sh >/dev/null") == 0),
        config = util.ubus("uci", "get", {config = "h69k_fancontrol"})
    }
    
    luci.http.prepare_content("application/json")
    luci.http.write_json(status)
end
