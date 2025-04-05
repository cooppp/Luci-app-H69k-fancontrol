m = Map("h69kfan", "H69K 风扇控制")

s = m:section(TypedSection, "global", "控制参数")
s.anonymous = true
s.addremove = false

s:option(Value, "start_temp", "启动温度(℃)")
 .default = 35
 .datatype = "min(20)"

s:option(Value, "full_temp", "全速温度(℃)")
 .default = 45
 .datatype = "min(30)"

min = s:option(Value, "min_pwm", "最低转速(0-255)")
min.default = 100
min.datatype = "range(0,255)"

max = s:option(Value, "max_pwm", "最高转速(0-255)")
max.default = 255
max.datatype = "range(0,255)"

function max.validate(self, value, section)
    local min_val = min:formvalue(section)
    if tonumber(value) <= tonumber(min_val) then
        return nil, "最高转速必须大于最低转速！"
    end
    return value
end

s:option(Value, "interval", "检测间隔(秒)")
 .default = 20
 .datatype = "range(5,60)"

function m.on_after_commit(self)
    os.execute("sleep 1 && /etc/init.d/h69kfan restart >/dev/null 2>&1")
end

return m
