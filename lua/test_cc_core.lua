#!/usr/bin/env texlua

dofile("init_test_db.lua")

local cc_core = require "cc_core"

lu = require('luaunit')

test_cc_core = {}

-- Nur lokale Tests, verwenden keine Datenbank
function test_cc_core.test_removesubcomponent()
   lu.assertEquals(cc_core.removeSfrSubComponent("fau_stg.4/ak"), "fau_stg.4/ak")
   lu.assertEquals(cc_core.removeSfrSubComponent("fcs_ckm.1.1/ak.aes"), "fcs_ckm.1/ak.aes")
   lu.assertEquals(cc_core.removeSfrSubComponent("fcs_ckm.1.1/nk"), "fcs_ckm.1/nk")
   lu.assertEquals(cc_core.removeSfrSubComponent("FCS_CKM.1.1/NK.TLS"), "fcs_ckm.1/nk.tls")
   lu.assertEquals(cc_core.removeSfrSubComponent("fcs_ckm.1.1/nk.zert"), "fcs_ckm.1/nk.zert")
   lu.assertEquals(cc_core.removeSfrSubComponent("fcs_ckm.1/ak.aes"), "fcs_ckm.1/ak.aes")
   lu.assertEquals(cc_core.removeSfrSubComponent("FCS_CKM.1/NK"), "fcs_ckm.1/nk")
   lu.assertEquals(cc_core.removeSfrSubComponent("fcs_ckm.1/nk.tls"), "fcs_ckm.1/nk.tls")
   lu.assertEquals(cc_core.removeSfrSubComponent("fcs_ckm.1/nk.zert"), "fcs_ckm.1/nk.zert")
   lu.assertEquals(cc_core.removeSfrSubComponent("fcs_ckm.2.1/nk.ike"), "fcs_ckm.2/nk.ike")
   lu.assertEquals(cc_core.removeSfrSubComponent("fcs_ckm.2/nk.ike"), "fcs_ckm.2/nk.ike")
   lu.assertEquals(cc_core.removeSfrSubComponent("fcs_ckm.4.1/ak"), "fcs_ckm.4/ak")
   lu.assertEquals(cc_core.removeSfrSubComponent("fcs_ckm.4.1/nk"), "fcs_ckm.4/nk")
   lu.assertEquals(cc_core.removeSfrSubComponent("fcs_ckm.4/ak"), "fcs_ckm.4/ak")
   lu.assertEquals(cc_core.removeSfrSubComponent("fcs_ckm.4/nk"), "fcs_ckm.4/nk")
   lu.assertEquals(cc_core.removeSfrSubComponent("fcs_cop.1.1/ak.aes"), "fcs_cop.1/ak.aes")
   lu.assertEquals(cc_core.removeSfrSubComponent("fmt_mof.1.1"), "fmt_mof.1")
   lu.assertEquals(cc_core.removeSfrSubComponent("fdp_rip.1/ak"), "fdp_rip.1/ak")
   lu.assertEquals(cc_core.removeSfrSubComponent("fmt_smf.1.1"), "fmt_smf.1")
   lu.assertEquals(cc_core.removeSfrSubComponent("fia_api.1.1"), "fia_api.1")
   lu.assertEquals(cc_core.removeSfrSubComponent("fmt_msa.4.1"), "fmt_msa.4")
   lu.assertEquals(cc_core.removeSfrSubComponent("fia_uau.1.1"), "fia_uau.1")
end

function test_cc_core.test_sfr()
   lu.assertEquals(cc_core.getSfr("fcs_rng.1/hashdrbg"), "FCS\\_RNG.1/Hash\\_DRBG")
   lu.assertEquals(cc_core.getSfrText("fcs_rng.1/hashdrbg"), "Zufallszahlenerzeugung")
   lu.assertEquals(cc_core.getSfr("fcs_rng.1/xxx"), "\\textcolor{red}{fcs\\_rng.1/xxx is undefined}")
end

function test_cc_core.test_objectives()
   obj = "o.tlscrypto"
   lu.assertEquals(cc_core.getObjective(obj), [[O.TLS\_Krypto]])
   lu.assertEquals(cc_core.getObjectiveText(obj), "TLS-Kanäle mit sicheren kryptographische Algorithmen")
   lu.assertEquals(cc_core.getObjectiveSource(obj), "4.1.1")
end

function test_cc_core.test_subjobj()
   subject = "s_admin"
   lu.assertEquals(cc_core.getSubjobj(subject), [[S\_Administrator]])
   lu.assertEquals(cc_core.getSubjobjText(subject), "Subjekt, das für einen Administrator handelt.")
end

function test_cc_core.test_subjobj_to_sfr()
   subject = "s_admin"
   lu.assertEquals(cc_core.getSubjobj2Sfr(subject), {"ftp_trp.1/admin"})
end

function test_cc_core.test_sfr_to_subjobj()
   sfr = "ftp_trp.1/admin"
   lu.assertEquals(cc_core.getSfr2Subjobj(sfr), {"s_admin"})
end


function test_cc_core.test_spd()
   spd = "t.lan.admin"
   lu.assertEquals(cc_core.getSpd(spd), [[T.LAN.Admin]])
   lu.assertEquals(cc_core.getSpdText(spd), "Datenverkehr zur Managementschnittstelle abhören")
   lu.assertEquals(cc_core.getSpdSource(spd), "3.2")
end

function test_cc_core.test_spd_to_obj()
   lu.assertEquals(cc_core.getSpd2Obj("t.lan.admin"), {"o.admin", "o.tlscrypto", "o.schutz"})
   lu.assertEquals(cc_core.getSpd2Obj("a.guidance"), {""})
end

function test_cc_core.test_secfunc()
   lu.assertEquals(cc_core.getSecfunc("sf.cryptographicservices"), [[SF.Cryp\-to\-gra\-phic\-Ser\-vices]])
   lu.assertEquals(cc_core.getSecfuncText("sf.cryptographicservices"), "Kryptografische Dienste")
   lu.assertEquals(cc_core.getSecfunc("sf.xxx"), "\\textcolor{red}{sf.xxx is undefined}")
end

function test_cc_core.test_tsfi()
   lu.assertEquals(cc_core.getTsfi("ls.lan.tls"), "LS.LAN.TLS")
   lu.assertEquals(cc_core.getTsfi("ls.wan.ipsec"), "LS.WAN.IPSec")
end

function test_cc_core.test_sf_to_tsfi()
   lu.assertEquals(cc_core.getSf2Tsfi("sf.cryptographicservices"), {
    "ls.lan.tls", "ls.wan.ipsec"})
end

function test_cc_core.test_tsfi_to_sf()
   lu.assertEquals(cc_core.getTsfi2Sf("ls.wan.ntp"), {"sf.networkservices"})
   lu.assertEquals(cc_core.getTsfi2Sf("ls.lan.ipxxx"), {})
end

function test_cc_core.test_sfr_to_tsfi()
   lu.assertEquals(cc_core.getSfr2Tsfi("fcs_ckm.4"), --
		   {{label = "ls.lan.tls", purpose = "TLS Verbindungen im LAN abbauen"},
		      {label = "ls.wan.ipsec", purpose = "IPSEC Verbindungen im WAN abbauen"}})
   lu.assertEquals(cc_core.getSfr2Tsfi("fmt_msa.3.1/sig"), {})
end

function test_cc_core.test_tsfi_to_sfr()
   lu.assertEquals(cc_core.getTsfi2Sfr("ls.wan.ipsec"), --
		   {{label = "fcs_ckm.1", purpose = "Schlüsselaushandlung für VPN"},
		      {label = "fcs_ckm.2/ike", purpose = "Schlüsselverteilung für VPN"},
		      {label = "fcs_ckm.4", purpose = "IPSEC Verbindungen im WAN abbauen"},
		      {label = "fcs_cop.1/hash", purpose = "IPSec Hash Operationen"},
		      {label = "fcs_cop.1/hmac", purpose = "IPSec HMAC Operationen"},
		      {label = "fcs_rng.1/hashdrbg", purpose = "Schlüsselaushandlung für VPN"},
		      {label = "fpt_tdc.1/zert", purpose = "VPN Zertifikate prüfen"},
		      {label = "ftp_itc.1/vpn", purpose = "Sicherer IPSec Tunnel"}})
   lu.assertEquals(cc_core.getTsfi2Sfr("ls.lan.cetp"), {})
end

function test_cc_core.test_ate_testcase()
   lu.assertEquals(cc_core.getTestcase("vpn1"), [[VPN_1]] )
end

function test_cc_core.test_ate_testcase_to_sfr()
   lu.assertEquals(cc_core.getTestcase2Sfr("cryptsystem6"), {"fcs_rng.1/hashdrbg"})
end

function test_cc_core.test_ate_testcase_to_tsfi()
   lu.assertEquals(cc_core.getTestcase2Tsfi("adminsystem1"), {"ls.lan.httpmgmt"})
end

function test_cc_core.test_ate_testcase_to_module()
   lu.assertEquals(cc_core.getTestcase2Module("selfprotect1"), {"mod.selfprotect.memory"})
end

function test_cc_core.test_get_testcases() lu.assertEquals(cc_core.getTestcases(),
   {"adminsystem1", "adminsystem2", "adminsystem3", "cryptsystem1",
   "cryptsystem2", "cryptsystem3", "cryptsystem4", "cryptsystem5",
   "cryptsystem6", "ntp1", "ntp2", "selfprotect1", "selfprotect2", "tls1",
   "tls2", "tls3", "tls4", "tls5", "vpn1", "vpn2", "vpn3", "vpn4", "vpn5" }) end

function test_cc_core.test_ate_number_of_testcases_to_tsfi()
   lu.assertEquals(cc_core.getNumberOfTestcasesTsfi("ls.lan.httpmgmt"), "4")
end

function test_cc_core.test_ate_number_of_testcases_to_sfr()
   lu.assertEquals(cc_core.getNumberOfTestcasesSfr("fpt_tdc.1/tls.zert"), "3")
end

function test_cc_core.test_ate_number_of_testcases_to_subsfr()
   lu.assertEquals(cc_core.getNumberOfTestcasesSfr("fpt_tdc.1/tls.zert"), "3")
end

function test_cc_core.test_ate_number_of_testcases_to_main_sfr()
   lu.assertEquals(cc_core.getNumberOfTestcasesMainSfr("fcs_cop.1/tls.aes"), 2)
end

function test_cc_core.test_ate_number_of_testcases_to_module()
   lu.assertEquals(cc_core.getNumberOfTestcasesModule("mod.cryptsystem.algorithms"), "3")
end

function test_cc_core.testreplacelabel()
   lu.assertEquals(cc_core.replacelabel("sub.tls"), [[TLS-Server]])
   lu.assertEquals(cc_core.replacelabel("mod.tls.core"), [[Core]])
   lu.assertEquals(cc_core.replacelabel("int.tls.core.accept"), [[TLS-Connection-Accept]])
   lu.assertEquals(cc_core.replacelabel("sub.tls", true), [[TLS-Server]])
   lu.assertEquals(cc_core.replacelabel("mod.tls.core", true), "TLS-Server::\\-Core")
   lu.assertEquals(cc_core.replacelabel("int.tls.core.accept", true), "TLS-Server::\\-Core//\\-TLS-Connection-Accept")
   lu.assertEquals(cc_core.replacelabel("sub.xxx", true),  "\\textcolor{red}{sub.xxx is undefined}")
   lu.assertEquals(cc_core.replacelabel("mod.adminservice.xxx", true), "\\textcolor{red}{mod.adminservice.xxx is undefined}")
end

function test_cc_core.test_module_to_sfr()
   expected_sup_modules = {"mod.vpn.core"}
   expected_enf_modules = {"mod.adminsystem.webserver"}
   lu.assertEquals(cc_core.map_modules_to_sfr("ftp_trp.1/admin"), expected_enf_modules)
   lu.assertEquals(cc_core.map_modules_to_sfr("ftp_trp.1/admin", "sup"), expected_sup_modules)
end

function test_cc_core.test_sfr_to_module()
   local sfr = "ftp_trp.1/admin"
   expected_sup_modules = {"mod.vpn.core"}
   expected_enf_modules = {"mod.adminsystem.webserver"}
   lu.assertEquals(cc_core.generate_table_sfr_to_module(sfr, "enf"), expected_enf_modules)
   lu.assertEquals(cc_core.generate_table_sfr_to_module(sfr, "sup"), expected_sup_modules)
end

function test_cc_core.test_Module2Sfr() local mod = "mod.tls.core"
   lu.assertEquals(cc_core.generate_table_module_to_sfr(mod, "enf"),
		   {"fcs_ckm.2/tls", "fcs_cop.1/tls.aes", "fcs_cop.1/tls.auth", "ftp_itc.1/tls"})
   supportingsfr = {"ftp_trp.1/admin"}
   lu.assertEquals(cc_core.generate_table_module_to_sfr("mod.vpn.core", "sup"), supportingsfr)
end

function test_cc_core.testSubmod2Bundle()
   lu.assertEquals(cc_core.generate_table_module_to_bundle("mod.tls.core", "enf"),
		   { "openssl"} )
   lu.assertEquals(cc_core.generate_table_module_to_bundle("mod.subxxx.modyyy", "enf"), {} )
end


function test_cc_core.test_get_module_status()
   lu.assertEquals(cc_core.get_module_status("mod.tls.core"), "\\enfc{}")
   lu.assertEquals(cc_core.get_module_status("mod.adminsystem.mgmt"), "\\supp{}")   
end

function test_cc_core.test_getSfr2Sf()
   lu.assertEquals(cc_core.getSfr2Sf("fcs_ckm.1"), {"sf.cryptographicservices"})
end

function print_sfr_2_submod(sfr, relationtype)
   print ("\n" .. relationtype .. " SFR auf Module abbilden: " .. sfr)
   submods = t.generate_table_sfr_to_module(sfr, relationtype)
   for _,v in ipairs(submods) do
      print (v)
   end
end

function print_bundle_2_submod(bundle)
   print ("\nBundle auf Module abbilden: " .. bundle)
   submods = t.generate_table_bundle_to_module(bundle)
   for _,v in ipairs(submods) do
      print (v) --.subname .. "::" .. v.modname)
   end
end

function print_submod_2_sfr(key, relationtype)
   print ("\nModule auf SFR abbilden: " .. key)
   sfrs = t.generate_table_module_to_sfr(key, relationtype)
   print ("Anzahl: " .. #sfrs)
   for _,v in pairs(sfrs) do
      print (v)
   end
   print()
   g = require "table_generator"
   g.print_sfr_table_for_module(relationtype, sfrs)
end

function print_submod_2_bundle(key)
   print ("\nModule auf Bundles abbilden: " .. key)
   bundles = t.generate_table_module_to_bundle(key)
   print ("Anzahl: " .. #bundles)
   for _,v in pairs(bundles) do
      print (v)
   end
   print()
   g = require "table_generator"
   g.print_bundle_table_for_module(bundles)
end

os.exit( lu.LuaUnit.run() )

