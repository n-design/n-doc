bridge_common={}

common = require "common"

function bridge_common.init(db_path)
   bridge_common.db_path = db_path
   print ("Luabridge", db_path)
   if _G.db_core == nil then
      _G.db_core = require "db_core"
      _G.db_core.init(db_path)
   end
end

function string:split(sep)
   local sep, fields = sep or ".", {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

function string:split_at_dot()
   local label = self:split()
   return label[1], label[2]
end

function bridge_common.toLower(key, tex)
   tex.sprint(string.lower(key))
end

function bridge_common.replaceUnderscore(key, tex)
   local result = common.replaceUnderscore(key)
   tex.sprint(result)
end

function bridge_common.labels(labeltype)
   labels = common.generate_label_list(labeltype)
   local i = 0
   return function ()
      i = i + 1
      if i <= #labels then return labels[i] end
   end
end

function bridge_common.getError(key, tex)
   tex.sprint(common.getError(key))
end

return bridge_common
