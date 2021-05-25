common = {}

function common.replaceUnderscore(key)
   local result = string.gsub(key, "_", "\\_")
   return result
end

function common.remove_smart_hyphen(key)
   local result = string.gsub(key, '\\%-', '') -- I have no idea why this works.
   return result
end

function common.get_by_query_key(querykey, key)
   local theKey = string.lower(key)
   local result = _G.db_core.read_from_db(querykey, {theKey})
   return common.check_for_errors(result, key)
end

function common.get_relations_by_query_key(querykey, keymap, error_mapper)
   local keys = keymap or {}
   local e = error_mapper or function (e) return e end;
   local dbresult = _G.db_core.read_from_db(querykey, keys, e)
   return dbresult
end

function common.check_for_errors(replaced, key)
   local key = string.gsub(key, "_", "\\_")
   local result = string.gsub(replaced[1], ".*__error__.*", "\\textcolor{red}{".. key .." is undefined}")
   return result
end

function common.generate_label_list(thelabel)
    local labels = common.get_relations_by_query_key(thelabel .."_all_labels")
    return labels
end

function common.count_labels(thelabel)
    local labels = common.get_relations_by_query_key(thelabel .."_all_labels")
    return #labels
end

function common.getError(key)
    return common.get_by_query_key("error", key)
 end

function common.labels(labeltype)
   local labels = common.generate_label_list(labeltype)
   local i = 0
   return function ()
      i = i + 1
      if i <= #labels then return labels[i] end
   end
end

return common
