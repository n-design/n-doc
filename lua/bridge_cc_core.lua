bridge_cc_core={}

cc_core = require "cc_core"

tablegen = require "table_generator"

function bridge_cc_core.replacelabel(key, fullyq, tex)
   local fq = false
   if fullyq == "fq" then
      fq = true
   end
   local replacedlabel = cc_core.replacelabel(key, fq)
   tex.sprint(replacedlabel)
end

function bridge_cc_core.replacelabelplain(key, fullyq, tex)
   local fq = false
   if fullyq == "fq" then
      fq = true
   end
   local replacedlabel = cc_core.replacelabel(key, fq)
   local nohyphen = string.gsub(replacedlabel, '\\%-', '')
   tex.sprint(nohyphen)
end

function bridge_cc_core.get_module_status(key, tex)
   local status = cc_core.get_module_status(key)
   tex.sprint(status)
end

function bridge_cc_core.print_module_to_sfr_table(key, relationtype, tex)
   local relationtype = relationtype or "enf"
   local sfrs = cc_core.generate_table_module_to_sfr(key, relationtype)
   local result = tablegen.print_sfr_table_for_module(relationtype, sfrs)
   tex.print(result)
end

function bridge_cc_core.print_modules_for_sfr_rows(tex)
   local resulttable = {}
   for sfr in common.labels("mainsfr") do
      local enf_modules = cc_core.map_modules_to_sfr(sfr, "enf")
      local sup_modules = cc_core.map_modules_to_sfr(sfr, "sup")
      if #enf_modules > 0 or #sup_modules > 0 then
	 local tablerow = tg.generate_modules_for_sfr_row(sfr, enf_modules, sup_modules)
	 table.insert(resulttable, tablerow)
      end
   end
   tex.print(table.concat(resulttable))
end

function bridge_cc_core.print_tsfi_for_sfr_rows(tex)
   local resulttable = {}
   for sfr in common.labels("mainsfr") do
      local tsfi = cc_core.getSfr2Tsfi(sfr)
      if #tsfi > 0 then
	 local tablerow = tg.generate_tsfi_for_sfr_row(sfr, tsfi)
	 table.insert(resulttable, tablerow)
      end
   end
   tex.print(table.concat(resulttable))
end

function bridge_cc_core.print_sfr_for_tsfi_rows(tex)
   local resulttable = {}
   for tsfi in common.labels("tsfi") do
      local sfr = cc_core.getTsfi2Sfr(tsfi)
      if #sfr > 0 then
	 local tablerow = tg.generate_sfr_for_tsfi_row(tsfi, sfr)
	 table.insert(resulttable, tablerow)
      end
   end
   tex.print(table.concat(resulttable))
end

function bridge_cc_core.print_subsys_to_sfr_table(key, relationtype, tex)
   local relationtype = relationtype or "enf"
   local sfrs = cc_core.generate_table_subsys_to_sfr(key, relationtype)
   local result = tablegen.print_sfr_table_for_subsys(relationtype, sfrs)
   tex.print(result)
end

function bridge_cc_core.print_module_to_bundle_table(key, tex)
   local bundles = cc_core.generate_table_module_to_bundle(key)
   local result = tablegen.print_bundle_table_for_module(bundles)
   tex.print(result)
end

function bridge_cc_core.print_sf_to_tsfi_table(key, tex)
   local tsfis = cc_core.getSf2Tsfi(key)
   local result = tablegen.print_item_list(tsfis, "tsfilink")
   tex.print(result)
end

function bridge_cc_core.print_tsfi_to_sf_table(key, tex)
   local sfs = cc_core.getTsfi2Sf(key)
   local result = tablegen.print_item_list(sfs, "sflink")
   tex.print(result)
end

function bridge_cc_core.getSfr(key, tex)
   tex.sprint(cc_core.getSfr(key))
end

function bridge_cc_core.getSfrText(key, tex)
   tex.sprint(cc_core.getSfrText(key))
end

function bridge_cc_core.removeSfrSubComponent(key, tex)
   tex.sprint(cc_core.removeSfrSubComponent(key))
end

function bridge_cc_core.getSecfunc(key, tex)
   tex.sprint(cc_core.getSecfunc(key))
end

function bridge_cc_core.getSecfuncText(key, tex)
   tex.sprint(cc_core.getSecfuncText(key))
end

function bridge_cc_core.getObjective(key, tex)
   tex.sprint(cc_core.getObjective(key))
end

function bridge_cc_core.getObjectiveText(key, tex)
   tex.sprint(cc_core.getObjectiveText(key))
end

function bridge_cc_core.getSubjobj(key, tex)
   tex.sprint(cc_core.getSubjobj(key))
end

function bridge_cc_core.getSubjobjText(key, tex)
   tex.sprint(cc_core.getSubjobjText(key))
end

function bridge_cc_core.getSpd(key, tex)
   tex.sprint(cc_core.getSpd(key))
end

function bridge_cc_core.getSpdText(key, tex)
   tex.sprint(cc_core.getSpdText(key))
end

function bridge_cc_core.getSpdSource(key, tex)
   tex.sprint(cc_core.getSpdSource(key))
end

function bridge_cc_core.getObjectiveSource(key, tex)
   tex.sprint(cc_core.getObjectiveSource(key))
end

function bridge_cc_core.getTsfi(key, tex)
   tex.sprint(cc_core.getTsfi(key))
end

function bridge_cc_core.print_testcase_table(tex)
   local testcases = cc_core.getTestcases()
   local resulttable = {}
   for _,testcase in pairs(testcases) do
      local tc = cc_core.getTestcase(testcase)
      local submod = cc_core.getTestcase2Module(testcase)
      local sfrs = cc_core.getTestcase2Sfr(testcase)
      local tsfis = cc_core.getTestcase2Tsfi(testcase)
      local tablerow = tg.generate_testcase_row(tc, submod, sfrs, tsfis)
      table.insert(resulttable, tablerow)
   end
   tex.print(table.concat(resulttable))
end

function bridge_cc_core.print_testcase_to_tsfi_table(key, tex)
   local tsfis = cc_core.getTestcase2Tsfi(key)
   local result = tablegen.print_item_list(tsfis, "tsfi")
   tex.sprint(result)
end

function bridge_cc_core.print_testcase_to_sfr_table(key, tex)
   local sfrs = cc_core.getTestcase2Sfr(key)
   local result = tablegen.print_item_list(sfrs, "sfrnolink")
   tex.sprint(result)
end

function bridge_cc_core.print_category_to_num_testcase_table(tex, label, item_mapper, counter_function, num_columns)
   local labels = common.generate_label_list(label)
   local resulttable = {}
   local tablerow = tg.generate_numbers_rows(labels, item_mapper, counter_function, num_columns)
   table.insert(resulttable, tablerow)
   tex.sprint(table.concat(resulttable))
end

function bridge_cc_core.print_sfr_to_num_testcase_table(tex)
   bridge_cc_core.print_category_to_num_testcase_table(tex, "mainsfr", "sfrnolink", cc_core.getNumberOfTestcasesMainSfr, 4)
end

function bridge_cc_core.print_tsfi_to_num_testcase_table(tex)
   bridge_cc_core.print_category_to_num_testcase_table(tex, "tsfi", "tsfi", cc_core.getNumberOfTestcasesTsfi, 3)
end

function bridge_cc_core.print_module_to_num_testcase_table(tex)
   bridge_cc_core.print_category_to_num_testcase_table(tex, "modules", "modulestatus", cc_core.getNumberOfTestcasesModule, 3)
end

function init_data_row(label)
   local row = {}
   for l in common.labels(label) do
      row[l] = [[\tno]]
   end
   return row
end

function bridge_cc_core.print_table_header(label, macro, tex)
   local resulttable = {}
   for l in common.labels(label) do
      table.insert(resulttable, [[& \rot{\textsmaller[1]{\]])
      table.insert(resulttable, macro)
      table.insert(resulttable, [[{]])
      table.insert(resulttable, l)
      table.insert(resulttable, [[}}} ]])
   end
   tex.sprint(table.concat(resulttable))
end

function p(label, r)
   local result = {}
   for l in common.labels(label) do
      table.insert(result, r[l])
   end
   return table.concat(result, " & ")
end


function bridge_cc_core.print_table_body(table_params, tex)
   local resulttable = {}
   for l in common.labels(table_params.label_row) do
      local data_row = init_data_row(table_params.label_header)
      local tupel = table_params.selector(l)
      for _,val in pairs(tupel) do
 	 data_row[val]=[[\tcheck]]
      end
      local tablerow={}
      table.insert(tablerow, [[\textsmaller[1]{\]])
      table.insert(tablerow, table_params.macro)
      table.insert(tablerow, [[{]])
      table.insert(tablerow, l)
      table.insert(tablerow, [[}} & ]])
      table.insert(tablerow, p(table_params.label_header, data_row))
      table.insert(tablerow, [[\\]])
      table.insert(resulttable, table.concat(tablerow))
   end
--   for _,r in pairs(resulttable) do
--      print(r)
--   end
   tex.sprint(table.concat(resulttable))
end

return bridge_cc_core
