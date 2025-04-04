local m = Map("fanctl", translate("Fan Control Settings"))

local s = m:section(NamedSection, "config", "fanctl", translate("Control Parameters"))
s.addremove = false

o = s:option(Value, "min_temp", translate("Minimum Temperature (°C)"))
o.datatype = "uinteger"
o.default = 40
o.rmempty = false

o = s:option(Value, "max_temp", translate("Maximum Temperature (°C)"))
o.datatype = "uinteger"
o.default = 70
o.rmempty = false

o = s:option(Value, "min_rpm", translate("Minimum RPM"))
o.datatype = "range(30,255)"
o.default = 30
o.rmempty = false

o = s:option(Value, "max_rpm", translate("Maximum RPM"))
o.datatype = "range(30,255)"
o.default = 255
o.rmempty = false

function m.on_validate(self)
    local min_t = tonumber(m:formvalue("cbid.fanctl.config.min_temp")) or 0
    local max_t = tonumber(m:formvalue("cbid.fanctl.config.max_temp")) or 0
    local min_r = tonumber(m:formvalue("cbid.fanctl.config.min_rpm")) or 0
    local max_r = tonumber(m:formvalue("cbid.fanctl.config.max_rpm")) or 0
    
    if min_t >= max_t then
        return nil, translate("Maximum temperature must be greater than minimum temperature")
    end
    
    if min_r >= max_r then
        return nil, translate("Maximum RPM must be greater than minimum RPM")
    end
    
    return true
end

return m
