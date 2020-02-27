bridge_cc_core={}

cc_core = require "cc_core"

tablegen = require "table_generator"

function bridge_cc_core.replacelabel(key, fullyq, tex)
   fq = false
   if fullyq == "fq" then
      fq = true
   end
   replacedlabel = cc_core.replacelabel(key, fq)
   tex.sprint(replacedlabel)
end

function bridge_cc_core.get_module_status(key, tex)
   status = cc_core.get_module_status(key)
   tex.sprint(status)
end

function bridge_cc_core.print_module_to_sfr_table(key, relationtype, tex)
   relationtype = relationtype or "enf"
   sfrs = cc_core.generate_table_module_to_sfr(key, relationtype)
   local result = tablegen.print_sfr_table_for_module(relationtype, sfrs)
   tex.print(result)
end

function bridge_cc_core.print_modules_for_sfr_rows(tex)
   local resulttable = {}
   for sfr in common.labels("mainsfr") do
      enf_modules = cc_core.map_modules_to_sfr(sfr, "enf")
      sup_modules = cc_core.map_modules_to_sfr(sfr, "sup")
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
      tsfi = cc_core.getSfr2Tsfi(sfr)
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
      sfr = cc_core.getTsfi2Sfr(tsfi)
      if #sfr > 0 then
	 local tablerow = tg.generate_sfr_for_tsfi_row(tsfi, sfr)
	 table.insert(resulttable, tablerow)
      end
   end
   tex.print(table.concat(resulttable))
end

function bridge_cc_core.print_subsys_to_sfr_table(key, relationtype, tex)
   relationtype = relationtype or "enf"
   sfrs = cc_core.generate_table_subsys_to_sfr(key, relationtype)
   local result = tablegen.print_sfr_table_for_subsys(relationtype, sfrs)
   tex.print(result)
end

function bridge_cc_core.print_module_to_bundle_table(key, tex)
   bundles = cc_core.generate_table_module_to_bundle(key)
   local result = tablegen.print_bundle_table_for_module(bundles)
   tex.print(result)
end

function bridge_cc_core.print_sf_to_tsfi_table(key, tex)
   tsfis = cc_core.getSf2Tsfi(key)
   local result = tablegen.print_item_list(tsfis, "tsfilink")
   tex.print(result)
end

function bridge_cc_core.print_tsfi_to_sf_table(key, tex)
   sfs = cc_core.getTsfi2Sf(key)
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
      local submod = cc_core.getTestcase2Module(testcase)
      local sfrs = cc_core.getTestcase2Sfr(testcase)
      local tsfis = cc_core.getTestcase2Tsfi(testcase)
      local tablerow = tg.generate_testcase_row(testcase, submod, sfrs, tsfis)
      table.insert(resulttable, tablerow)
   end
   tex.print(table.concat(resulttable))
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

function bridge_cc_core.print_sfr_to_sf_table(tex)
   local sfr_labels = common.generate_label_list("mainsfr")
   local resulttable = {}
   for _,sfr in pairs(sfr_labels) do
      local tablerow = {}
      table.insert(tablerow, sfr)
      table.insert(tablerow, table.concat(cc_core.getSfr2Sf(sfr), ", "))
      table.insert(resulttable, table.concat(tablerow, ": "))
   end
   print(table.concat(resulttable, " "))
   tex.sprint(table.concat(resulttable))
end

return bridge_cc_core
