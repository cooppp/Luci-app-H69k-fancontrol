local m, s, o

-- 显式引入CBI模块
require("luci.model.cbi")

-- 初始化Map对象（强制校验配置文件）
m = Map("fanh69k", translate("Fan Control Settings"), 
    translate("Advanced PID-based thermal control for H69K devices"),
    {on_init = function(self)
        if not nixio.fs.access("/etc/config/fanh69k") then
            luci.http.redirect(luci.dispatcher.build_url("admin/system/fanh69k/create_config"))
        end
    end})

-- 启用开关
s = m:section(NamedSection, "global", "control", "control", translate("Global Switch"))
s.anonymous = true
s:option(ListValue, "enabled", translate("Enable Control"))
    :value("1", translate("Enabled"))
    :value("0", translate("Disabled"))

-- 基础参数（依赖启用状态）
s = m:section(NamedSection, "global", "control", "control", translate("Basic Parameters"))
s.anonymous = true
s:depends("enabled", "1")

s:option(Value, "min_start_temp", translate("Minimum Start Temp (℃)")).datatype = "uinteger"
s:option(Value, "max_full_temp", translate("Max Full Temp (℃)")).datatype = "uinteger"
s:option(Value, "min_pwm", translate("Minimum PWM")).datatype = "range(0,255)"
s:option(Value, "max_pwm", translate("Maximum PWM")).datatype = "range(0,255)"
s:option(Value, "interval", translate("Check Interval (s)")).datatype = "uinteger"

-- PID调校（依赖启用状态）
s = m:section(SimpleSection)
s.title = translate("PID Tuning")
s.anonymous = true
s:depends("enabled", "1")

s:option(Value, "Kp", translate("Proportional (Kp)")).datatype = "float"
s:option(Value, "Ki", translate("Integral (Ki)")).datatype = "float"
s:option(Value, "Kd", translate("Derivative (Kd)")).datatype = "float"

return m
