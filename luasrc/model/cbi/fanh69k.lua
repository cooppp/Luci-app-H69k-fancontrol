local m, s, o

m = Map("fanh69k", translate("风扇控制设置"), 
    translate("基于PID的H69K设备智能温控"))

-- 启用开关
s = m:section(NamedSection, "global", "control", translate("全局开关"))
s.anonymous = true
s:option(ListValue, "enabled", translate("启用控制"))
    :value("1", translate("启用"))
    :value("0", translate("禁用"))

-- 基础参数（依赖启用状态）
s = m:section(NamedSection, "global", "control", translate("基础参数"))
s.anonymous = true
s:depends("enabled", "1")

s:option(Value, "min_start_temp", translate("最低启动温度(℃)")).datatype = "uinteger"
s:option(Value, "max_full_temp", translate("最高全速温度(℃)")).datatype = "uinteger"
s:option(Value, "min_pwm", translate("最小PWM")).datatype = "range(0,255)"
s:option(Value, "max_pwm", translate("最大PWM")).datatype = "range(0,255)"
s:option(Value, "interval", translate("检测间隔(秒)")).datatype = "uinteger"

-- PID调校（依赖启用状态）
s = m:section(SimpleSection, translate("PID参数调校"))
s.anonymous = true
s:depends("enabled", "1")

s:option(Value, "Kp", translate("比例系数(Kp)")).datatype = "float"
s:option(Value, "Ki", translate("积分系数(Ki)")).datatype = "float"
s:option(Value, "Kd", translate("微分系数(Kd)")).datatype = "float"

return m
