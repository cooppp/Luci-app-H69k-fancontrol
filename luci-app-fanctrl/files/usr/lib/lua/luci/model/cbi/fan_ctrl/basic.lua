local m = Map("fan_ctrl", translate("Fan Control Settings"))

local s = m:section(NamedSection, "settings", "settings", translate("Control Parameters"))
s.addremove = false

o = s:option(Value, "pwm_ctrl", translate("PWM Control Path"))
o.datatype = "string"
o.rmempty = false

o = s:option(Value, "temp_sensor", translate("Temperature Sensor Path"))
o.datatype = "string"
o.rmempty = false

o = s:option(Value, "start_temp", translate("Start Temperature (°C)"))
o.datatype = "ufloat"
o.default = 35

o = s:option(Value, "full_temp", translate("Full Speed Temperature (°C)"))
o.datatype = "ufloat"
o.default = 45

o = s:option(Value, "min_pwm", translate("Minimum PWM Value"))
o.datatype = "range(0,255)"
o.default = 30

o = s:option(Value, "check_interval", translate("Check Interval (seconds)"))
o.datatype = "uinteger"
o.default = 20

return m
