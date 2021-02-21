cc_core = {}

cmn = require "common"
tls = require "tls"

function split(key, sep)
   local sep, fields = sep or ".", {}
   local pattern = string.format("([^%s]+)", sep)
   string.gsub(key, pattern, function(c) fields[#fields+1] = c end)
   return fields
end

function split_at_dot(key)
   local label = split(key, ".")
   return label[1], label[2], label[3], label[4]
end

cc_core.table_definitions = {
   [[CREATE TABLE subjobj ( `label` TEXT, `name` TEXT, `description` TEXT, PRIMARY KEY(`label`) )]],
   [[CREATE TABLE sfr_subjobj ( `sfr` TEXT, `subjobj` TEXT, FOREIGN KEY(`sfr`) REFERENCES `sfr`(`label`), FOREIGN KEY(`subjobj`) REFERENCES `subjobj`(`label`))]],
   [[CREATE TABLE spd ( `label` TEXT, `name` TEXT, `description` TEXT, `PP` TEXT, `PP_order` TEXT, PRIMARY KEY(`label`) )]],
   [[CREATE TABLE spd_obj ( `spd` TEXT, `obj` TEXT, `rel` TEXT, FOREIGN KEY(`spd`) REFERENCES `spd`(`label`), FOREIGN KEY(`obj`) REFERENCES `obj`(`label`))]],   
   [[CREATE TABLE subsystems ( `label` TEXT, `name` TEXT, `plainname` TEXT, PRIMARY KEY(`label`) )]],
   [[CREATE TABLE modules ( `subsystem` TEXT, `label` TEXT, `name` TEXT, `plainname` TEXT, PRIMARY KEY(`subsystem`,`label`), FOREIGN KEY(`subsystem`) REFERENCES `subsystems`(`label`) )]],
   [[CREATE TABLE interfaces ( `subsystem` TEXT, `module` TEXT, `label` TEXT, `name` TEXT, PRIMARY KEY(`subsystem`, `module`, `label`), FOREIGN KEY(`subsystem`) REFERENCES `subsystems`(`label`) , FOREIGN KEY(`module`) REFERENCES `modules`(`label`) )]],
   [[CREATE TABLE sfr ( `label` TEXT, `name` TEXT, `description` TEXT, `src` TEXT, PRIMARY KEY(`label`) )]],
   [[CREATE TABLE sfr_subsfr ( `sfr` TEXT, `subsfr` TEXT, FOREIGN KEY(`sfr`) REFERENCES `sfr`(`label`) )]],
   [[CREATE TABLE sfr_module ( `sfr` TEXT, `relationtype` TEXT, `subsystem` TEXT, `module` TEXT, `purpose` TEXT, FOREIGN KEY(`sfr`) REFERENCES `sfr`(`label`), FOREIGN KEY(`subsystem`) REFERENCES `subsystems`(`label`) , FOREIGN KEY(`module`) REFERENCES `modules`(`label`))]],
   [[CREATE TABLE bundles ( `bundle` TEXT, PRIMARY KEY(`bundle`) )]],
   [[CREATE TABLE bundle_module ( `bundle` TEXT, `subsystem` TEXT, `module` TEXT, FOREIGN KEY(`bundle`) REFERENCES `bundles`(`bundle`), FOREIGN KEY(`subsystem`) REFERENCES `subsystems`(`label`) , FOREIGN KEY(`module`) REFERENCES `modules`(`label`))]],
   [[CREATE TABLE sf ( `label` TEXT, `name` TEXT, `description` TEXT, PRIMARY KEY(`label`))]],
   [[CREATE TABLE sfr_sf ( `sfr` TEXT,  `sf` TEXT, FOREIGN KEY(`sfr`) REFERENCES `sfr`(`label`), FOREIGN KEY(`sf`) REFERENCES `sf`(`label`))]],
   [[CREATE TABLE obj ( `label` TEXT, `name` TEXT, `description` TEXT, `PP` TEXT, PRIMARY KEY(`label`))]],
   [[CREATE TABLE sfr_obj ( `sfr` TEXT, `obj` TEXT, FOREIGN KEY(`sfr`) REFERENCES `sfr`(`label`), FOREIGN KEY(`obj`) REFERENCES `obj`(`label`))]],
   [[CREATE TABLE tsfi ( `label` TEXT, `name` TEXT, `relationtype` TEXT, PRIMARY KEY(`label`))]],
   [[CREATE TABLE sfr_tsfi ( `sfr` TEXT,  `tsfi` TEXT, `purpose` TEXT,  FOREIGN KEY(`sfr`) REFERENCES `sfr`(`label`), FOREIGN KEY(`tsfi`) REFERENCES `tsfi`(`label`))]],
   [[CREATE TABLE errors ( `code` TEXT, `type` TEXT, `severity` TEXT, `msg` TEXT, PRIMARY KEY(`code`))]],
   [[CREATE TABLE testcases ( `label` TEXT, `name` TEXT, `block` TEXT, `desc` TEXT, `quelle` TEXT, PRIMARY KEY(`label`))]],
   [[CREATE TABLE testcase_module ( `testcase` TEXT, `subsystem` TEXT, `module` TEXT, FOREIGN KEY(`testcase`) REFERENCES `testcases`(`label`), FOREIGN KEY(`subsystem`) REFERENCES `subsystems`(`label`) , FOREIGN KEY(`module`) REFERENCES `modules`(`label`))]],
   [[CREATE TABLE testcase_sfr ( `testcase` TEXT, `sfr` TEXT, FOREIGN KEY(`sfr`) REFERENCES `sfr`(`label`), FOREIGN KEY(`testcase`) REFERENCES `testcases`(`label`))]],
   [[CREATE TABLE testcase_tsfi ( `testcase` TEXT, `tsfi` TEXT, FOREIGN KEY(`tsfi`) REFERENCES `tsfi`(`label`), FOREIGN KEY(`testcase`) REFERENCES `testcases`(`label`))]]
}


function cc_core.all_table_definitions()
   local i = 0
   local n = #cc_core.table_definitions
   return function ()
      i = i + 1
      if i <= n then return cc_core.table_definitions[i] end
   end
end

cc_core.populate_info = {
   {st=[[INSERT INTO subjobj VALUES (:label, :name, :description)]], csv = "subjobj.csv"},
   {st=[[INSERT INTO sfr_subjobj VALUES (:sfr, :subjobj)]], csv = "sfr_subjobj.csv"},
   {st=[[INSERT INTO spd VALUES (:label, :name, :description, :PP, :PP_order)]], csv = "spd.csv"},
   {st=[[INSERT INTO spd_obj VALUES (:spd, :obj, :rel)]], csv = "spd_obj.csv"},
   {st=[[INSERT INTO subsystems VALUES (:label, :name, :plainname)]], csv="subsystems.csv"},
   {st=[[INSERT INTO modules VALUES (:subsystem, :label, :name, :plainname)]], csv = "modules.csv"},
   {st=[[INSERT INTO interfaces VALUES (:subsystem, :module, :label, :name)]], csv = "interfaces.csv"},
   {st=[[INSERT INTO sfr VALUES (:label, :name, :description, :src)]], csv = "sfr.csv"},
   {st=[[INSERT INTO sfr_subsfr VALUES (:sfr, :subsfr)]], csv = "sfr_subsfr.csv"},
   {st=[[INSERT INTO sfr_module VALUES (:sfr, :relationtype, :subsystem, :module, :purpose)]], csv = "sfr_module.csv"},
   {st=[[INSERT INTO bundles VALUES (:bundle)]], csv = "bundles.csv"},
   {st=[[INSERT INTO bundle_module VALUES (:bundle, :subsystem, :module)]], csv = "bundle_module.csv"},
   {st=[[INSERT INTO sf VALUES (:label, :name, :description)]], csv = "sf.csv"},
   {st=[[INSERT INTO sfr_sf VALUES (:sfr, :sf)]], csv = "sfr_sf.csv"},
   {st=[[INSERT INTO obj VALUES (:label, :name, :description, :PP)]], csv = "obj.csv"},
   {st=[[INSERT INTO sfr_obj VALUES (:sfr, :obj)]], csv = "sfr_obj.csv"},
   {st=[[INSERT INTO tsfi VALUES (:label, :name, :relationtype)]], csv = "tsfi.csv"},
   {st=[[INSERT INTO sfr_tsfi VALUES (:sfr, :tsfi, :purpose)]], csv = "sfr_tsfi.csv"},
   {st=[[INSERT INTO errors VALUES (:code, :type, :severity, :msg)]], csv = "errors.csv"},
   {st=[[INSERT INTO testcases VALUES (:label, :name, :block, :desc, :quelle)]], csv = "testcases.csv"},
   {st=[[INSERT INTO testcase_module VALUES (:testcase, :subsystem, :module)]], csv = "testcase_module.csv"},
   {st=[[INSERT INTO testcase_sfr VALUES (:testcase, :sfr)]], csv = "testcase_sfr.csv"},
   {st=[[INSERT INTO testcase_tsfi VALUES (:testcase, :tsfi)]], csv = "testcase_tsfi.csv"}
}

function cc_core.populate()
   local i = 0
   local n = #cc_core.populate_info
   return function ()
      i = i + 1
      if i <= n then return cc_core.populate_info[i].st, cc_core.populate_info[i].csv  end
   end
end

cc_core.verbatim_mapper = function (v) return v; end;
cc_core.mod_mapper = function (v) return "mod." .. v.sub .. "." .. v.mod; end;

cc_core.querysets = {
    {name="spd", st=[[SELECT name FROM spd WHERE label=? COLLATE NOCASE]], resultitem = "name"},
    {name="spd_all_labels", st=[[SELECT label FROM spd ORDER by PP_order]], resultitem = "label"},
    {name="spdtext", st=[[SELECT description FROM spd WHERE label=? COLLATE NOCASE]], resultitem = "description"},
    {name="spdsource", st=[[SELECT PP as source FROM spd WHERE label=? COLLATE NOCASE]], resultitem = "source"},
    {name="spd2obj", st=[[select distinct obj from spd_obj where spd=:spd]], resultitem="obj"},
    {name="subjobj", st=[[SELECT name FROM subjobj WHERE label=? COLLATE NOCASE]], resultitem = "name"},
    {name="subjobj_all_labels", st=[[SELECT label FROM subjobj]], resultitem = "label"},
    {name="subjobjtext", st=[[SELECT description FROM subjobj WHERE label=? COLLATE NOCASE]], resultitem = "description"},
    {name="sub", st=[[SELECT name FROM subsystems WHERE label=?]], resultitem = "name"},
    {name="mod", st=[[SELECT name FROM modules WHERE subsystem=? AND label=?]], resultitem = "name"},
    {name="int", st=[[SELECT name FROM interfaces WHERE subsystem=? AND module=? AND label=?]], resultitem = "name"},
    {name="sfr", st=[[SELECT name FROM sfr WHERE label=? COLLATE NOCASE]], resultitem = "name"},
    {name="sfr_all_labels", st=[[SELECT label FROM sfr WHERE src LIKE :src]], resultitem = "label"},
    {name="subsfr", st=[[SELECT subsfr FROM sfr_subsfr WHERE sfr=:sfr COLLATE NOCASE]], resultitem = "subsfr"},
    {name="mainsfr", st=[[SELECT sfr FROM sfr_subsfr WHERE subsfr=? COLLATE NOCASE]], resultitem = "sfr"},
    {name="mainsfr_all_labels", st=[[SELECT DISTINCT sfr FROM sfr_subsfr]], resultitem = "sfr"},
    {name="sfrtext", st=[[SELECT description FROM sfr WHERE label=? COLLATE NOCASE]], resultitem = "description"},
    {name="sf", st=[[SELECT name FROM sf WHERE label=? COLLATE NOCASE]], resultitem = "name"},
    {name="sf_all_labels", st=[[SELECT distinct label as sf FROM sf order by sf]], resultitem = "sf"},
    {name="sftext", st=[[SELECT description FROM sf WHERE label=? COLLATE NOCASE]], resultitem = "description"},
    {name="obj", st=[[SELECT name FROM obj WHERE label=? COLLATE NOCASE]], resultitem = "name"},
    {name="obj_all_labels", st=[[SELECT label FROM obj ORDER BY label]], resultitem = "label"},
    {name="obj_no_env_all_labels", st=[[SELECT label FROM obj WHERE label LIKE 'o.%' ORDER BY label]], resultitem = "label"},
    {name="objtext", st=[[SELECT description FROM obj WHERE label=? COLLATE NOCASE]], resultitem = "description"},
    {name="objsource", st=[[SELECT PP as source FROM obj WHERE label=? COLLATE NOCASE]], resultitem = "source"},
    {name="tsfi", st=[[SELECT name FROM tsfi WHERE label=? COLLATE NOCASE]], resultitem = "name"},
    {name="tsfi_all_labels", st=[[SELECT label FROM tsfi ORDER by label]], resultitem = "label"},
    {name="error", st=[[SELECT msg FROM errors WHERE code=? COLLATE NOCASE]], resultitem = "msg"},
    {name="testcase", st=[[SELECT name FROM testcases WHERE label=? COLLATE NOCASE]], resultitem = "name"},
    {name="subjobj2sfr", st=[[select distinct sfr from sfr_subjobj where subjobj=:subjobj]], resultitem="sfr"},
    {name="sfr2subjobj", st=[[select distinct subjobj from sfr_subjobj where sfr=:sfr]], resultitem="subjobj"},
    {name="sfr2module", st=[[select subsystems.label as sub, modules.label as mod 
from sfr join sfr_module on sfr.label = sfr_module.sfr
join modules on sfr_module.module = modules.label and sfr_module.subsystem = modules.subsystem
join subsystems on modules.subsystem = subsystems.label
where sfr.label=:sfr and sfr_module.relationtype=:rel
]], mapper = cc_core.mod_mapper},

    {name="module2sfr", st=[[
select distinct sfr_module.sfr as sfr
from sfr_module
join sfr on sfr_module.sfr = sfr.label
where sfr_module.subsystem=:sub and sfr_module.module=:mod and sfr_module.relationtype=:rel
]], resultitem="sfr"},

    {name="subsystem2sfr", st=[[
select distinct sfr_module.sfr as sfr, sfr_module.purpose as purpose
from sfr_module
join sfr on sfr_module.sfr = sfr.label
where sfr_module.subsystem=:sub and sfr_module.relationtype=:rel
]], mapper = cc_core.verbatim_mapper},

    {name="module2bundle", st=[[
select bundle_module.bundle as bundle
from bundle_module
where bundle_module.subsystem=:sub and bundle_module.module=:mod
]], resultitem = "bundle"},

    {name="bundle2module", st=[[
select subsystem as sub, module as mod
from bundle_module
where bundle=:bundle
]], mapper = cc_core.mod_mapper},

    {name="tsfi2sfr", st=[[
select distinct sfr_tsfi.sfr as label, purpose as purpose from sfr_tsfi
  where sfr_tsfi.tsfi=:tsfi
]], mapper = cc_core.verbatim_mapper},

    {name="sf2tsfi", st=[[
select distinct tsfi as label from sfr_tsfi
  join sfr_sf on sfr_sf.sfr = sfr_tsfi.sfr
  where sf = :sf
]], resultitem = "label"},

    {name="tsfi2sf", st=[[
select distinct sf as label from sfr_tsfi
  join sfr_sf on sfr_sf.sfr = sfr_tsfi.sfr
  where tsfi = :tsfi
]], resultitem = "label"},

    {name="sfr2tsfi", st=[[
select distinct tsfi as label, purpose as purpose from sfr_tsfi
  where sfr = :sfr
]], mapper = cc_core.verbatim_mapper},

    {name="sfr2sf", st=[[
select distinct sf from sfr_sf where sfr = :sfr]], resultitem="sf"},

    {name="sfr2obj", st=[[
select distinct obj from sfr_obj where sfr=:sfr]], resultitem="obj"},

    {name="testcase2sfr", st=[[
select distinct sfr.label from sfr join testcase_sfr on sfr.label=testcase_sfr.sfr where testcase_sfr.testcase=:testcase
]], resultitem = "label"},

    {name="testcase2tsfi", st=[[
select distinct tsfi.label from tsfi join testcase_tsfi on tsfi.label=testcase_tsfi.tsfi where testcase_tsfi.testcase=:testcase
]], resultitem = "label"},

    {name="testcase2module", st=[[
select distinct subsystem as sub, module as mod from testcase_module where testcase=:testcase
]], mapper = cc_core.mod_mapper},

    {name="testcase_all_labels", st=[[
select label from testcases order by label collate nocase asc
]], resultitem = "label"},

    {name="modules_all_labels", st=[[SELECT subsystem as sub, label as mod FROM modules]], mapper=cc_core.mod_mapper},

    {name="number_of_tests_for_tsfi", st=[[
select count(*) as anzahl from testcases join testcase_tsfi on testcase_tsfi.testcase=testcases.label where testcase_tsfi.tsfi=?
]], resultitem = "anzahl"},

    {name="number_of_tests_for_sfr", st=[[
select count(*) as anzahl from testcases join testcase_sfr on testcase_sfr.testcase=testcases.label where testcase_sfr.sfr=?
]], resultitem = "anzahl"},

    {name="number_of_tests_for_module", st=[[
select count(*) as anzahl from testcases join testcase_module on testcase_module.testcase=testcases.label where testcase_module.subsystem=:sub and testcase_module.module=:mod]], resultitem = "anzahl"},
}

function cc_core.queries()
   local i = 0
   local n = #cc_core.querysets
   return function ()
      i = i + 1
      if i <= n then return cc_core.querysets[i].name, cc_core.querysets[i].st, cc_core.querysets[i].resultitem, cc_core.querysets[i].mapper  end
   end
end

function cc_core.getSfr(key)
   return cmn.get_by_query_key("sfr", key)
end

function cc_core.getSfrText(key)
    return cmn.get_by_query_key("sfrtext", key)
end

function cc_core.getSfr2Sf(key)
   return cmn.get_relations_by_query_key("sfr2sf", {sfr=key}, function (e) return e end)
end

function cc_core.getSfr2Obj(key)
   return cmn.get_relations_by_query_key("sfr2obj", {sfr=key}, function (e) return e end)
end

function cc_core.getSfr2Obj(key)
   return cmn.get_relations_by_query_key("sfr2obj", {sfr=key}, function (e) return e end)
end

function cc_core.removeSfrSubComponent(key)
   local component = string.gsub(string.lower(key), "^([a-z]+_[a-z]+%.[0-9])%.[0-9]([/.]*)", "%1%2")
   return component
end

function cc_core.getSecfunc(key)
   return cmn.get_by_query_key("sf", key)
end

function cc_core.getSecfuncText(key)
   return cmn.get_by_query_key("sftext", key)
end

function cc_core.getObjective(key)
   return cmn.get_by_query_key("obj", key)
end

function cc_core.getObjectiveText(key)
   return cmn.get_by_query_key("objtext", key)
end

function cc_core.getObjectiveSource(key)
   return cmn.get_by_query_key("objsource", key)
end

function cc_core.getSpd(key)
   return cmn.get_by_query_key("spd", key)
end

function cc_core.getSpdText(key)
   return cmn.get_by_query_key("spdtext", key)
end

function cc_core.getSpdSource(key)
   return cmn.get_by_query_key("spdsource", key)
end

function cc_core.getSpd2Obj(key)
   return cmn.get_relations_by_query_key("spd2obj", {spd=key}, function (e) return e end)
end

function cc_core.getSubjobj(key)
   return cmn.get_by_query_key("subjobj", key)
end

function cc_core.getSubjobjText(key)
   return cmn.get_by_query_key("subjobjtext", key)
end

function cc_core.getSubjobj2Sfr(key)
   return cmn.get_relations_by_query_key("subjobj2sfr", {subjobj=key}, function (e) return e end)
end

function cc_core.getSfr2Subjobj(key)
   return cmn.get_relations_by_query_key("sfr2subjobj", {sfr=key}, function (e) return e end)
end

function cc_core.getTsfi(key)
   return cmn.get_by_query_key("tsfi", key)
end

function cc_core.getTsfi2Sfr(key)
   return cmn.get_relations_by_query_key("tsfi2sfr", {tsfi=key}, function (e) return e end)
end

function cc_core.getSfr2Tsfi(key)
   return cmn.get_relations_by_query_key("sfr2tsfi", {sfr=key}, function (e) return e end)
end

function cc_core.getSf2Tsfi(key)
   return cmn.get_relations_by_query_key("sf2tsfi", {sf=key})
end

function cc_core.getTsfi2Sf(key)
   return cmn.get_relations_by_query_key("tsfi2sf", {tsfi=key}, function (e) return e end)
end

function cc_core.getTestcase(key)
   return cmn.get_by_query_key("testcase", key)
end

function cc_core.getTestcase2Sfr(key)
   return cmn.get_relations_by_query_key("testcase2sfr", {testcase=key})
end

function cc_core.getTestcase2Tsfi(key)
   return cmn.get_relations_by_query_key("testcase2tsfi", {testcase=key})
end

function cc_core.getTestcase2Module(key)
   return cmn.get_relations_by_query_key("testcase2module", {testcase=key})
end

function cc_core.getTestcases(srckey)
   return cmn.generate_label_list("testcase")
end

function cc_core.getNumberOfTestcasesTsfi(key)
   return cmn.get_by_query_key("number_of_tests_for_tsfi", key)
end

function cc_core.getNumberOfTestcasesSfr(key)
   return cmn.get_by_query_key("number_of_tests_for_sfr", key)
end

function cc_core.getNumberOfTestcasesMainSfr(key)
   local result = 0
   local main_sfr = cmn.get_by_query_key("mainsfr", key)
   local subsfr = cmn.get_relations_by_query_key("subsfr", {sfr=key})
   for _, s in pairs(subsfr) do
      result = result + cc_core.getNumberOfTestcasesSfr(s)
   end
   return math.floor(result)
end

function cc_core.getNumberOfTestcasesModule(key)
   local _, sub, mod = split_at_dot(key)
   local dbresult = cmn.get_relations_by_query_key("number_of_tests_for_module", {sub=sub, mod=mod})
   return cmn.check_for_errors(dbresult, "anzahl")
end

function split_at_dot(key)
   local label = split(key, '.')
   return label[1], label[2], label[3], label[4]
end

function insert_error(result)
  if (#result == 0) then
     table.insert(result, "__error__")
  end
  return result
end

function cc_core.replacelabel(key, fq)
   local typkey, subkey, modkey, intkey = split_at_dot(key)
   local values = {subkey, modkey, intkey}
   local replacedlabel = {}
   local sub = subkey and cmn.get_relations_by_query_key("sub", values, insert_error)[1]
   local mod = modkey and cmn.get_relations_by_query_key("mod", values, insert_error)[1]
   local int = intkey and cmn.get_relations_by_query_key("int", values, insert_error)[1]
   if fq then
      table.insert(replacedlabel, sub)
      table.insert(replacedlabel, mod and "::\\-")
      table.insert(replacedlabel, mod)
      table.insert(replacedlabel, int and "//\\-")
      table.insert(replacedlabel, int)
   else
      local results = {sub, mod, int}
      local whatvalue = {sub=1, mod=2, int=3}
      local thekey = whatvalue[typkey]
      local dbresult = cmn.get_relations_by_query_key(typkey, values)[thekey]
      table.insert(replacedlabel, results[thekey])
   end
    local result = table.concat(replacedlabel)
    return string.gsub(result, ".*__error__.*", "\\textcolor{red}{".. key .." is undefined}")
end

function cc_core.mapper(x)
   if #x == 0 then
      return nil
   else
      return x
   end
end

-- Liefert den Status eines Moduls: \enfc, \supp oder \nontsf
-- Übergabe ist ein Modulname
-- Wenn es ein enforcing SFR für dieses Modul gibt, ist die Rückgabe \enfc
-- Wenn es ein supporting SFR für dieses Modul gibt, ist die Rückgabe \supp
-- Ansonsten \nontsf
--
function cc_core.get_module_status(key)
   local typkey, subkey, modkey = split_at_dot(key)
   local dbresult = cmn.get_relations_by_query_key("module2sfr", {sub=subkey, mod=modkey, rel="enf"}, cc_core.mapper)
   if dbresult then
      return "\\enfc{}"
   else
      local dbresult = cmn.get_relations_by_query_key("module2sfr", {sub=subkey, mod=modkey, rel="sup"}, cc_core.mapper)
      if dbresult then
	 return "\\supp{}"
      else
	 return "\\nontsf{}"
      end
   end
end

function cc_core.generate_table_sfr_to_module(sfr, relationtype)
    local submod = cmn.get_relations_by_query_key("sfr2module", { sfr=sfr, rel=relationtype })
    local result = {}
    for _,v in ipairs(submod) do
        table.insert(result, v)
    end
   return result
end

function cc_core.generate_table_module_to_sfr(key, relationtype, srckey)
    local relationtype = relationtype or "enf"
    local srckey = srckey or "%"
    if srckey == "" then
        srckey = "%"
    end
    local typkey, subkey, modkey = split_at_dot(key)
    local query = "module2sfr"
    local dbresult = cmn.get_relations_by_query_key(query, {sub=subkey, mod=modkey, rel=relationtype, src=srckey})
    return cc_core.check_for_errors_in_lists(dbresult, key)
end

function cc_core.generate_table_subsys_to_sfr(key, relationtype, srckey)
    local relationtype = relationtype or "enf"
    local srckey = srckey or "%"
    local typkey, subkey = split_at_dot(key)
    local query = "subsystem2sfr"
    local dbresult = cmn.get_relations_by_query_key(query, {sub=subkey, rel=relationtype, src=srckey})
    return cc_core.check_for_errors_in_lists(dbresult, key)
end

function cc_core.generate_table_module_to_bundle(key)
    local typkey, subkey, modkey = split_at_dot(key)
    local dbresult = cmn.get_relations_by_query_key("module2bundle", {sub=subkey, mod=modkey})
    return cc_core.check_for_errors_in_lists(dbresult, key)
end

function cc_core.map_modules_to_sfr(sfr_label, relation)
    local relation = relation or "enf"
    local modules = cmn.get_relations_by_query_key("sfr2module", {sfr=sfr_label, rel=relation})
    local dbresult = {}
    for _,v in ipairs(modules) do
        table.insert(dbresult, v)
    end
    return cc_core.check_for_errors_in_lists(dbresult, sfr_label)
end

function cc_core.check_for_errors_in_lists(result, key)
    if result[1] == "__error__" then
        result = {}
    end
    --   result[1] = string.gsub(result[1], ".*__error__.*", "(Keine)")
   return result
end

function cc_core.check_for_errors(replacedlabel, key)
    local result = table.concat(replacedlabel)
    return string.gsub(result, ".*__error__.*", "\\textcolor{red}{".. key .." is undefined}")
end

return cc_core
