documents = {}

cmn = require "common"

documents.table_definitions = {
   [[CREATE TABLE releases ( `document` TEXT, `version` TEXT, `date` TEXT, `type` TEXT, PRIMARY KEY(`document`) )]],
}

function documents.all_table_definitions()
   local i = 0
   local n = #documents.table_definitions
   return function ()
      i = i + 1
      if i <= n then return documents.table_definitions[i] end
   end
end

documents.populate_info = {
   {st=[[INSERT INTO releases VALUES (:document, :version, :date, :type)]], csv="releases.csv"},
}

function documents.populate()
   local i = 0
   local n = #documents.populate_info
   return function ()
      i = i + 1
      if i <= n then return documents.populate_info[i].st, documents.populate_info[i].csv  end
   end
end

documents.querysets = {
    {name="docversion", st=[[SELECT version FROM releases WHERE document=?]], resultitem = "version"},
    {name="docdate", st=[[SELECT date FROM releases WHERE document=?]], resultitem = "date"},
    {name="doctype", st=[[SELECT type FROM releases WHERE document=?]], resultitem = "type"}
}

function documents.queries()
   local i = 0
   local n = #documents.querysets
   return function ()
      i = i + 1
      if i <= n then return documents.querysets[i].name, documents.querysets[i].st, documents.querysets[i].resultitem, documents.querysets[i].mapper  end
   end
end

function documents.getDocumentDate(key)
   return cmn.get_by_query_key("docdate", key)
end

function documents.getDocumentVersion(key)
   return cmn.get_by_query_key("docversion", key)
end

function documents.getDocumentType(key)
   return cmn.get_by_query_key("doctype", key)
end

function documents.get_version_number_for_reflist(version)
   local nosnap, is_snapshot = string.gsub(version, "-SNAPSHOT", "")
   local major, minor = split_at_dot(nosnap)
   if is_snapshot > 0 and tonumber(minor) > 0 then
     minor = tonumber(minor)-1
   end
   return major .. "." .. minor
end

return documents
