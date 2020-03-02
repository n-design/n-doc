#!/usr/bin/env texlua

dofile("init_test_bridge.lua")

testbridge = {}

bridge = require("bridge_cc_core")


function testbridge.test_replacelabel()
   bridge.replacelabel("mod.tls.core", "fq", tex.expected("TLS-Server::\\-Core"))
end

function testbridge.test_get_module_status()
   bridge.get_module_status("mod.tls.core", tex.expected("\\enfc{}"))
   bridge.get_module_status("mod.signservice.core", tex.expected("\\nontsf{}"))
end

function testbridge.test_print_module_to_sfr_table()
   local expectedresult=[[\begin{enfsfrtable}Enforcing~SFR\\\midrule\relax\sfrlinknoindex{fcs_ckm.2/tls} & \sfrlinknoindex{fcs_cop.1/tls.auth}\\\sfrlinknoindex{fcs_cop.1/tls.aes} & \sfrlinknoindex{ftp_itc.1/tls}\\\end{enfsfrtable}]]
   bridge.print_module_to_sfr_table("mod.tls.core", "enf", tex.expected(expectedresult))
end

function testbridge.test_print_modules_for_sfr_rows()
  local expectedresult_all = [[\midrule\relax\index{\sfrplain{fcs_ckm.1}@\sfr{fcs_ckm.1}|textbf}\hypertarget{fcs_ckm.1}{\sfr{fcs_ckm.1}} & Enforcing & \tdslink[fq]{mod.cryptsystem.keymgmt}\\& Supporting & (Keine)\\\midrule\relax\index{\sfrplain{fcs_ckm.2/ike}@\sfr{fcs_ckm.2/ike}|textbf}\hypertarget{fcs_ckm.2/ike}{\sfr{fcs_ckm.2/ike}} & Enforcing & \tdslink[fq]{mod.vpn.core}\\& Supporting & (Keine)\\\midrule\relax\index{\sfrplain{fcs_ckm.2/tls}@\sfr{fcs_ckm.2/tls}|textbf}\hypertarget{fcs_ckm.2/tls}{\sfr{fcs_ckm.2/tls}} & Enforcing & \tdslink[fq]{mod.tls.core}\\& Supporting & (Keine)\\\midrule\relax\index{\sfrplain{fcs_ckm.4}@\sfr{fcs_ckm.4}|textbf}\hypertarget{fcs_ckm.4}{\sfr{fcs_ckm.4}} & Enforcing & \tdslink[fq]{mod.cryptsystem.keymgmt}\\& Supporting & (Keine)\\\midrule\relax\index{\sfrplain{fcs_cop.1/hash}@\sfr{fcs_cop.1/hash}|textbf}\hypertarget{fcs_cop.1/hash}{\sfr{fcs_cop.1/hash}} & Enforcing & \tdslink[fq]{mod.cryptsystem.algorithms}\\& Supporting & (Keine)\\\midrule\relax\index{\sfrplain{fcs_cop.1/hmac}@\sfr{fcs_cop.1/hmac}|textbf}\hypertarget{fcs_cop.1/hmac}{\sfr{fcs_cop.1/hmac}} & Enforcing & \tdslink[fq]{mod.cryptsystem.algorithms}\\& Supporting & (Keine)\\\midrule\relax\index{\sfrplain{fcs_cop.1/tls.aes}@\sfr{fcs_cop.1/tls.aes}|textbf}\hypertarget{fcs_cop.1/tls.aes}{\sfr{fcs_cop.1/tls.aes}} & Enforcing & \tdslink[fq]{mod.tls.core}\\& Supporting & (Keine)\\\midrule\relax\index{\sfrplain{fcs_cop.1/tls.auth}@\sfr{fcs_cop.1/tls.auth}|textbf}\hypertarget{fcs_cop.1/tls.auth}{\sfr{fcs_cop.1/tls.auth}} & Enforcing & \tdslink[fq]{mod.tls.core}\\& Supporting & (Keine)\\\midrule\relax\index{\sfrplain{fcs_rng.1/hashdrbg}@\sfr{fcs_rng.1/hashdrbg}|textbf}\hypertarget{fcs_rng.1/hashdrbg}{\sfr{fcs_rng.1/hashdrbg}} & Enforcing & \tdslink[fq]{mod.cryptsystem.rng}\\& Supporting & (Keine)\\\midrule\relax\index{\sfrplain{fdp_rip.1}@\sfr{fdp_rip.1}|textbf}\hypertarget{fdp_rip.1}{\sfr{fdp_rip.1}} & Enforcing & \tdslink[fq]{mod.selfprotect.memory}\\& Supporting & (Keine)\\\midrule\relax\index{\sfrplain{fpt_tdc.1/tls.zert}@\sfr{fpt_tdc.1/tls.zert}|textbf}\hypertarget{fpt_tdc.1/tls.zert}{\sfr{fpt_tdc.1/tls.zert}} & Enforcing & \tdslink[fq]{mod.tls.cert}\\& Supporting & (Keine)\\\midrule\relax\index{\sfrplain{fpt_tdc.1/zert}@\sfr{fpt_tdc.1/zert}|textbf}\hypertarget{fpt_tdc.1/zert}{\sfr{fpt_tdc.1/zert}} & Enforcing & \tdslink[fq]{mod.vpn.cert}\\& Supporting & (Keine)\\\midrule\relax\index{\sfrplain{fpt_stm.1}@\sfr{fpt_stm.1}|textbf}\hypertarget{fpt_stm.1}{\sfr{fpt_stm.1}} & Enforcing & \tdslink[fq]{mod.ntpclient.core}\\& Supporting & (Keine)\\\midrule\relax\index{\sfrplain{fpt_tst.1}@\sfr{fpt_tst.1}|textbf}\hypertarget{fpt_tst.1}{\sfr{fpt_tst.1}} & Enforcing & \tdslink[fq]{mod.selfprotect.selftest}\\& Supporting & \tdslink[fq]{mod.selfprotect.selftest}\\\midrule\relax\index{\sfrplain{ftp_itc.1/tls}@\sfr{ftp_itc.1/tls}|textbf}\hypertarget{ftp_itc.1/tls}{\sfr{ftp_itc.1/tls}} & Enforcing & \tdslink[fq]{mod.tls.core}\\& Supporting & (Keine)\\\midrule\relax\index{\sfrplain{ftp_itc.1/vpn}@\sfr{ftp_itc.1/vpn}|textbf}\hypertarget{ftp_itc.1/vpn}{\sfr{ftp_itc.1/vpn}} & Enforcing & \tdslink[fq]{mod.vpn.core}\\& Supporting & \tdslink[fq]{mod.adminsystem.mgmt}\\\midrule\relax\index{\sfrplain{ftp_trp.1/admin}@\sfr{ftp_trp.1/admin}|textbf}\hypertarget{ftp_trp.1/admin}{\sfr{ftp_trp.1/admin}} & Enforcing & \tdslink[fq]{mod.adminsystem.webserver}\\& Supporting & \tdslink[fq]{mod.vpn.core}\\]]
   bridge.print_modules_for_sfr_rows(tex.expected(expectedresult_all))
end

function testbridge.test_print_tsfi_for_sfr_rows()
   local expectedresult_all = [[\midrule\relax\hypertarget{fcs_ckm.1}{\sfr{fcs_ckm.1}} & \tsfilink{ls.lan.tls}&Schlüsselaushandlung für TLS\\&\tsfilink{ls.wan.ipsec}&Schlüsselaushandlung für VPN\\\midrule\relax\hypertarget{fcs_ckm.2/ike}{\sfr{fcs_ckm.2/ike}} & \tsfilink{ls.wan.ipsec}&Schlüsselverteilung für VPN\\\midrule\relax\hypertarget{fcs_ckm.2/tls}{\sfr{fcs_ckm.2/tls}} & \tsfilink{ls.lan.tls}&Schlüsselverteilung für TLS\\\midrule\relax\hypertarget{fcs_ckm.4}{\sfr{fcs_ckm.4}} & \tsfilink{ls.lan.tls}&TLS Verbindungen im LAN abbauen\\&\tsfilink{ls.wan.ipsec}&IPSEC Verbindungen im WAN abbauen\\\midrule\relax\hypertarget{fcs_cop.1/hash}{\sfr{fcs_cop.1/hash}} & \tsfilink{ls.wan.ipsec}&IPSec Hash Operationen\\&\tsfilink{ls.lan.tls}&TLS Hash Operationen\\\midrule\relax\hypertarget{fcs_cop.1/hmac}{\sfr{fcs_cop.1/hmac}} & \tsfilink{ls.wan.ipsec}&IPSec HMAC Operationen\\&\tsfilink{ls.lan.tls}&TLS HMAC Operationen\\\midrule\relax\hypertarget{fcs_cop.1/tls.aes}{\sfr{fcs_cop.1/tls.aes}} & \tsfilink{ls.lan.tls}&TLS Verbindungen\\\midrule\relax\hypertarget{fcs_cop.1/tls.auth}{\sfr{fcs_cop.1/tls.auth}} & \tsfilink{ls.lan.tls}&TLS Verbindungen\\\midrule\relax\hypertarget{fcs_rng.1/hashdrbg}{\sfr{fcs_rng.1/hashdrbg}} & \tsfilink{ls.lan.tls}&TLS Verbindungen\\&\tsfilink{ls.wan.ipsec}&Schlüsselaushandlung für VPN\\\midrule\relax\hypertarget{fdp_rip.1}{\sfr{fdp_rip.1}} & \tsfilink{no_tsfi}&Sicheres Löschen nicht von außen aufrufbar\\\midrule\relax\hypertarget{fpt_tdc.1/tls.zert}{\sfr{fpt_tdc.1/tls.zert}} & \tsfilink{ls.lan.tls}&TLS Zertifikate prüfen\\\midrule\relax\hypertarget{fpt_tdc.1/zert}{\sfr{fpt_tdc.1/zert}} & \tsfilink{ls.wan.ipsec}&VPN Zertifikate prüfen\\\midrule\relax\hypertarget{fpt_stm.1}{\sfr{fpt_stm.1}} & \tsfilink{ls.wan.ntp}&Zugang zum Zeitdienst\\\midrule\relax\hypertarget{fpt_tst.1}{\sfr{fpt_tst.1}} & \tsfilink{ls.lan.httpmgmt}&Aufruf des Selbsttests\\\midrule\relax\hypertarget{ftp_itc.1/tls}{\sfr{ftp_itc.1/tls}} & \tsfilink{ls.lan.tls}&Sichere Verbindung zur Managemantschnittstelle\\\midrule\relax\hypertarget{ftp_itc.1/vpn}{\sfr{ftp_itc.1/vpn}} & \tsfilink{ls.wan.ipsec}&Sicherer IPSec Tunnel\\\midrule\relax\hypertarget{ftp_trp.1/admin}{\sfr{ftp_trp.1/admin}} & \tsfilink{ls.lan.httpmgmt}&Verbindung zur Managemantschnittstelle\\]]
   bridge.print_tsfi_for_sfr_rows(tex.expected(expectedresult_all))
end

function testbridge.test_print_sfr_for_tsfi_rows()
   local expectedresult_all = [[\midrule\relax\hypertarget{ls.lan.httpmgmt}{\tsfi{ls.lan.httpmgmt}} & \sfrlink{fpt_tst.1}&Aufruf des Selbsttests\\&\sfrlink{ftp_trp.1/admin}&Verbindung zur Managemantschnittstelle\\\midrule\relax\hypertarget{ls.lan.tls}{\tsfi{ls.lan.tls}} & \sfrlink{fcs_ckm.1}&Schlüsselaushandlung für TLS\\&\sfrlink{fcs_ckm.2/tls}&Schlüsselverteilung für TLS\\&\sfrlink{fcs_ckm.4}&TLS Verbindungen im LAN abbauen\\&\sfrlink{fcs_cop.1/hash}&TLS Hash Operationen\\&\sfrlink{fcs_cop.1/hmac}&TLS HMAC Operationen\\&\sfrlink{fcs_cop.1/tls.aes}&TLS Verbindungen\\&\sfrlink{fcs_cop.1/tls.auth}&TLS Verbindungen\\&\sfrlink{fcs_rng.1/hashdrbg}&TLS Verbindungen\\&\sfrlink{fpt_tdc.1/tls.zert}&TLS Zertifikate prüfen\\&\sfrlink{ftp_itc.1/tls}&Sichere Verbindung zur Managemantschnittstelle\\\midrule\relax\hypertarget{ls.wan.ipsec}{\tsfi{ls.wan.ipsec}} & \sfrlink{fcs_ckm.1}&Schlüsselaushandlung für VPN\\&\sfrlink{fcs_ckm.2/ike}&Schlüsselverteilung für VPN\\&\sfrlink{fcs_ckm.4}&IPSEC Verbindungen im WAN abbauen\\&\sfrlink{fcs_cop.1/hash}&IPSec Hash Operationen\\&\sfrlink{fcs_cop.1/hmac}&IPSec HMAC Operationen\\&\sfrlink{fcs_rng.1/hashdrbg}&Schlüsselaushandlung für VPN\\&\sfrlink{fpt_tdc.1/zert}&VPN Zertifikate prüfen\\&\sfrlink{ftp_itc.1/vpn}&Sicherer IPSec Tunnel\\\midrule\relax\hypertarget{ls.wan.ntp}{\tsfi{ls.wan.ntp}} & \sfrlink{fpt_stm.1}&Zugang zum Zeitdienst\\\midrule\relax\hypertarget{no_tsfi}{\tsfi{no_tsfi}} & \sfrlink{fdp_rip.1}&Sicheres Löschen nicht von außen aufrufbar\\]]
   bridge.print_sfr_for_tsfi_rows(tex.expected(expectedresult_all))
end

function testbridge.test_print_subsys_to_sfr_table()
   local expectedresult = [[\begin{enfsfrsubsystable}Enforcing~SFR & Beschreibung\\\midrule\relax\sfrlinknoindex{fcs_ckm.2/tls} & Verbindungsaufbau, Schlüsselverteilung für TLS\\\sfrlinknoindex{fcs_cop.1/tls.aes} & AES für TLS bereitstellen\\\sfrlinknoindex{fcs_cop.1/tls.auth} & Authentisierung des TLS-Partners\\\sfrlinknoindex{fpt_tdc.1/tls.zert} & Zertifikatsprüfung\\\sfrlinknoindex{ftp_itc.1/tls} & TLS-Verbindungen starten/beenden\\\end{enfsfrsubsystable}]]
   bridge.print_subsys_to_sfr_table("sub.tls", "enf", tex.expected(expectedresult))
end

function testbridge.test_print_module_to_bundle_table()
   local expectedresult = [[\begin{bundletable}Bundles\\\midrule\relax\bundle{openvpn}\\\end{bundletable}]]
   bridge.print_module_to_bundle_table("mod.vpn.core", tex.expected(expectedresult))
end

function testbridge.test_print_sf_to_tsfi_table()
   local expectedresult = [[\tsfilink{ls.lan.tls}]]
   bridge.print_sf_to_tsfi_table("sf.tls", tex.expected(expectedresult))
end

function testbridge.test_print_tsfi_to_sf_table()
   local expectedresult = [[\secfunclink{sf.cryptographicservices}, \secfunclink{sf.tls}]]
   bridge.print_tsfi_to_sf_table("ls.lan.tls", tex.expected(expectedresult))
end

function testbridge.test_getSfr()
   bridge.getSfr("fcs_cop.1.1/hmac", tex.expected([[FCS\_COP.1.1/HMAC]]))
end

function testbridge.test_getSfrText()
   bridge.getSfrText("fcs_cop.1.1/hmac", tex.expected([[Cryptographic operation/HMAC]]))
end

function testbridge.test_removeSfrSubComponent()
   bridge.removeSfrSubComponent([[fau_stg.4/ak]], tex.expected([[fau_stg.4/ak]]))
   bridge.removeSfrSubComponent([[fcs_ckm.1.1/ak.aes]], tex.expected([[fcs_ckm.1/ak.aes]]))
   bridge.removeSfrSubComponent([[fcs_ckm.1.1/nk]], tex.expected([[fcs_ckm.1/nk]]))
   bridge.removeSfrSubComponent([[FCS_CKM.1.1/NK.TLS]], tex.expected([[fcs_ckm.1/nk.tls]]))
   bridge.removeSfrSubComponent([[fcs_ckm.1.1/nk.zert]], tex.expected([[fcs_ckm.1/nk.zert]]))
   bridge.removeSfrSubComponent([[fcs_ckm.1/ak.aes]], tex.expected([[fcs_ckm.1/ak.aes]]))
   bridge.removeSfrSubComponent([[FCS_CKM.1/NK]], tex.expected([[fcs_ckm.1/nk]]))
end


function testbridge.test_getSecfunc()
   bridge.getSecfunc("sf.cryptographicservices", tex.expected([[SF.Cryp\-to\-gra\-phic\-Ser\-vices]]))
end

function testbridge.test_getSecfuncText()
   bridge.getSecfuncText("sf.cryptographicservices", tex.expected([[Kryptografische Dienste]]))
end

function testbridge.test_getObjective()
   bridge.getObjective("o.zeitdienst", tex.expected([[O.Zeitdienst]]))
end

function testbridge.test_getObjectiveText()
   bridge.getObjectiveText("o.zeitdienst", tex.expected([[Nutzung eines sicheren Zeitdienstes]]))
end

function testbridge.test_getObjectiveSource()
   bridge.getObjectiveSource("o.zeitdienst", tex.expected([[4.1.1]]))
end

function testbridge.test_getTsfi()
   bridge.getTsfi("ls.lan.tls", tex.expected([[LS.LAN.TLS]]))
end

function testbridge.test_print_testcase_table()
   expected_result = [[adminsystem1 & \tdslink[fq]{mod.adminsystem.webserver} & \sfr{ftp_trp.1/admin} & \tsfi{ls.lan.httpmgmt}\\__1exadminsystem2 & \tdslink[fq]{mod.adminsystem.webserver} & \sfr{ftp_trp.1/admin} & \tsfi{ls.lan.httpmgmt}\\__1exadminsystem3 & \tdslink[fq]{mod.adminsystem.webserver} & \sfr{ftp_trp.1/admin} & \tsfi{ls.lan.httpmgmt}\\__1excryptsystem1 & \tdslink[fq]{mod.cryptsystem.algorithms} & \sfr{fcs_cop.1/hash} & \tsfi{ls.lan.tls}, \tsfi{ls.wan.ipsec}\\__1excryptsystem2 & \tdslink[fq]{mod.cryptsystem.algorithms} & \sfr{fcs_cop.1/hash} & \tsfi{ls.lan.tls}, \tsfi{ls.wan.ipsec}\\__1excryptsystem3 & \tdslink[fq]{mod.cryptsystem.algorithms} & \sfr{fcs_cop.1/hmac} & \tsfi{ls.lan.tls}, \tsfi{ls.wan.ipsec}\\__1excryptsystem4 & \tdslink[fq]{mod.cryptsystem.keymgmt} & \sfr{fcs_ckm.1} & \tsfi{ls.lan.tls}, \tsfi{ls.wan.ipsec}\\__1excryptsystem5 & \tdslink[fq]{mod.cryptsystem.keymgmt} & \sfr{fcs_ckm.4} & \tsfi{ls.lan.tls}, \tsfi{ls.wan.ipsec}\\__1excryptsystem6 & \tdslink[fq]{mod.cryptsystem.rng} & \sfr{fcs_rng.1/hashdrbg} & \tsfi{ls.lan.tls}, \tsfi{ls.wan.ipsec}\\__1exntp1 & \tdslink[fq]{mod.ntpclient.core} & \sfr{fpt_stm.1} & \tsfi{ls.wan.ntp}\\__1exntp2 & \tdslink[fq]{mod.ntpclient.core} & \sfr{fpt_stm.1} & \tsfi{ls.wan.ntp}\\__1exselfprotect1 & \tdslink[fq]{mod.selfprotect.memory} & \sfr{fdp_rip.1} & \tsfi{no_tsfi}\\__1exselfprotect2 & \tdslink[fq]{mod.selfprotect.selftest} & \sfr{fpt_tst.1} & \tsfi{ls.lan.httpmgmt}\\__1extls1 & \tdslink[fq]{mod.tls.core} & \sfr{ftp_itc.1/tls}, \sfr{fcs_ckm.2/tls}, \sfr{fcs_cop.1/tls.aes}, \sfr{fcs_cop.1/tls.auth} & \tsfi{ls.lan.tls}\\__1extls2 & \tdslink[fq]{mod.tls.core} & \sfr{ftp_itc.1/tls}, \sfr{fcs_ckm.2/tls}, \sfr{fcs_cop.1/tls.aes}, \sfr{fcs_cop.1/tls.auth} & \tsfi{ls.lan.tls}\\__1extls3 & \tdslink[fq]{mod.tls.cert} & \sfr{fpt_tdc.1/tls.zert} & \tsfi{ls.lan.tls}\\__1extls4 & \tdslink[fq]{mod.tls.cert} & \sfr{fpt_tdc.1/tls.zert} & \tsfi{ls.lan.tls}\\__1extls5 & \tdslink[fq]{mod.tls.cert} & \sfr{fpt_tdc.1/tls.zert} & \tsfi{ls.lan.tls}\\__1exvpn1 & \tdslink[fq]{mod.vpn.core} & \sfr{ftp_itc.1/vpn}, \sfr{fcs_ckm.2/ike} & \tsfi{ls.wan.ipsec}\\__1exvpn2 & \tdslink[fq]{mod.vpn.core} & \sfr{ftp_itc.1/vpn}, \sfr{fcs_ckm.2/ike} & \tsfi{ls.wan.ipsec}\\__1exvpn3 & \tdslink[fq]{mod.vpn.cert} & \sfr{fpt_tdc.1/zert} & \tsfi{ls.wan.ipsec}\\__1exvpn4 & \tdslink[fq]{mod.vpn.cert} & \sfr{fpt_tdc.1/zert} & \tsfi{ls.wan.ipsec}\\__1exvpn5 & \tdslink[fq]{mod.vpn.cert} & \sfr{fpt_tdc.1/zert} & \tsfi{ls.wan.ipsec}\\__1ex]]
   bridge.print_testcase_table(tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_sfr_to_num_testcase_table()
   expected_result = [[\sfr{fcs_ckm.1} & 1 & \sfr{fcs_cop.1/hmac} & 1 & \sfr{fpt_tdc.1/tls.zert} & 3 & \sfr{ftp_itc.1/vpn} & 2\\\sfr{fcs_ckm.2/ike} & 2 & \sfr{fcs_cop.1/tls.aes} & 2 & \sfr{fpt_tdc.1/zert} & 3 & \sfr{ftp_trp.1/admin} & 3\\\sfr{fcs_ckm.2/tls} & 2 & \sfr{fcs_cop.1/tls.auth} & 2 & \sfr{fpt_stm.1} & 2\\\sfr{fcs_ckm.4} & 1 & \sfr{fcs_rng.1/hashdrbg} & 1 & \sfr{fpt_tst.1} & 1\\\sfr{fcs_cop.1/hash} & 2 & \sfr{fdp_rip.1} & 1 & \sfr{ftp_itc.1/tls} & 2\\]]
   bridge.print_sfr_to_num_testcase_table(tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_tsfi_to_num_testcase_table()
   expected_result = [[\tsfi{ls.lan} & 0 & \tsfi{ls.lan.udp} & 0 & \tsfi{ls.wan.ipsec} & 11\\\tsfi{ls.lan.ether} & 0 & \tsfi{ls.led} & 0 & \tsfi{ls.wan.ntp} & 2\\\tsfi{ls.lan.httpmgmt} & 4 & \tsfi{ls.wan} & 0 & \tsfi{ls.wan.tcp} & 0\\\tsfi{ls.lan.ip} & 0 & \tsfi{ls.wan.dhcp} & 0 & \tsfi{ls.wan.udp} & 0\\\tsfi{ls.lan.tcp} & 0 & \tsfi{ls.wan.ether} & 0 & \tsfi{no_tsfi} & 1\\\tsfi{ls.lan.tls} & 11 & \tsfi{ls.wan.ip} & 0\\]]
   bridge.print_tsfi_to_num_testcase_table(tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_module_to_num_testcase_table()
   expected_result = [[\tdslink[fq]{mod.adminsystem.mgmt} & \supp{} & 0 & \tdslink[fq]{mod.cryptsystem.rng} & \enfc{} & 1 & \tdslink[fq]{mod.tls.cert} & \enfc{} & 3\\\tdslink[fq]{mod.adminsystem.webserver} & \enfc{} & 3 & \tdslink[fq]{mod.ntpclient.core} & \enfc{} & 2 & \tdslink[fq]{mod.tls.core} & \enfc{} & 2\\\tdslink[fq]{mod.cryptsystem.algorithms} & \enfc{} & 3 & \tdslink[fq]{mod.selfprotect.memory} & \enfc{} & 1 & \tdslink[fq]{mod.vpn.cert} & \enfc{} & 3\\\tdslink[fq]{mod.cryptsystem.keymgmt} & \enfc{} & 2 & \tdslink[fq]{mod.selfprotect.selftest} & \enfc{} & 1 & \tdslink[fq]{mod.vpn.core} & \enfc{} & 2\\]]
   bridge.print_module_to_num_testcase_table(tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_sf_table_header()
   expected_result = [[& \rot{\textsmaller[1]{\secfunclink{sf.administration}}} & \rot{\textsmaller[1]{\secfunclink{sf.cryptographicservices}}} & \rot{\textsmaller[1]{\secfunclink{sf.networkservices}}} & \rot{\textsmaller[1]{\secfunclink{sf.selfprotection}}} & \rot{\textsmaller[1]{\secfunclink{sf.tls}}} & \rot{\textsmaller[1]{\secfunclink{sf.vpn}}} ]]
   -- bridge.print_sfr_to_sf_table_header(tex.expected(expected_result:gsub("__1ex", "[1ex]")))
   bridge.print_table_header("sf", "secfunclink", tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_obj_table_header()
   expected_result = [[& \rot{\textsmaller[1]{\objlink{o.admin}}} & \rot{\textsmaller[1]{\objlink{o.schutz}}} & \rot{\textsmaller[1]{\objlink{o.tlscrypto}}} & \rot{\textsmaller[1]{\objlink{o.vpn_auth}}} & \rot{\textsmaller[1]{\objlink{o.vpn_integrität}}} & \rot{\textsmaller[1]{\objlink{o.vpn_vertraul}}} & \rot{\textsmaller[1]{\objlink{o.zeitdienst}}} & \rot{\textsmaller[1]{\objlink{o.zert_prüf}}} & \rot{\textsmaller[1]{\objlink{oe.echtzeituhr}}} ]]
   bridge.print_table_header("obj", "objlink", tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_sfr_to_sf_table_body()
   expected_result = [[\textsmaller[1]{\sfrlinknoindex{fcs_ckm.1}} & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_ckm.2/ike}} & \tno & \tno & \tno & \tno & \tno & \tcheck\\\textsmaller[1]{\sfrlinknoindex{fcs_ckm.2/tls}} & \tno & \tno & \tno & \tno & \tcheck & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_ckm.4}} & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_cop.1/hash}} & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_cop.1/hmac}} & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_cop.1/tls.aes}} & \tno & \tno & \tno & \tno & \tcheck & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_cop.1/tls.auth}} & \tno & \tno & \tno & \tno & \tcheck & \tno\\\textsmaller[1]{\sfrlinknoindex{fcs_rng.1/hashdrbg}} & \tno & \tcheck & \tno & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fdp_rip.1}} & \tno & \tno & \tno & \tcheck & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fpt_tdc.1/tls.zert}} & \tno & \tno & \tno & \tno & \tcheck & \tno\\\textsmaller[1]{\sfrlinknoindex{fpt_tdc.1/zert}} & \tno & \tno & \tno & \tno & \tno & \tcheck\\\textsmaller[1]{\sfrlinknoindex{fpt_stm.1}} & \tno & \tno & \tcheck & \tno & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{fpt_tst.1}} & \tno & \tno & \tno & \tcheck & \tno & \tno\\\textsmaller[1]{\sfrlinknoindex{ftp_itc.1/tls}} & \tno & \tno & \tno & \tno & \tcheck & \tno\\\textsmaller[1]{\sfrlinknoindex{ftp_itc.1/vpn}} & \tno & \tno & \tno & \tno & \tno & \tcheck\\\textsmaller[1]{\sfrlinknoindex{ftp_trp.1/admin}} & \tcheck & \tno & \tno & \tno & \tno & \tno\\]]
   bridge.print_table_body("mainsfr", "sf", "sfrlinknoindex", cc_core.getSfr2Sf, tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end

function testbridge.test_print_spd_to_obj_table_body()
   expected_result = [[\textsmaller[1]{\spdlink{t.wan.client}} & \tno & \tno & \tno & \tcheck & \tcheck & \tcheck & \tno & \tno & \tno\\\textsmaller[1]{\spdlink{t.lan.admin}} & \tcheck & \tcheck & \tcheck & \tno & \tno & \tno & \tno & \tno & \tno\\\textsmaller[1]{\spdlink{t.zert_prüf}} & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tcheck & \tno\\\textsmaller[1]{\spdlink{t.timesync}} & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tcheck\\\textsmaller[1]{\spdlink{osp.tls}} & \tno & \tcheck & \tcheck & \tno & \tno & \tno & \tno & \tno & \tno\\\textsmaller[1]{\spdlink{osp.zeitdienst}} & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tcheck\\\textsmaller[1]{\spdlink{a.guidance}} & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tno & \tno\\]]
   bridge.print_table_body("spd", "obj", "spdlink", cc_core.getSpd2Obj, tex.expected(expected_result:gsub("__1ex", "[1ex]")))
end


-- function printTlsConnectionTable()
--    bridge.printTlsConnectionTable(tex)
-- end

-- function getTlsConnectionTableRow(key, document)
--    bridge.getTlsConnectionTableRow(key, document, tex)
-- end

-- function printTlsParametersForModule(key)
--    bridge.printTlsParametersForModule(key, tex)
-- end

-- function getError(key)
--    bridge.getError(key, tex)
-- end

os.exit( lu.LuaUnit.run() )
