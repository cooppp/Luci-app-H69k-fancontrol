local m, s, o

m = Map("fanh69k", translate("Fan Control Settings"), 
    translate("PID-based thermal control for H69K devices"))

s = m:section(NamedSection, "global", "control", translate("Global Parameters"))

o = s:option(Value, "min_start_temp", translate("Minimum Start Temp (℃)"))
o.datatype = "uinteger"
o.optional = false

o = s:option(Value, "max_full_temp", translate("Max Full Temp (℃)"))
o.datatype = "uinteger"

o = s:option(Value, "min_pwm", translate("Minimum PWM"))
o.datatype = "range(0,255)"

o = s:option(Value, "max_pwm", translate("Maximum PWM"))
function o.validate(self, value)
    local min_pwm = m:get("global", "min_pwm")
    if tonumber(value) <= tonumber(min_pwm) then
        return nil, translate("Max PWM must be greater than Min PWM")
    end
    return value
end

s:tab("pid", translate("PID Tuning"))
o = s:taboption("pid", Value, "Kp", translate("Proportional (Kp)"))
o.datatype = "float"

o = s:taboption("pid", Value, "Ki", translate("Integral (Ki)"))
o.datatype = "float"

o = s:taboption("pid", Value, "Kd", translate("Derivative (Kd)"))
o.datatype = "float"

return m
