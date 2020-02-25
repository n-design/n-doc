#!/usr/bin/env texlua

dofile("init_test_db.lua")

local tg = require "table_generator"

lu = require('luaunit')

testtg = {}

function testtg.testitemprinter()
   lu.assertEquals(tg.print_item_list({}, "tsfi"), "(keine)")
   lu.assertEquals(tg.print_item_list({}, "tsfi", {emptyitem="\\todo{Bewerten}"}), "\\todo{Bewerten}")
   lu.assertEquals(tg.print_item_list({"ls.vpnsis"}, "tsfi"), "\\tsfi{ls.vpnsis}")
   lu.assertEquals(tg.print_item_list({"ls.vpnsis"}, "tsfilink"), "\\tsfilink{ls.vpnsis}")
   lu.assertEquals(tg.print_item_list({"ls.lan", "ls.vpnsis"}, "tsfi", {sepchar="&"}), "\\tsfi{ls.lan}&\\tsfi{ls.vpnsis}")
end

bundles = { "de.ndesign.ab.cd", "de.ndesign.ef.gh", "de.ndesign.ij.kl" }
bundletable = [[
\begin{bundletable}Bundles\\\midrule\relax\bundle{de.ndesign.ab.cd}\\\bundle{de.ndesign.ef.gh}\\\bundle{de.ndesign.ij.kl}\\\end{bundletable}]]

function testtg.testbundletable()
   lu.assertEquals(tg.print_bundle_table_for_module(bundles), bundletable)
end

sfrs = {"fmt_msa.3/nk.pf","fpt_stm.1/nk","fpt_tdc.1/nk.zert",
	"fdp_rip.1/nk","fpt_tst.1/nk","fdp_acf.1/nk.update",
	"fdp_itc.1/nk.update","fdp_uit.1/nk.update","fau_stg.1/ak",
	"fau_stg.4/ak","fcs_cop.1/storage.aes",
	"fcs_cop.1/sign","fcs_cop.1/ak.sha","fcs_ckm.1/ak.aes",
	"fcs_ckm.4/ak","fcs_cop.1/ak.sigver.ssa","fcs_cop.1/ak.sigver.pss",
	"fcs_cop.1/ak.sigver.ds2","fcs_cop.1/ak.sigver.ecdsa"}

sfrtable = [[
\begin{enfsfrtable}Enforcing~SFR\\\midrule\relax\sfrlinknoindex{fmt_msa.3/nk.pf} & \sfrlinknoindex{fdp_uit.1/nk.update} & \sfrlinknoindex{fcs_ckm.4/ak}\\\sfrlinknoindex{fpt_stm.1/nk} & \sfrlinknoindex{fau_stg.1/ak} & \sfrlinknoindex{fcs_cop.1/ak.sigver.ssa}\\\sfrlinknoindex{fpt_tdc.1/nk.zert} & \sfrlinknoindex{fau_stg.4/ak} & \sfrlinknoindex{fcs_cop.1/ak.sigver.pss}\\\sfrlinknoindex{fdp_rip.1/nk} & \sfrlinknoindex{fcs_cop.1/storage.aes} & \sfrlinknoindex{fcs_cop.1/ak.sigver.ds2}\\\sfrlinknoindex{fpt_tst.1/nk} & \sfrlinknoindex{fcs_cop.1/sign} & \sfrlinknoindex{fcs_cop.1/ak.sigver.ecdsa}\\\sfrlinknoindex{fdp_acf.1/nk.update} & \sfrlinknoindex{fcs_cop.1/ak.sha}\\\sfrlinknoindex{fdp_itc.1/nk.update} & \sfrlinknoindex{fcs_ckm.1/ak.aes}\\\end{enfsfrtable}]]

function testtg.testiterator_3()
   result = {}
   input = {1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21}
   for col1, col2, col3 in tg.column_iterator_3(input) do
      table.insert(result, col1)
      table.insert(result, col2)
      table.insert(result, col3)
   end
   lu.assertEquals(result, {1,8,15,2,9,16,3,10,17,4,11,18,5,12,19,6,13,20,7,14,21})
end

function testtg.testiterator_4()
   result = {}
   input = {1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24}
   for col1, col2, col3, col4 in tg.column_iterator_4(input) do
      table.insert(result, col1)
      table.insert(result, col2)
      table.insert(result, col3)
      table.insert(result, col4)
   end
   lu.assertEquals(result, {1,7,13,19,2,8,14,20,3,9,15,21,4,10,16,22,5,11,17,23,6,12,18,24})
end


function testtg.testsfrtable()
   result = tg.print_sfr_table_for_module("enf", sfrs)
   lu.assertEquals(result, sfrtable)
end

function testtg.test_modules_for_sfr_row()
    sfr = "fta_tab.1/jobnummer"
    sup_mods = {}
    enf_mods = {"mod.cardservice.core", "mod.cardservice.ctservice", "mod.signservice.core", "mod.signservice.jnrgen"}

    expected_sfr_row = [[\midrule\relax\index{\sfrplain{fta_tab.1/jobnummer}@\sfr{fta_tab.1/jobnummer}|textbf}\hypertarget{fta_tab.1/jobnummer}{\sfr{fta_tab.1/jobnummer}} & Enforcing & \tdslink[fq]{mod.cardservice.core}\\& & \tdslink[fq]{mod.cardservice.ctservice}\\& & \tdslink[fq]{mod.signservice.core}\\& & \tdslink[fq]{mod.signservice.jnrgen}\\& Supporting & (Keine)\\]]

    lu.assertEquals(tg.generate_modules_for_sfr_row(sfr, enf_mods, sup_mods), expected_sfr_row)
end


function testtg.test_modules_num_row_with_status()
   local formatter = tg.itemformatters["modulestatus"]
   local result = formatter("mod.tls.core")
   lu.assertEquals(result, [[\tdslink[fq]{mod.tls.core} & \enfc{}]])
end

os.exit( lu.LuaUnit.run() )
