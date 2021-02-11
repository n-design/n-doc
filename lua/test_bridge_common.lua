#!/usr/bin/env texlua

dofile("init_test_bridge.lua")

testbridge = {}

function testbridge.test_replaceUnderscore()
   bridge_common.replaceUnderscore("tuc_kon_000", tex.expected("tuc\\_kon\\_000"))
end

function testbridge.test_remove_smart_hyphen()
   bridge_common.remove_smart_hyphen([[SF.Card\-Ter\-min\-al\-Mgmt]], tex.expected("SF.CardTerminalMgmt"))
end

function testbridge.test_iterator()
   thelabels = {}
   for i in bridge_common.labels("tsfi") do
      table.insert(thelabels, i)
   end
   lu.assertEquals({"ls.lan", "ls.lan.ether", "ls.lan.httpmgmt", "ls.lan.ip", "ls.lan.tcp", "ls.lan.tls", "ls.lan.udp", "ls.led", "ls.wan", "ls.wan.dhcp", "ls.wan.ether", "ls.wan.ip", "ls.wan.ipsec", "ls.wan.ntp", "ls.wan.tcp", "ls.wan.udp", "no_tsfi"}, thelabels)
end

os.exit( lu.LuaUnit.run() )
